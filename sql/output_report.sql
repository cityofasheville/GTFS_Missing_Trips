-- select * from gtfs.output_report('2019-08-23','2019-08-23')

CREATE OR REPLACE FUNCTION gtfs.output_report(start_date date, end_date date)
 RETURNS table (
 	trip_id varchar,
 	route_short_name varchar(50),
 	direction_id int4,
 	stop_name varchar(80),
 	date date,
 	departure_time time
 )
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT scheduled.trip_id, scheduled.route_short_name, scheduled.direction_id, scheduled.stop_name, scheduled.date, scheduled.departure_time FROM (
		SELECT scheduled_calendar.service_id, trips.trip_id, routes.route_short_name, trips.direction_id::integer direction_id, stop_times.stop_id, stops.stop_name,
		scheduled_calendar.date, stop_times.departure_time, scheduled_calendar.date + stop_times.departure_time scheduled_datetime
		FROM gtfs.scheduled_calendar
		INNER JOIN gtfs.trips
		ON scheduled_calendar.service_id = trips.service_id
		INNER JOIN gtfs.routes
		ON trips.route_id = routes.route_id
		INNER JOIN gtfs.stop_times
		ON trips.trip_id = stop_times.trip_id
		INNER JOIN gtfs.stops
		ON stop_times.stop_id = stops.stop_id	
		where scheduled_calendar.date BETWEEN start_date AND end_date
		and stop_times.departure_time is not null
		order by routes.route_short_name, scheduled_calendar.date, stop_times.departure_time
	) AS scheduled
	LEFT JOIN (
		select current_data.trip_id, current_data.direction_id, stop_id, scheduled_date
		from gtfs.current_data order by current_data.route_short_name, scheduled_date + scheduled_time
	) AS current
	ON scheduled.trip_id = current.trip_id
	AND scheduled.direction_id = current.direction_id
	AND scheduled.stop_id = current.stop_id
	AND scheduled.date = current.scheduled_date
	WHERE current.trip_id IS NULL
	ORDER by scheduled.route_short_name, scheduled.scheduled_datetime; 
END; $function$
;
