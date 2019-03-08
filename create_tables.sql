CREATE TABLE CurrentData (
block_id VARCHAR,
trip_id VARCHAR,
route_id INT,
route_short_name VARCHAR,
direction_id INT,
stop_id VARCHAR,
stop_name VARCHAR,
headsign VARCHAR,
vehicle_id VARCHAR,
driver_id VARCHAR,
sched_adherence_secs VARCHAR,
scheduled_date VARCHAR,
scheduled_time VARCHAR,
actual_date VARCHAR,
actual_time VARCHAR,
is_arrival VARCHAR
)

CREATE TABLE agency (
    agency_id               VARCHAR(20)     NOT NULL,
    agency_name             VARCHAR(255)    NOT NULL,
    agency_url              VARCHAR(255)    NOT NULL,
    agency_timezone         VARCHAR(50)     NOT NULL,
    agency_phone            VARCHAR(40),

    PRIMARY KEY (agency_id)
);


CREATE TABLE routes (
    route_id                INT     NOT NULL,
    agency_id               VARCHAR(20)     NOT NULL,
    route_short_name        VARCHAR(50)     NOT NULL,
    route_long_name         VARCHAR(255)    NOT NULL,
    route_desc              VARCHAR(255),
    route_type              INT         NOT NULL,
    route_color             VARCHAR(255),
    route_text_color        VARCHAR(6),
    route_url               VARCHAR(255),

    PRIMARY KEY (route_id)
);


CREATE INDEX route__route_id
    ON routes(route_id)
    ;

CREATE INDEX route__agency_id
    ON routes(agency_id)
    ;


CREATE TABLE shapes (
    shape_id                INT     NOT NULL,
    shape_pt_sequence       SMALLINT        NOT NULL,
    shape_pt_lat            VARCHAR(20)     NOT NULL,
    shape_pt_lon            VARCHAR(20)     NOT NULL,
    shape_dist_traveled     SMALLINT        NOT NULL,

    PRIMARY KEY (shape_id, shape_pt_sequence)
);


DROP TABLE public.calendar_dates;
CREATE TABLE public.calendar_dates
(
    service_id varchar NOT NULL,
    date date NOT NULL,
	holiday_name varchar,
    exception_type integer,
    CONSTRAINT calendar_dates_pkey PRIMARY KEY (service_id, date)
)

CREATE TABLE public.scheduled_calendar
(
    service_id varchar NOT NULL,
    date date NOT NULL,
    CONSTRAINT calendar_dates_pkey PRIMARY KEY (service_id, date)
)


CREATE TABLE calendar (
service_id VARCHAR     NOT NULL,
service_name VARCHAR,
monday BOOLEAN,
tuesday BOOLEAN,
wednesday BOOLEAN,
thursday BOOLEAN,
friday BOOLEAN,
saturday BOOLEAN,
sunday BOOLEAN,
start_date DATE,
end_date DATE
);

CREATE TABLE trips (
    route_id                INT     NOT NULL,
    service_id              VARCHAR     NOT NULL,
    trip_id                 VARCHAR     NOT NULL,
    trip_short_name         VARCHAR(60),
    trip_headsign           VARCHAR(40),
    direction_id            BOOLEAN,
    block_id                VARCHAR(20),
    shape_id                INT,
    bikes_allowed           INT,
    wheelchair_accessible   INT,
    bikes_allowed           INT,
    trip_long_name          VARCHAR(100),
    trip_type VARCHAR,
    drt_max_travel_time VARCHAR,
    drt_avg_travel_time VARCHAR,
    drt_advance_book_min VARCHAR,
    drt_pickup_message VARCHAR,
    drt_drop_off_message VARCHAR,
    continuous_pickup_message VARCHAR,
    continuous_drop_off_message VARCHAR
    PRIMARY KEY (realtime_trip_id, service_id, direction_id, block_id, shape_id)
);


CREATE INDEX trips__route_id
    ON trips(route_id)
    ;

CREATE INDEX trips__service_id
    ON trips(service_id)
    ;

CREATE INDEX trips__trip_id
    ON trips(trip_id)
    ;


CREATE TABLE stops (
    stop_id                 VARCHAR(20)     NOT NULL,
    stop_code               VARCHAR(20),
    stop_name               VARCHAR(80)     NOT NULL,
    stop_lat                VARCHAR(20)     NOT NULL,
    stop_lon                VARCHAR(20)     NOT NULL,
    location_type           BOOLEAN,
    parent_station          BOOLEAN,
    stop_timezone           VARCHAR(50),
    wheelchair_boarding     INT,
    platform_code           VARCHAR(20),

    PRIMARY KEY (stop_id)
);


CREATE TABLE stop_times (
    trip_id                 VARCHAR    NOT NULL,
    arrival_time            VARCHAR(10)      NULL,
    departure_time          VARCHAR(10)      NULL,
    stop_id                 VARCHAR(20),
    stop_sequence           SMALLINT        NOT NULL,
    stop_headsign           VARCHAR(80),
    pickup_type             INT,
    drop_off_type           INT,
    shape_dist_traveled     FLOAT,
    timepoint               BOOLEAN,
    start_service_area_id VARCHAR,
    end_service_area_id VARCHAR,
    start_service_area_radius VARCHAR,
    end_service_area_radius VARCHAR,
    continuous_pickup VARCHAR,
    continuous_drop_off VARCHAR,
    pickup_area_id VARCHAR,
    drop_off_area_id VARCHAR,
    pickup_service_area_radius VARCHAR,
    drop_off_service_area_radius VARCHAR
);


CREATE INDEX stop_times__stop_id
    ON stop_times(stop_id)
    ;


CREATE TABLE transfers (
    from_stop_id            VARCHAR(20)     NOT NULL,
    to_stop_id              VARCHAR(20)     NOT NULL,
    from_route_id           INT ,
    to_route_id             INT ,
    from_trip_id            INT ,
    to_trip_id              INT ,
    transfer_type           INT         NOT NULL,
    min_transfer_time       SMALLINT,

    PRIMARY KEY (from_stop_id, to_stop_id, from_route_id, to_route_id, from_trip_id, to_trip_id)
);


CREATE INDEX transfers__stop_ids
    ON transfers(from_stop_id, to_stop_id)
    ;

CREATE INDEX transfers__stop_ids_reversed
    ON transfers(to_stop_id, from_stop_id)
    ;

CREATE INDEX transfers__route_ids
    ON transfers(from_route_id, to_route_id)
    ;

CREATE INDEX transfers__route_ids_reversed
    ON transfers(to_route_id, from_route_id)
    ;

CREATE INDEX transfers__trip_ids
    ON transfers(from_route_id, to_route_id)
    ;

CREATE INDEX transfers__trip_ids_reversed
    ON transfers(to_trip_id, from_trip_id)
    ;