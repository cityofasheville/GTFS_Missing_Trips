const get_swiftly = require('./get_swiftly');

async function run(){
  let start_date = '09-16-2019';
  let end_date = '09-16-2019';
  let current_data = await get_swiftly(start_date, end_date);
  console.log( fixDate(current_data[1][11]) );
  console.log( fixDate(current_data[1][13]) );
}
run();

function fixDate(inStr) {
  return inStr.replace( /(\d+)\-(\d+)\-(\d+)/, '20$3-$1-$2')
}