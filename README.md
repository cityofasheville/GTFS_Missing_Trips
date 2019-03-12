# GTFS
## Find missing trips

Reads in files from scheduled bus routes and actual trips driven and finds missing trips.

Currently, files must be loaded manually. load_csv_file.sql might work with proper permissions.

Some stop_times have bad time formats (start with 24 instead of 00). Fix with convert_times_from_24_to_00.sql

Run create_scheduled_calendar.sql to fill in scheduled_calendar.

Once data is loaded run DoingFinalOuterJoin.sql

