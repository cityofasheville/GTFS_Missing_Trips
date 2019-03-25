delete from gtfs.scheduled_calendar sch 
using gtfs.calendar_dates dts
where sch.service_id = dts.service_id
and sch.date = dts.date
and exception_type = 2 --remove


insert into gtfs.scheduled_calendar(service_id, date) 
select service_id, date
from gtfs.calendar_dates
where exception_type = 1 --add