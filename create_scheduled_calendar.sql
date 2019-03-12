CREATE OR REPLACE FUNCTION public.create_scheduled_calendar()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
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
END; $function$
;
