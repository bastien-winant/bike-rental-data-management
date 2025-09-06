DROP TABLE IF EXISTS raw.weather;
DROP TABLE IF EXISTS raw.rides;
DROP TABLE IF EXISTS staging.rides;
DROP TABLE IF EXISTS staging.bike_stations;
DROP TABLE IF EXISTS staging.weather_metrics;
DROP TABLE IF EXISTS staging.weather_stations;
DROP TABLE IF EXISTS analytics.rides;
DROP TABLE IF EXISTS analytics.bike_stations;
DROP TABLE IF EXISTS analytics.weather_metrics;
DROP TABLE IF EXISTS analytics.weather_stations;

-- LANDING
CREATE TABLE IF NOT EXISTS raw.weather (
	station CHAR(11) PRIMARY KEY,
	name TEXT,
	date DATE,
	avg_wind_speed REAL,
	peak_gust_time TIME,
	precipitation REAL,
	snow_fall REAL,
	snow_depth REAL,
	avg_temperature INTEGER,
	max_temperature INTEGER,
	min_temperature INTEGER,
	sunshine INTEGER,
	fastest_wind_direction_2 INTEGER,
	fastest_wind_direction_5 INTEGER,
	fastest_wind_speed_2 INTEGER,
	fastest_wind_speed_5 INTEGER
);

CREATE TABLE IF NOT EXISTS raw.rides (
	ride_id SERIAL PRIMARY KEY,
	duration INTEGER,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	start_station_id INTEGER,
	start_station_name VARCHAR(100),
	start_station_lat DOUBLE PRECISION,
	start_station_lon DOUBLE PRECISION,
	end_station_id INTEGER,
	end_station_name VARCHAR(100),
	end_station_lat DOUBLE PRECISION,
	end_station_lon DOUBLE PRECISION,
	bike_id INTEGER NOT NULL,
	user_type VARCHAR(100),
	birth_year INTEGER,
	GENDER INTEGER,
	UNIQUE(bike_id, start_time)
);

-- STAGING
CREATE TABLE staging.weather_stations (
	id CHAR(11) PRIMARY KEY,
	name TEXT
);

CREATE TABLE staging.weather_metrics (
	station_id CHAR(11) REFERENCES staging.weather_stations(id),
	date DATE,
	avg_wind_speed REAL,
	peak_gust_time TIME,
	precipitation REAL,
	snow_fall REAL,
	snow_depth REAL,
	avg_temperature INTEGER,
	max_temperature INTEGER,
	min_temperature INTEGER,
	sunshine INTEGER,
	fastest_wind_direction_2 INTEGER,
	fastest_wind_direction_5 INTEGER,
	fastest_wind_speed_2 INTEGER,
	fastest_wind_speed_5 INTEGER
);

CREATE TABLE staging.bike_stations (
	id INTEGER PRIMARY KEY,
	name VARCHAR(100),
	lat DOUBLE PRECISION,
	lon DOUBLE PRECISION
);

CREATE TABLE staging.rides (
	id SERIAL PRIMARY KEY,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	start_station_id INTEGER REFERENCES staging.bike_stations(id),
	end_station_id INTEGER REFERENCES staging.bike_stations(id),
	bike_id INTEGER NOT NULL,
	user_type VARCHAR(100),
	birth_year INTEGER,
	GENDER INTEGER,
	UNIQUE(bike_id, start_time)
);

-- PROD/ANALYTICS
CREATE TABLE analytics.weather_stations (
	id CHAR(11) PRIMARY KEY,
	name TEXT
);

CREATE TABLE analytics.weather_metrics (
	station_id CHAR(11) REFERENCES staging.weather_stations(id),
	date DATE,
	avg_wind_speed REAL,
	peak_gust_time TIME,
	precipitation REAL,
	snow_fall REAL,
	snow_depth REAL,
	avg_temperature INTEGER,
	max_temperature INTEGER,
	min_temperature INTEGER,
	sunshine INTEGER,
	fastest_wind_direction_2 INTEGER,
	fastest_wind_direction_5 INTEGER,
	fastest_wind_speed_2 INTEGER,
	fastest_wind_speed_5 INTEGER
);

CREATE TABLE analytics.bike_stations (
	id INTEGER PRIMARY KEY,
	name VARCHAR(100),
	lat DOUBLE PRECISION,
	lon DOUBLE PRECISION
);

CREATE TABLE analytics.rides (
	id SERIAL PRIMARY KEY,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,
	start_station_id INTEGER REFERENCES staging.bike_stations(id),
	end_station_id INTEGER REFERENCES staging.bike_stations(id),
	bike_id INTEGER NOT NULL,
	user_type VARCHAR(100),
	birth_year INTEGER,
	GENDER INTEGER,
	UNIQUE(bike_id, start_time)
);