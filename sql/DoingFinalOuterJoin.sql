
-- select * from  public.calendar_dates;
-- select * from  public.current_data where trip_id = 't_179915_b_4263_tn_12' and stop_id = '759609';
/*
select * from stop_times
	INNER JOIN stops
	ON stop_times.stop_id = stops.stop_id	

where stop_sequence = 1 
and trip_id = 't_179882_b_4263_tn_0';
*/
-- select * from routes;
-- select * from stops;
-- select * from trips where trip_id = 't_198953_b_4263_tn_0';
-- select * from  public.scheduled_calendar order by service_id, date;

SELECT scheduled.trip_id, scheduled.route_short_name, scheduled.direction_id, scheduled.stop_name, scheduled.date, scheduled.departure_time FROM (
	SELECT scheduled_calendar.service_id, trips.trip_id, routes.route_short_name, direction_id::integer direction_id, stop_times.stop_id, stops.stop_name,
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
	where date BETWEEN '2019-08-23' AND '2019-08-31'
	and stop_times.departure_time is not null
	-- and stop_sequence = 1
	-- AND trips.trip_id = 't_179882_b_4263_tn_0' --and stop_times.stop_id = '759609'
	order by route_short_name, scheduled_calendar.date, stop_times.departure_time
) AS scheduled
LEFT JOIN (
	select trip_id, direction_id, stop_id, scheduled_date
	from gtfs.current_data order by route_short_name, scheduled_date + scheduled_time
) AS current
ON scheduled.trip_id = current.trip_id
AND scheduled.direction_id = current.direction_id
AND scheduled.stop_id = current.stop_id
AND scheduled.date = current.scheduled_date
WHERE current.trip_id IS NULL
ORDER by scheduled.route_short_name, scheduled.scheduled_datetime 
/*
select * from public.stops_we_care_about;

select trip_id, route_short_name, direction_id, stop_id, stop_name, headsign, scheduled_date + scheduled_time scheduled_datetime  
from current_data order by route_short_name, scheduled_date, scheduled_time;
*/
-- distinct trip_id, route_short_name, direction_id, stop_id, stop_name, headsign, scheduled_date + scheduled_time

-- select public.create_scheduled_calendar();
/*
CREATE OR REPLACE FUNCTION create_scheduled_calendar()
    RETURNS void AS $$
DECLARE 
    rec_cal   RECORD;
	num_dates INT;
    cur_cal CURSOR FOR SELECT * FROM calendar;
BEGIN
	DELETE FROM public.scheduled_calendar;
	OPEN cur_cal;
    LOOP
        FETCH cur_cal INTO rec_cal;
        EXIT WHEN NOT FOUND;
		
		SELECT DATE_PART('day', rec_cal.end_date::timestamp - rec_cal.start_date::timestamp) INTO num_dates;
        
		INSERT INTO scheduled_calendar(service_id,date)
        SELECT service_id, dates FROM (
            SELECT service_id, dates, extract(dow from dates) AS dow FROM (
                SELECT rec_cal.service_id, rec_cal.start_date + s.a AS dates FROM generate_series(0,num_dates) AS s(a) 
                --SELECT 'c_4299_b_4263_d_64' AS service_id, '2018-01-01'::date + s.a AS dates FROM generate_series(0,10) AS s(a) 
            ) AS datelist1
        ) AS datelist
        WHERE (rec_cal.monday = true AND datelist.dow = 1) 
        OR    (rec_cal.tuesday = true AND datelist.dow = 2)
        OR    (rec_cal.wednesday = true AND datelist.dow = 3)
        OR    (rec_cal.thursday = true AND datelist.dow = 4)
        OR    (rec_cal.friday = true AND datelist.dow = 5)
        OR    (rec_cal.saturday = true AND datelist.dow = 6)
        OR    (rec_cal.sunday = true AND datelist.dow = 0);
    END LOOP;
    -- Close the cursor
    CLOSE cur_cal;
END; $$
LANGUAGE plpgsql;
*/
												  
												  
												  
												  
												  
												  