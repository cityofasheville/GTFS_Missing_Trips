const https = require("https");
const parse = require('csv-parse');

require('dotenv').config();

// Input datestrings are YYYY-MM-DD
function get_swiftly(start_date, end_date){
  start_date = swiftDate(start_date);
  end_date = swiftDate(end_date);
  return new Promise(function(resolve, reject) {
    const output = [];
    const path = `/otp/${process.env.swiftly_agency_key}/csv-export?startDate=${start_date}&endDate=${end_date}`
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

    const req = https.request(http_options, function (res) {
      res.on("data", function (chunk) {
        if(res.statusCode != '200'){
          reject("Swiftly https error: " + res.statusMessage + ' ' + chunk.toString())
        }
        parser.write(chunk.toString().replace(/\n\n/g,'')); //the replace is to get rid of extraneous newlines at end of Swiftly data
      });
      res.on("end", function () {
        console.log("Data fetched from Swiftly");
        parser.end();
      });
      req.on('error', (e) => {
        reject(`Swiftly Connection Error: ${e.message}`);
      });
    });

    req.end();

    
  });
}

function swiftDate(inStr) {
  // Convert datestrings from YYYY-MM-DD to Swiftly MM-DD-YYYY
  return inStr.replace( /(\d{4})-(\d{2})-(\d{2})/, '$2-$3-$1')
}

module.exports = get_swiftly;