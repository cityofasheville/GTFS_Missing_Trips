-- select * from  public.calendar_dates;
-- select * from  public.calendar;

--working datediff(days)
SELECT DATE_PART('day', '2012-12-31 01:00:00'::timestamp - '2011-12-29 23:00:00'::timestamp);

--Working function returning int
create table test (id int);
insert into test values (1);
insert into test values (2);
insert into test values (3);

create function test_fn() returns int as $$
    declare val int := 2;
    begin
        return (SELECT id FROM test WHERE id = val);
    end;
$$ LANGUAGE plpgsql;

SELECT * FROM test_fn();

--woring function returning nothing
CREATE FUNCTION stamp_user() RETURNS void AS $$
    BEGIN
		INSERT INTO scheduled_mess(date)
        SELECT CURRENT_DATE;
    END;
$$ LANGUAGE plpgsql;

select stamp_user()

--working series
select CURRENT_DATE + i 
from generate_series(date '2012-06-29'- CURRENT_DATE, 
date '2012-07-03' - CURRENT_DATE ) i
--not working
select CURRENT_DATE + i 
from generate_series(date rec_cal.start_date - CURRENT_DATE, 
date rec_cal.end_date - CURRENT_DATE ) i   

-- select * from  public.calendar_dates; ssh-add ~/.ssh/github_rsa
-- select * from  public.calendar;
-- select service_id, max(date), count(*) from  public.scheduled_calendar group by service_id;


  --working to insert all dates in range

-- select public.create_scheduled_calendar();
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
		SELECT rec_cal.service_id, rec_cal.start_date + s.a AS dates FROM generate_series(0,num_dates) AS s(a); 
    END LOOP;
    -- Close the cursor
    CLOSE cur_cal;
END; $$
LANGUAGE plpgsql;


-- maybe use this to get day of week (or isodow?)
select extract(dow from date '2016-12-18');
