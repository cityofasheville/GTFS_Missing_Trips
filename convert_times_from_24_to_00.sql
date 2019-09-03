INSERT INTO gtfs.stop_times(
	trip_id, arrival_time, departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, start_service_area_id, end_service_area_id, start_service_area_radius, end_service_area_radius, continuous_pickup, continuous_drop_off, pickup_area_id, drop_off_area_id, pickup_service_area_radius, drop_off_service_area_radius)
SELECT trip_id, arrival_time::TIME arrival_time , departure_time::TIME departure_time,
stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, start_service_area_id, end_service_area_id, start_service_area_radius, end_service_area_radius, continuous_pickup, continuous_drop_off, pickup_area_id, drop_off_area_id, pickup_service_area_radius, drop_off_service_area_radius
FROM (
	SELECT trip_id, CASE WHEN arrival_time LIKE '24%' THEN '00' || SUBSTRING(arrival_time,3) ELSE arrival_time END arrival_time , 
	CASE WHEN departure_time LIKE '24%' THEN '00' || SUBSTRING(departure_time,3) ELSE departure_time END departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, start_service_area_id, end_service_area_id, start_service_area_radius, end_service_area_radius, continuous_pickup, continuous_drop_off, pickup_area_id, drop_off_area_id, pickup_service_area_radius, drop_off_service_area_radius
	FROM gtfs.stop_timesbak
) as inr

-- or maybe create the table in same step
SELECT trip_id, arrival_time::TIME arrival_time , departure_time::TIME departure_time,
stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, start_service_area_id, end_service_area_id, start_service_area_radius, end_service_area_radius, continuous_pickup, continuous_drop_off, pickup_area_id, drop_off_area_id, pickup_service_area_radius, drop_off_service_area_radius
into gtfs.stop_times
FROM (
	SELECT trip_id, CASE WHEN arrival_time LIKE '24%' THEN '00' || SUBSTRING(arrival_time,3) ELSE arrival_time END arrival_time , 
	CASE WHEN departure_time LIKE '24%' THEN '00' || SUBSTRING(departure_time,3) ELSE departure_time END departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, start_service_area_id, end_service_area_id, start_service_area_radius, end_service_area_radius, continuous_pickup, continuous_drop_off, pickup_area_id, drop_off_area_id, pickup_service_area_radius, drop_off_service_area_radius
	FROM gtfs.stop_timesbak
) as inr