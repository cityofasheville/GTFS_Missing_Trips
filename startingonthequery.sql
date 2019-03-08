select trips.*, stop_times.trip_id,stop_times.arrival_time,stop_times.departure_time,stop_times.stop_id 
from stop_times
inner join trips
on stop_times.trip_id = trips.trip_id

select trip_id, route_short_name, direction_id, scheduled_date from current_data;