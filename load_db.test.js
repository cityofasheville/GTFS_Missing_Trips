const load_db = require('./load_db');
const fs = require('fs');

async function run(){
  let current_data = [1,2,3], gtfs = [1,2,3];
  load_db(current_data, gtfs);
}
run();

