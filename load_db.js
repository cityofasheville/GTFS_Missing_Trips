const Pool = require('pg-pool');
const send_report = require("./send_report");

require('dotenv').config();

async function load_db(current_data, gtfs, start_date, end_date) {
  let pool = new Pool({
      host: process.env.host,
      user: process.env.user,
      password: process.env.password,
      database: process.env.database,
      max: 10,
      idleTimeoutMillis: 10000,
      //  ssl: true,
  });
  // Load tables
  await build_queries(current_data, 'gtfs.current_data', dates11and13);
  await build_queries(gtfs.calendar, 'gtfs.calendar');
  await build_queries(gtfs.calendar_dates, 'gtfs.calendar_dates', date1T);
  await build_queries(gtfs.routes, 'gtfs.routes');
  await build_queries(gtfs.stop_times, 'gtfs.stop_times', times1and2);
  await build_queries(gtfs.stops, 'gtfs.stops');
  await build_queries(gtfs.trips, 'gtfs.trips');

  // Create scheduled_calendar table
  await run_query("select gtfs.create_scheduled_calendar()");
  let results = await run_query(`
  select trip_id,route_short_name,direction_id,stop_name,date,departure_time 
  from gtfs.output_report($1, $2)`, 
  [start_date, end_date]);
  send_report(results.rows, start_date, end_date);

  // -------------------------------------------------------------
  async function build_queries(data, table_name, repair_function) {
    await run_query("DELETE FROM " + table_name);
    let query_header = "INSERT INTO " + table_name + "(" + data[0].join(',') + ") VALUES ";
    let chunksOf100 = chunkArray(data.slice(1));
    chunksOf100.forEach(async (chunk) => {
      let row_prefix = query_header;
      let query_string = chunk.reduce((buildStr, row) => {
        if(repair_function) { 
          row = repair_function(row); 
        }
        row = row.map((item) => {
          if (item === "") {
            return 'NULL';
          } else {
            return "'" + item.replace("'","''") + "'";
          }
        });
        let curRowStr = "(" + row.join(",") + ")";
        buildStr = buildStr + row_prefix + curRowStr;
        row_prefix = ',';
        return buildStr;
      },'');
      await run_query(query_string);
    });
    console.log("Table ", table_name);
  }

  async function run_query(query_string, params) {
    try {
      let results = await pool.query(query_string, params);
      return results;
    }
    catch(err) {
      console.error(err.message, err.stack); 
    }
  }
}

function dates11and13(row) {
  let newRow = row;
  newRow[11] = fixSwiftlyDate(row[11]);
  newRow[13] = fixSwiftlyDate(row[13]);
  return newRow;  
}
function times1and2(row) {
  let newRow = row;
  newRow[1] = fixTrilliumTime(row[1]);
  newRow[2] = fixTrilliumTime(row[2]);
  return newRow;  
}
function date1T(row) {
  let newRow = row;
  newRow[1] = fixTrilliumDate(row[1]);
  return newRow;  
}
function fixSwiftlyDate(inStr) {
  // Convert Swiftly dates (MM-DD-YY) to standard YYYY-MM-DD
  return inStr.replace( /(\d+)\-(\d+)\-(\d+)/, '20$3-$1-$2')
}
function fixTrilliumDate(inStr) {
  // Convert Trillium dates (YYYYMMDD) to standard YYYY-MM-DD
  return inStr.replace( /(\d{4})(\d{2})(\d{2})/, '$1-$2-$3')
}
function fixTrilliumTime(inStr) {
  // Convert Trillium times that start with 24 to start with 00
  return inStr.slice(0,2)==="24" ? "00" + inStr.slice(2) : inStr;
}

function chunkArray(data){
  //split data so we dont insert more that 1000 rows at a time
  var results = [];
  while (data.length) {
      results.push(data.splice(0, 1000));
  }
  return results;
}


module.exports = load_db;


