CREATE OR REPLACE FUNCTION r_transit.gtfs_create_scheduled_calendar()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE 
    rec_cal   RECORD;
	num_dates INT;
    cur_cal CURSOR FOR SELECT * FROM r_transit.gtfs_calendar;
BEGIN
	DELETE FROM r_transit.scheduled_calendar;
	OPEN cur_cal;
    LOOP
        FETCH cur_cal INTO rec_cal;
        EXIT WHEN NOT FOUND;
		
		SELECT DATE_PART('day', rec_cal.end_date::timestamp - rec_cal.start_date::timestamp) INTO num_dates;
        
		INSERT INTO r_transit.scheduled_calendar(service_id,date)
        SELECT service_id, dates FROM (
            SELECT service_id, dates, extract(dow from dates) AS dow FROM (
                SELECT rec_cal.service_id, rec_cal.start_date + s.a AS dates FROM generate_series(0,num_dates) AS s(a) 
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

    -- remove holidays
    delete from r_transit.scheduled_calendar sch 
    using r_transit.gtfs_calendar_dates dts
    where sch.service_id = dts.service_id
    and sch.date = dts.date
    and exception_type = 2;

    -- add holidays
    insert into r_transit.scheduled_calendar(service_id, date) 
    select dt.service_id, dt.date
    from r_transit.gtfs_calendar_dates dt
    left join r_transit.scheduled_calendar sc
    on dt.service_id = sc.service_id 
    and dt."date" = sc."date" 
    where exception_type = 1
    and sc.service_id is null
    ;
END; $function$
;
