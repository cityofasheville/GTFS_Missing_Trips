const Pool = require('pg-pool');
const fs = require("fs");

require('dotenv').config();

async function load_db(current_data, gtfs) {
  let pool = new Pool({
      host: process.env.host,
      user: process.env.user,
      password: process.env.password,
      database: process.env.database,
      max: 10,
      idleTimeoutMillis: 10000,
      //  ssl: true,
  });
  build_queries(current_data, 'gtfs.current_data', dates11and13);
  build_queries(gtfs.calendar, 'gtfs.calendar');
  build_queries(gtfs.calendar_dates, 'gtfs.calendar_dates', date1T);
  build_queries(gtfs.routes, 'gtfs.routes');
  build_queries(gtfs.stop_times, 'gtfs.stop_times', times1and2);
  build_queries(gtfs.stops, 'gtfs.stops');
  build_queries(gtfs.trips, 'gtfs.trips');
  run_query("select gtfs.create_scheduled_calendar()");
  run_query(`
  delete from gtfs.scheduled_calendar sch 
  using gtfs.calendar_dates dts
  where sch.service_id = dts.service_id
  and sch.date = dts.date
  and exception_type = 2 --remove
  `);
  run_query(`
  insert into gtfs.scheduled_calendar(service_id, date) 
  select service_id, date
  from gtfs.calendar_dates
  where exception_type = 1 --add
  `);
  // -------------------------------------------------------------
  async function build_queries(data, table_name, repair_function) {
    run_query("DELETE FROM " + table_name);
    let query_header = "INSERT INTO " + table_name + "(" + data[0].join(',') + ") VALUES ";
    let chunksOf100 = chunkArray(data.slice(1));
    chunksOf100.forEach((chunk) => {
      let row_prefix = query_header;
      let query_string = chunk.reduce((buildStr, row) => {
        row = row.map((item) => {
          if(repair_function) { 
            row = repair_function(row); 
          }
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
      run_query(query_string);
    });
  }

  async function run_query(query_string) {
    try {
      var result = await pool.query(query_string);
    }
    catch(err) {
      console.error(err.message, err.stack); 
    }
  }

  function dates11and13(row) {
    row[11] = fixSwiftlyDate(row[11]);
    row[13] = fixSwiftlyDate(row[13]);
    return row;  
  }
  function times1and2(row) {
    newRow = row;
    newRow[1] = fixTrilliumTime(row[1]);
    newRow[2] = fixTrilliumTime(row[2]);
    return newRow;  
  }
  function date1T(row) {
    row[1] = fixTrilliumDate(row[1]);
    return row;  
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

  // function fixTrilliumTime(inStr) {
  //   // Convert Trillium times that start with 24 to start with 00
  //   if( inStr.slice(0,2)==="24" ) {
  //     console.log("00" + inStr.slice(2));
  //     return "00" + inStr.slice(2);
  //   } else {
  //     return inStr;
  //   }
  // }
  function chunkArray(data){
    //split data so we dont insert more that 100 rows at a time
    var results = [];
    while (data.length) {
        results.push(data.splice(0, 100));
    }
    return results;
  }
}

module.exports = load_db;


