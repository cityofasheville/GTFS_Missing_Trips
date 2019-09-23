const get_gtfs = require('./get_gtfs');
const get_swiftly = require('./get_swiftly');
const load_db = require('./load_db');

async function run(){
  let table_list = ['calendar','calendar_dates','routes','stop_times','stops','trips'];
  let myArgs = process.argv.slice(2);
  let start_date = myArgs[0] ? myArgs[0] : '09-16-2019';
  let end_date =   myArgs[1] ? myArgs[1] : '09-16-2019';
  let current_data = [[0]]; // await get_swiftly(start_date, end_date);

  let gtfs = await get_gtfs(table_list);
  load_db(current_data, gtfs);
}
run();
