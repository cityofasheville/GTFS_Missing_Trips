const http = require("http");
const yauzl = require('yauzl'); // unzip
const parse = require('csv-parse');
const fs = require('fs');

require('dotenv').config();

function get_trillium(){
  return new Promise(function(resolve, reject) {
    // csv-parse readable stream api
    const output = [];
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
      reject(`Trillium CSV Parse Error: ${e.message}`);
    })
    parser.on('end', function(){
      console.log(output);
      resolve(0);
    })

    const zipfilename = "data/asheville-nc-us.zip";
    const file = fs.createWriteStream(zipfilename);
    const request = http.get("http://data.trilliumtransit.com/gtfs/asheville-nc-us/asheville-nc-us.zip", function(response) {
      const { statusCode } = response;
      if (statusCode !== 200) {
        reject(`Trillium Connection Error: ${statusCode}`);
      }
      response.pipe(file);
      response.on('end', () => {
        file.close();
        // file is downloaded, now unzip it
        yauzl.open(zipfilename, {lazyEntries: true}, function(err, zipfile) {
          if (err) throw err;
          zipfile.readEntry();
          zipfile.on("entry", function(entry) {
            if (entry.fileName === "calendar.txt") {
              zipfile.openReadStream(entry, function(err, readStream) {
                if (err) throw err;
                readStream.on('data', (chunk) => { 
                  parser.write(chunk); 
                });
                readStream.on('end', () => { 
                  parser.end(); 
                });
              });
            }
            zipfile.readEntry();
          });
        });
      });
    });
  });
}

module.exports = get_trillium;