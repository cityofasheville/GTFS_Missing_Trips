const http = require("https");
const parse = require('csv-parse');

require('dotenv').config();

// Swiftly requires datestrings as MM-DD-YYYY (sigh)
function get_swiftly(start_date, end_date){
  return new Promise(function(resolve, reject) {
    const output = [];
    const path = `/otp/art-asheville/csv-export?startDate=${start_date}&endDate=${end_date}`
    const http_options = {
      "method": "GET",
      "hostname": "api.goswift.ly",
      "port": null,
      "path": path,
      "headers": {
        "authorization": process.env.swiftly_auth,
      }
    };

    // csv-parse readable stream api
    const parser = parse({
      delimiter: ','
    })
    parser.on('readable', function(){
      let record;
      while (record = parser.read()) {
        output.push(record);
      }
    })
    parser.on('error', function(e){
      reject(`Swiftly CSV Parse Error: ${e.message}`);
    })
    parser.on('end', function(){
      resolve(output);
    })

    const req = http.request(http_options, function (res) {
      res.on("data", function (chunk) {
        parser.write(chunk.toString().replace(/\n\n/g,'')); //the replace is to get rid of extraneous newlines at end of Swiftly data
      });
      res.on("end", function () {
        parser.end();
      });
      req.on('error', (e) => {
        reject(`Swiftly Connection Error: ${e.message}`);
      });
    });

    req.end();

    
  });
}
module.exports = get_swiftly;