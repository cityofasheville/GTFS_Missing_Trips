const fs = require('fs');

function send_report(data, start_date, end_date) {
  console.log(start_date, end_date);
  let filename = start_date + '%' + end_date + '.csv';
  fs.writeFile(filename, cvsify(data), (err) => {    
    if (err) throw err;
    console.log('Report saved to ' + filename);
  });
}

module.exports = send_report;

function cvsify(data) {
  return JSON.stringify(data)
  .replace(/\},\{"trip_id":/g,'\n')
  .replace(/"route_short_name":/g,'')
  .replace(/"direction_id":/g,'')
  .replace(/"stop_name":/g,'')
  .replace(/"date":/g,'')
  .replace(/"departure_time":/g,'')
  .replace(/\[{"trip_id":/g,'')
  .replace(/T\d\d:00:00.000Z/g,'')
  .replace(/}]/,'')
}