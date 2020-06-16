CREATE OR REPLACE VIEW r_transit.verify_gtfs_load
AS SELECT count(*) AS count,
    scheduled_calendar.date
   FROM r_transit.scheduled_calendar
     JOIN r_transit.gtfs_trips trips ON scheduled_calendar.service_id::text = trips.service_id::text
     JOIN r_transit.gtfs_routes routes ON trips.route_id = routes.route_id
     JOIN r_transit.gtfs_stop_times stop_times ON trips.trip_id::text = stop_times.trip_id::text
     JOIN r_transit.gtfs_stops stops ON stop_times.stop_id::text = stops.stop_id::text
  WHERE stop_times.departure_time IS NOT NULL
  GROUP BY scheduled_calendar.date
  ORDER BY scheduled_calendar.date DESC;

  CREATE OR REPLACE VIEW r_transit.verify_realtime_load
AS SELECT count(*) AS count,
    real_time_data.scheduled_date
   FROM r_transit.real_time_data
  GROUP BY real_time_data.scheduled_date
  ORDER BY real_time_data.scheduled_date DESC;