-- THIS IS THE TABLES WITH ALL text column types. Times still need to be converted for the program to work.

-- Drop table

-- DROP TABLE public."Current_Data";

CREATE TABLE public."Current_Data" (
	block_id text NULL,
	trip_id text NULL,
	route_id text NULL,
	route_short_name text NULL,
	direction_id text NULL,
	stop_id text NULL,
	stop_name text NULL,
	headsign text NULL,
	vehicle_id text NULL,
	driver_id text NULL,
	sched_adherence_secs text NULL,
	scheduled_date text NULL,
	scheduled_time text NULL,
	actual_date text NULL,
	actual_time text NULL,
	is_arrival text NULL
);

-- Drop table

-- DROP TABLE public.calendar;

CREATE TABLE public.calendar (
	service_id text NULL,
	service_name text NULL,
	monday text NULL,
	tuesday text NULL,
	wednesday text NULL,
	thursday text NULL,
	friday text NULL,
	saturday text NULL,
	sunday text NULL,
	start_date text NULL,
	end_date text NULL
);

-- Drop table

-- DROP TABLE public.calendar_dates;

CREATE TABLE public.calendar_dates (
	service_id text NULL,
	"date" text NULL,
	holiday_name text NULL,
	exception_type text NULL
);

-- Drop table

-- DROP TABLE public.routes;

CREATE TABLE public.routes (
	agency_id text NULL,
	route_id text NULL,
	route_short_name text NULL,
	route_long_name text NULL,
	route_desc text NULL,
	route_type text NULL,
	route_url text NULL,
	route_color text NULL,
	route_text_color text NULL,
	route_sort_order text NULL,
	min_headway_minutes text NULL,
	eligibility_restricted text NULL
);

-- Drop table

-- DROP TABLE public.stop_times;

CREATE TABLE public.stop_times (
	trip_id text NULL,
	arrival_time text NULL,
	departure_time text NULL,
	stop_id text NULL,
	stop_sequence text NULL,
	stop_headsign text NULL,
	pickup_type text NULL,
	drop_off_type text NULL,
	shape_dist_traveled text NULL,
	timepoint text NULL,
	start_service_area_id text NULL,
	end_service_area_id text NULL,
	start_service_area_radius text NULL,
	end_service_area_radius text NULL,
	continuous_pickup text NULL,
	continuous_drop_off text NULL,
	pickup_area_id text NULL,
	drop_off_area_id text NULL,
	pickup_service_area_radius text NULL,
	drop_off_service_area_radius text NULL
);

-- Drop table

-- DROP TABLE public.stops;

CREATE TABLE public.stops (
	stop_id text NULL,
	stop_code text NULL,
	platform_code text NULL,
	stop_name text NULL,
	stop_desc text NULL,
	stop_lat text NULL,
	stop_lon text NULL,
	zone_id text NULL,
	stop_url text NULL,
	location_type text NULL,
	parent_station text NULL,
	stop_timezone text NULL,
	"position" text NULL,
	direction text NULL,
	wheelchair_boarding text NULL
);

-- Drop table

-- DROP TABLE public.trips;

CREATE TABLE public.trips (
	route_id text NULL,
	service_id text NULL,
	trip_id text NULL,
	trip_short_name text NULL,
	trip_headsign text NULL,
	direction_id text NULL,
	block_id text NULL,
	shape_id text NULL,
	bikes_allowed text NULL,
	wheelchair_accessible text NULL,
	trip_type text NULL,
	drt_max_travel_time text NULL,
	drt_avg_travel_time text NULL,
	drt_advance_book_min text NULL,
	drt_pickup_message text NULL,
	drt_drop_off_message text NULL,
	continuous_pickup_message text NULL,
	continuous_drop_off_message text NULL
);
