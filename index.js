const format = require('date-fns/format');
const subDays = require('date-fns/subDays');

const get_gtfs = require('./get_gtfs');
const get_swiftly = require('./get_swiftly');
const load_db = require('./load_db');

// datestrings are YYYY-MM-DD
(async function run(){
  let start_date, end_date;

  var myArgs = process.argv.slice(2);
  if (myArgs.length == 2) {
    start_date = myArgs[0];
    end_date = myArgs[1];
  } else {
    start_date = format(subDays(new Date(), 1), "yyyy-MM-dd");
    end_date = start_date;  
  }
  let table_list = ['calendar','calendar_dates','routes','stop_times','stops','trips'];


  console.log("Run dates: ", start_date, end_date);
  let real_time_data = await get_swiftly(start_date, end_date);

  let gtfs = await get_gtfs(table_list);
  
  load_db(real_time_data, gtfs, start_date, end_date);
})();