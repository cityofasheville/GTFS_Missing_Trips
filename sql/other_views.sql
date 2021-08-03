CREATE OR REPLACE VIEW gtfs.verify_gtfs_load
AS SELECT count(*) AS count,
    scheduled_calendar.date
   FROM gtfs.scheduled_calendar
     JOIN gtfs.gtfs_trips trips ON scheduled_calendar.service_id::text = trips.service_id::text
     JOIN gtfs.gtfs_routes routes ON trips.route_id = routes.route_id
     JOIN gtfs.gtfs_stop_times stop_times ON trips.trip_id::text = stop_times.trip_id::text
     JOIN gtfs.gtfs_stops stops ON stop_times.stop_id::text = stops.stop_id::text
  WHERE stop_times.departure_time IS NOT NULL
  GROUP BY scheduled_calendar.date
  ORDER BY scheduled_calendar.date DESC;

  CREATE OR REPLACE VIEW gtfs.verify_realtime_load
AS SELECT count(*) AS count,
    real_time_data.scheduled_date
   FROM gtfs.real_time_data
  GROUP BY real_time_data.scheduled_date
  ORDER BY real_time_data.scheduled_date DESC;