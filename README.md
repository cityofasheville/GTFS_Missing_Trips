# GTFS
## Find missing trips

Reads in files from scheduled bus routes and actual trips driven and finds missing trips.

The functions are written in Postgres syntax.

Create_tables.sql sets up the database.
The table Current_Data holds the actual trips.
The rest of the tables hold the schedules in GTFS format.

Currently, files must be loaded manually. Pgadmin or DBeaver work OK. load_csv_file.sql works if you are a superuser.
(The date, time and boolean fields have been created as text fields to ease imports, and need to be converted after import for the scripts to work.)
The file index.js is a work in progress to load the tables a little less manually.

## Load schedules (annually)
Scheduled data is on Open Data Portal. (Search for GTFS) or http://data.trilliumtransit.com/gtfs/asheville-nc-us/asheville-nc-us.zip

The GTFS schedules are loaded into the tables. (The script load_csv_file.sql works if you are a superuser.)

Some stop_times have bad time formats (start with 24 instead of 00). Fix with convert_times_from_24_to_00.sql

Then the function create_scheduled_calendar.sql creates the table scheduled_calendar from that.
Then run add-del-holidays.sql to switch out schedules for holidays.

## Load live data (monthly)
Live data comes from goswift.ly
TODO: Use GTFS_Parser to load live data.

Once data is loaded run DoingFinalOuterJoin.sql (change the dates.)


## Future:
The two tasks are loading the calendar for the year, and pulling the live data for the report.
The first should be copying the static GTFS files to a folder and running a script.
The second should be running a script with a year and month parameter, outputting a csv file.



