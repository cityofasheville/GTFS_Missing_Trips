const http = require("http");
const yauzl = require('yauzl'); // unzip
const parse = require('csv-parse');
const fs = require('fs');

require('dotenv').config();

function get_gtfs(table_list){ let x = 0;
  return new Promise(function(resolve, reject) {
    const zipfilename = "data/asheville-nc-us.zip";
    const file = fs.createWriteStream(zipfilename);
    http.get(process.env.gtfs_url, function(response) {
      const { statusCode } = response;
      if (statusCode !== 200) {
        reject(`GTFS Connection Error: ${statusCode}`);
      }
      response.pipe(file);
      response.on('end', () => {
        file.close();
        unzipFile(zipfilename,table_list)
        .then((res) => { resolve(res) } );
      });
    });
  });
}

function unzipFile(zipfilename,table_list) {
  return new Promise(function(resolve, reject) {
    let returnObj = {};

    // track when we've closed all our file handles
    var handleCount = 0;
    function incrementHandleCount() {
      handleCount++;
    }
    function decrementHandleCount() {
      handleCount--;
      if (handleCount === 0) {
        resolve(returnObj);
      }
    }

    yauzl.open(zipfilename, {lazyEntries: true}, function(err, zipfile) {
      let x = 0;
      if (err) reject(err);
      zipfile.readEntry();
      zipfile.on("entry", function(entry) {
        incrementHandleCount();
        const table_name = entry.fileName.slice(0,-4); //rm .txt
        if (table_list.includes(table_name)) {
          // csv-parse readable stream api
          const output = [];
          const parser = parse({
            delimiter: ','
          })
          parser.on('readable', function(){
            let record;
            while (record = parser.read()) { if(x % 1000 === 0) { console.log(x); } x++;
              output.push(record);
            }
          })
          parser.on('error', function(e){
            reject(`GTFS CSV Parse Error: ${e.message}`);
          })
          parser.on('end', function(){
            returnObj[table_name] = output;
            decrementHandleCount();
          })

          zipfile.openReadStream(entry, function(err, readStream) {
            if (err) throw err;
            readStream.on('data', (chunk) => { //console.log(chunk.toString());
              parser.write(chunk.toString()); 
            });
            readStream.on('end', () => { 
              parser.end();
            });
          });
        }
        zipfile.readEntry();
      });
      zipfile.on("close", () => { 
        console.log("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
      })
    });
  });
}

module.exports = get_gtfs;