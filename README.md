# GTFS
## Find missing trips
Node.js program create a report of missing bus trips.
Reads in files from scheduled bus routes and actual trips driven.

## Setup
Create a Postgres database with a schema named gtfs.
Run Create_tables.sql, create_scheduled_calendar.sql, and output_report.sql to set up the database.
Copy .env.example to a new file .env and fill in the database and website credentials.
Install node.js and run 'npm install' in the program directory.

## To Run
node .
This will create a *.csv file.

# Data Sources
## GTFS Schedules (Trillium)
Scheduled data is on Open Data Portal. (Search for GTFS) 
http://data.trilliumtransit.com/gtfs/asheville-nc-us/asheville-nc-us.zip
Tables needed:
calendar
calendar_dates
routes
stop_times
stops
trips

## Live data (Swiftly)
Live data comes from goswift.ly
