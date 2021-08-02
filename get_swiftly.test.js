const get_swiftly = require('./get_swiftly');

(async function run(){
  let start_date = '2021-07-01';
  let end_date = '2021-08-01'; //full month throws error
  let current_data = await get_swiftly(start_date, end_date);
  console.log( fixDate(current_data[1][11]) );
  console.log( fixDate(current_data[1][13]) );
  console.log( current_data );
})();

function fixDate(inStr) {
  return inStr.replace( /(\d+)\-(\d+)\-(\d+)/, '20$3-$1-$2')
}