const format = require('date-fns/format');
const subDays = require('date-fns/subDays');

const get_gtfs = require('./get_gtfs');
const get_swiftly = require('./get_swiftly');
const load_db = require('./load_db');

// datestrings are YYYY-MM-DD
(async function run(){
  let table_list = ['calendar','calendar_dates','routes','stop_times','stops','trips'];

  let start_date = format(subDays(new Date(), 1), "yyyy-MM-dd");
  let end_date = start_date;

  console.log("Run dates: ", start_date, end_date);
  let real_time_data = await get_swiftly(start_date, end_date);

  let gtfs = await get_gtfs(table_list);
  
  load_db(real_time_data, gtfs, start_date, end_date);
})();