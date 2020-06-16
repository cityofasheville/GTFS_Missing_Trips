
-- Drop table

-- DROP TABLE r_transit.gtfs_calendar;

CREATE TABLE r_transit.gtfs_calendar (
	service_id varchar NULL,
	service_name varchar NULL,
	monday bool NULL,
	tuesday bool NULL,
	wednesday bool NULL,
	thursday bool NULL,
	friday bool NULL,
	saturday bool NULL,
	sunday bool NULL,
	start_date date NULL,
	end_date date NULL
);


-- Drop table

-- DROP TABLE r_transit.gtfs_calendar_dates;

CREATE TABLE r_transit.gtfs_calendar_dates (
	service_id varchar NULL,
	"date" date NULL,
	holiday_name varchar NULL,
	exception_type int4 NULL
);

-- Drop table

-- DROP TABLE r_transit.gtfs_current_data;

CREATE TABLE r_transit.gtfs_current_data (
	block_id varchar NULL,
	trip_id varchar NULL,
	route_id int4 NULL,
	route_short_name varchar NULL,
	direction_id int4 NULL,
	stop_id varchar NULL,
	stop_name varchar NULL,
	headsign varchar NULL,
	vehicle_id varchar NULL,
	driver_id varchar NULL,
	sched_adherence_secs varchar NULL,
	scheduled_date date NULL,
	scheduled_time time NULL,
	actual_date date NULL,
	actual_time time NULL,
	is_arrival varchar NULL
);

-- Drop table

-- DROP TABLE r_transit.gtfs_routes;

CREATE TABLE r_transit.gtfs_routes (
	agency_id varchar(20) NULL,
	route_id int4 NULL,
	route_short_name varchar(50) NULL,
	route_long_name varchar(255) NULL,
	route_desc varchar(255) NULL,
	route_type int4 NULL,
	route_url varchar(255) NULL,
	route_color varchar(255) NULL,
	route_text_color varchar(6) NULL,
	route_sort_order int4 NULL,
	min_headway_minutes int4 NULL,
	eligibility_restricted bool NULL,

        "continuous_pickup" bool NULL,
        "continuous_drop_off" bool NULL
);

-- Drop table

-- DROP TABLE r_transit.gtfs_scheduled_calendar;

CREATE TABLE r_transit.gtfs_scheduled_calendar (
	service_id varchar NOT NULL,
	"date" date NOT NULL,
	CONSTRAINT scheduled_calendar_pkey PRIMARY KEY (service_id, date)
);

-- Drop table

-- DROP TABLE r_transit.gtfs_stop_times;

CREATE TABLE r_transit.gtfs_stop_times (
	trip_id varchar NULL,
	arrival_time time NULL,
	departure_time time NULL,
	stop_id varchar(20) NULL,
	stop_sequence int2 NULL,
	stop_headsign varchar(80) NULL,
	pickup_type int4 NULL,
	drop_off_type int4 NULL,
	shape_dist_traveled float8 NULL,
	timepoint bool NULL,
	start_service_area_id varchar NULL,
	end_service_area_id varchar NULL,
	start_service_area_radius varchar NULL,
	end_service_area_radius varchar NULL,
	continuous_pickup varchar NULL,
	continuous_drop_off varchar NULL,
	pickup_area_id varchar NULL,
	drop_off_area_id varchar NULL,
	pickup_service_area_radius varchar NULL,
	drop_off_service_area_radius varchar NULL
);

-- Drop table

-- DROP TABLE r_transit.gtfs_stops;

CREATE TABLE r_transit.gtfs_stops (
	stop_id varchar(20) NULL,
	stop_code varchar(20) NULL,
	platform_code varchar(20) NULL,
	stop_name varchar(80) NULL,
	stop_desc varchar NULL,
	stop_lat varchar(20) NULL,
	stop_lon varchar(20) NULL,
	zone_id varchar NULL,
	stop_url varchar NULL,
	location_type bool NULL,
	parent_station bool NULL,
	stop_timezone varchar(50) NULL,
	"position" varchar NULL,
	direction varchar NULL,
	wheelchair_boarding int4 NULL
);

-- Drop table

-- DROP TABLE r_transit.gtfs_trips;

CREATE TABLE r_transit.gtfs_trips (
	route_id int4 NULL,
	service_id varchar NULL,
	trip_id varchar NULL,
	trip_short_name varchar(60) NULL,
	trip_headsign varchar(40) NULL,
	direction_id bool NULL,
	block_id varchar(20) NULL,
	shape_id varchar NULL,
	bikes_allowed int4 NULL,
	wheelchair_accessible int4 NULL,
	trip_type varchar NULL,
	drt_max_travel_time varchar NULL,
	drt_avg_travel_time varchar NULL,
	drt_advance_book_min varchar NULL,
	drt_pickup_message varchar NULL,
	drt_drop_off_message varchar NULL,
	continuous_pickup_message varchar NULL,
	continuous_drop_off_message varchar NULL
);

-- DROP TABLE r_transit.real_time_data;

CREATE TABLE r_transit.real_time_data (
	block_id varchar NULL,
	trip_id varchar NULL,
	route_id int4 NULL,
	route_short_name varchar NULL,
	direction_id int4 NULL,
	stop_id varchar NULL,
	stop_name varchar NULL,
	headsign varchar NULL,
	vehicle_id varchar NULL,
	driver_id varchar NULL,
	gtfs_stop_seq varchar NULL,
	start_time varchar NULL,
	sched_adherence_secs varchar NULL,
	scheduled_date date NULL,
	scheduled_time time NULL,
	actual_date date NULL,
	actual_time time NULL,
	is_arrival varchar NULL
);
