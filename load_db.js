const Pool = require('pg-pool');

require('dotenv').config();

async function load_db(current_data, gtfs) {
  let data = current_data;
  console.log("loading ", data.length, " rows");
  let pool = new Pool({
      host: process.env.host,
      user: process.env.user,
      password: process.env.password,
      database: process.env.database,
      max: 10,
      idleTimeoutMillis: 10000,
      //  ssl: true,
  });
  run_query(pool,"DELETE FROM gtfs.current_data;");
  let query_header = "INSERT INTO gtfs.current_data(" + data[0].join(',') + ") VALUES ";
  let chunksOf100 = chunkArray(data.slice(1));
  chunksOf100.forEach((chunk) => {
    let row_prefix = query_header;
    let query_string = chunk.reduce((buildStr, row) => {
      row[11] = fixDate(row[11]);
      row[13] = fixDate(row[13]);  
      let curRowStr = "('" + row.join("','") + "')";
      buildStr = buildStr + row_prefix + curRowStr;
      row_prefix = ',';
      return buildStr;
    },'');
    console.log(query_string);
    run_query(pool,query_string);
  });
}

// build_queries(current_data, 'gtfs.current_data', dates11and13);

async function build_queries(data, table_name, repair_function) {
  run_query(pool,"DELETE FROM " + table_name);
  let query_header = "INSERT INTO " + table_name + "(" + data[0].join(',') + ") VALUES ";
  let chunksOf100 = chunkArray(data.slice(1));
  chunksOf100.forEach((chunk) => {
    let row_prefix = query_header;
    let query_string = chunk.reduce((buildStr, row) => {
      let row = repair_function(row);
      let curRowStr = "('" + row.join("','") + "')";
      buildStr = buildStr + row_prefix + curRowStr;
      row_prefix = ',';
      return buildStr;
    },'');
    console.log(query_string);
    run_query(pool,query_string);
  });
}

async function run_query(pool,query_string) {
  try {
    var result = await pool.query(query_string);
  }
  catch(err) {
    console.error(err.message, err.stack); 
  }
}

function dates11and13(row) {
  row[11] = fixDate(row[11]);
  row[13] = fixDate(row[13]);
  return row;  
}

function fixDate(inStr) {
  // Convert Swiftly dates (MM-DD-YY) to standard YYYY-MM-DD
  return inStr.replace( /(\d+)\-(\d+)\-(\d+)/, '20$3-$1-$2')
}

function fixTime(inStr) {
  // Convert Trillium times that start with 24 to start with 00
  return inStr.slice(0,2)==="24" ? "00" + inStr.slice(2) : inStr;
}

function chunkArray(data){
  //split data so we dont insert more that 100 rows at a time
  var results = [];
  while (data.length) {
      results.push(data.splice(0, 100));
  }
  return results;
}

module.exports = load_db;


