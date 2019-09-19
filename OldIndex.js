
const Pool = require('pg-pool');
const fs = require('fs');
const readline = require('readline');
const parse = require('csv-parse');
const glob = require("glob");
const path = require('path');

require('dotenv').config();

//fileBasePath
c = new Pool({
    host: process.env.host,
    user: process.env.user,
    password: process.env.password,
    database: process.env.database,
    max: 10,
    idleTimeoutMillis: 10000,
    //  ssl: true,
  });

const uploads = [
    {file:"/data/calendar.txt",table:"calendar"},     
];
const sqlFile = fs.createWriteStream("./out.sql");

process.on('unhandledRejection', function errHandler (err) {
    console.error(err);
});

db.open(connectionString, function (err) {
    if (err) {console.log(err.toString())+'\n';return;}
    //Iterate through files
    uploads.forEach((upload)=>{ 
      processFile(upload.file,upload.table);
    });
});

function processFile(file,table) {
    let firstLine = true;
    let queryStr,colNames,values;

    try{
        glob(fileBasePath + file,function(err,files){
            if(files.length===0){
                console.log('File not found '+ file+'\n');
            }else if(files.length>1){
                console.log('Multiple files found, not processed: '+ file+'\n');
            }else{
                queryStr = "DELETE " + table ;
                sendToDb(queryStr);
                let rl = readline.createInterface({
                    input: fs.createReadStream(files[0])
                });
                rl.on('line', (line) => {
                    //csv-parse: returns [[1,2,3]]
                    parse(line, function(err, parsed){ 
                        if(parsed && parsed[0]){
                            fields = parsed[0].map(field=>field.replace(/'/,"''"));
                            if(firstLine) { 
                                colNames = "["+fields.join("],[").replace(/'| /g,"")+"]" ;
                                firstLine = false;
                            }else{
                                values = "'"+fields.join("','")+"'";
                                queryStr = "INSERT INTO " + table + "(" + colNames + ")VALUES(" + values + ")";
                                sendToDb(queryStr);
                            }
                        }
                    })
                });
                rl.on('error', function(err){
                    console.log(err+'\n');
                });
                rl.on('close', () => {
                    console.log("Table "+table+" Loaded\n");
                });
            }
        });
    } catch (err) {
        console.log(err.toString()+'\n');
        return;
    }        
}

function sendToDb(queryStr){
    sqlFile.write(queryStr+'\n'); 
    db.query(queryStr, function (err, data) {
        if (err) console.log(err.toString()+'\n');
    });
}


