# GTFS
## Find missing trips

Reads in files from scheduled bus routes and actual trips driven and finds missing trips.

The functions are written in Postgres syntax.

Create_tables.sql sets up the database.
The table Current_Data holds the actual trips.
The rest of the tables hold the schedules in GTFS format.


## Load schedules (annually)
Scheduled data is on Open Data Portal. (Search for GTFS) or http://data.gtfstransit.com/gtfs/asheville-nc-us/asheville-nc-us.zip
Tables needed:
calendar
calendar_dates
routes
stop_times
stops
trips

The GTFS schedules are loaded into the tables. (The script load_csv_file.sql works if you are a superuser.)

Some stop_times have bad time formats (start with 24 instead of 00). Fix with convert_times_from_24_to_00.sql

Run create_scheduled_calendar.sql to fill in scheduled_calendar.
Then run the two update queries in add-del-holidays.sql

## Load live data (monthly)
Live data comes from goswift.ly
File has extra newlines on the end :(

TODO: Use GTFS_Parser to load live data.

  Currently, files must be loaded manually. 
  Pgadmin: 
    delete from current_data;
    Right click current_data table, select Import/Export. 
    Change to Import, find file, change header to yes.

  DBeaver works except goswift.ly's weird date format (mm-dd-yy). Fix with regex: 's/(\d+)\-(\d+)\-(\d+)/20$3-$1-$2/'

  load_csv_file.sql works if you are a superuser.


Once data is loaded run DoingFinalOuterJoin.sql (change the dates.)


## Future:
The two tasks are loading the calendar for the year, and pulling the live data for the report.
The first should be copying the static GTFS files to a folder and running a script.
The second should be running a script with a year and month parameter, outputting a csv file.



