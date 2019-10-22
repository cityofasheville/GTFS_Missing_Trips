
CREATE OR REPLACE VIEW r_transit.missing_trips_report_view
AS SELECT scheduled.trip_id,
    scheduled.route_short_name,
    scheduled.direction_id,
    scheduled.stop_name,
    scheduled.date,
    scheduled.departure_time
   FROM ( SELECT scheduled_calendar.service_id,
            trips.trip_id,
            routes.route_short_name,
            trips.direction_id::integer AS direction_id,
            stop_times.stop_id,
            stops.stop_name,
            scheduled_calendar.date,
            stop_times.departure_time,
            scheduled_calendar.date + stop_times.departure_time AS scheduled_datetime
           FROM r_transit.scheduled_calendar
             JOIN r_transit.gtfs_trips trips ON scheduled_calendar.service_id::text = trips.service_id::text
             JOIN r_transit.gtfs_routes routes ON trips.route_id = routes.route_id
             JOIN r_transit.gtfs_stop_times stop_times ON trips.trip_id::text = stop_times.trip_id::text
             JOIN r_transit.gtfs_stops stops ON stop_times.stop_id::text = stops.stop_id::text
          WHERE stop_times.departure_time IS NOT NULL
          ORDER BY routes.route_short_name, scheduled_calendar.date, stop_times.departure_time) scheduled
     LEFT JOIN ( SELECT real_time_data.trip_id,
            real_time_data.direction_id,
            real_time_data.stop_id,
            real_time_data.scheduled_date
           FROM r_transit.real_time_data
          ORDER BY real_time_data.route_short_name, (real_time_data.scheduled_date + real_time_data.scheduled_time)) current ON scheduled.trip_id::text = current.trip_id::text AND scheduled.direction_id = current.direction_id AND scheduled.stop_id::text = current.stop_id::text AND scheduled.date = current.scheduled_date
  WHERE current.trip_id IS NULL
  ORDER BY scheduled.route_short_name, scheduled.scheduled_datetime;