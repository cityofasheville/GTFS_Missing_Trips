
// INSERT INTO films (code, title, did, date_prod, kind) VALUES
// ('B6717', 'Tampopo', 110, '1985-02-10', 'Comedy'),
// ('HG120', 'The Dinner Game', 140, DEFAULT, 'Comedy');

  const Pool = require('pg-pool');

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
    run_query(pool,"DELETE FROM gtfs.current_data;");
    let query_header = "INSERT INTO gtfs.current_data(" + current_data[0].join(',') + ") VALUES (";
    let query_string = query_header;
    for(let row=1; row<current_data.length; row++) {
      let currow = current_data[row];
      currow[11] = fixDate(currow[11]);
      currow[13] = fixDate(currow[13]);
      let currowStr = '"' + currow.join('","') + '"';

        query_string = query_string + currowStr + ')';
      })
      if (i % 100) {
        run_query(pool,query_string);
        query_string = query_header;
      }
    }
    console.log(query_string);
//    run_query(pool,query_string);
  }

  async function run_query(pool,query_string) {

    try {
      var result = await pool.query(query_string);
    }
    catch(err) {
      console.error(e.message, e.stack); 
    }
  }

  
  function fixDate(inStr) {
    // Convert Swiftly dates (MM-DD-YY) to standard YYYY-MM-DD
    return inStr.replace( /(\d+)\-(\d+)\-(\d+)/, '20$3-$1-$2')
  }

  function fixTime(inStr) {
    // Convert Trillium times that start with 24 to start with 00
    return inStr.slice(0,2)==="24" ? "00" + inStr.slice(2) : inStr;
  }
  module.exports = load_db;


