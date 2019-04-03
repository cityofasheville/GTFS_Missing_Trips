# GTFS
## Find missing trips

Reads in files from scheduled bus routes and actual trips driven and finds missing trips.


Currently, files must be loaded manually. Pgadmin or DBeaver work OK. load_csv_file.sql works if you are a superuser.

## Load schedules (yearly)
Scheduled data is on Open Data Portal. (Search for GTFS) or http://data.trilliumtransit.com/gtfs/asheville-nc-us/asheville-nc-us.zip

Some stop_times have bad time formats (start with 24 instead of 00). Fix with convert_times_from_24_to_00.sql
Then convert all the date, time and boolean fields.

Run create_scheduled_calendar.sql to fill in scheduled_calendar.

## Load live data (monthly)
Live data comes from goswift.ly
TODO: Use GTFS_Parser to load live data.

Once data is loaded run DoingFinalOuterJoin.sql (change the dates.)


## Future:
The two tasks are loading the calendar for the year, and pulling the live data for the report.
The first should be copying the static GTFS files to a folder and running a script.
The second should be running a script with a year and month parameter, outputting a csv file.



