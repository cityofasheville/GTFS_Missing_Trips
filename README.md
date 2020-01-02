# GTFS
## Find missing trips
*Node.js program to create a report of missing bus trips.*
Reads in files from scheduled bus routes and actual trips driven.

## Setup
1. Create a Postgres database with a schema named gtfs.
1. Run `Create_tables.sql`, `create_scheduled_calendar.sql`, and `missing_trips_report_view.sql` to set up the database.
1. Copy .env.example to a new file .env and fill in the database and website credentials.
1. Install node.js and run `npm install` in the program directory.

## Running
This runs for yesterday:
    node .
This runs for given date range:
    node . 2019-12-27 2019-12-27

## DB Load
This is deployed on coa-gis-fme2. It loads the data nightly, which
allows a simple db view (and later a report) for the final report.

## Final output (TODO: use GDS for report)
select * from r_transit.missing_trips_report_view where date between '2019-10-16' and '2019-10-31'
* trip_id
* route_short_name
* direction_id
* stop_name
* date
* departure_time.

# Data Sources
## GTFS Schedules (Trillium)
Asheville scheduled data is on [Open Data Portal](http://data-avl.opendata.arcgis.com/). (Search for GTFS) 
[Direct link](http://data.trilliumtransit.com/gtfs/asheville-nc-us/asheville-nc-us.zip)

Tables needed:
* calendar
* calendar_dates
* routes
* stop_times
* stops
* trips

## Live data (Swiftly)
Live data comes from goswift.ly. An API Key is necessary.
