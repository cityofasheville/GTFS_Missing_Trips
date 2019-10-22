const get_gtfs = require('./get_gtfs');
const fs = require('fs');

(async function run(){
  let table_list = ['calendar','calendar_dates','routes','stop_times','stops','trips'];
  // let table_list = ['stop_times','calendar_dates']

  let gtfs = await get_gtfs(table_list);
  console.log("#############################################",gtfs);
  fs.writeFile('out.json', JSON.stringify(gtfs,null,'\t'), (err) => {
    if (err) throw err;
    console.log('file saved');
  });
})();

