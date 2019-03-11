-- select * from  public.calendar_dates;
-- select * from  public.calendar;
select * from stop_times
	INNER JOIN stops
	ON stop_times.stop_id = stops.stop_id	
	INNER JOIN stops_we_care_about
	ON stop_times.stop_id = stops_we_care_about.stop_id
where trip_id = 't_198953_b_4263_tn_0';
-- select * from routes;
-- select * from stops;
-- select * from trips where trip_id = 't_198953_b_4263_tn_0';
-- select * from  public.scheduled_calendar order by service_id, date;

SELECT scheduled.*, current.trip_id, current.scheduled_datetime FROM (
	SELECT scheduled_calendar.service_id, trips.trip_id, routes.route_short_name, direction_id::integer direction_id, stop_times.stop_id, stops.stop_name,
	scheduled_calendar.date, stop_times.departure_time, scheduled_calendar.date + stop_times.departure_time scheduled_datetime
	FROM scheduled_calendar
	INNER JOIN trips
	ON scheduled_calendar.service_id = trips.service_id
	INNER JOIN routes
	ON trips.route_id = routes.route_id
	INNER JOIN stop_times
	ON trips.trip_id = stop_times.trip_id
	INNER JOIN stops
	ON stop_times.stop_id = stops.stop_id	
	--INNER JOIN stops_we_care_about
	--ON stop_times.stop_id = stops_we_care_about.stop_id
	WHERE date BETWEEN '2019-02-28' AND '2019-02-28'
	AND trips.trip_id = 't_198953_b_4263_tn_0'
	order by route_short_name, scheduled_calendar.date, stop_times.departure_time
) AS scheduled
LEFT JOIN (
	select trip_id, route_short_name, direction_id, stop_id, stop_name, headsign, 
	scheduled_date, scheduled_time, scheduled_date + scheduled_time scheduled_datetime  
	from current_data where trip_id = 't_198953_b_4263_tn_0' order by route_short_name, scheduled_date + scheduled_time
) AS current
ON scheduled.trip_id = current.trip_id
AND scheduled.direction_id = current.direction_id
AND scheduled.stop_id = current.stop_id
AND scheduled.date = current.scheduled_date
--WHERE current.trip_id IS NULL
ORDER BY scheduled.route_short_name, scheduled.scheduled_datetime 