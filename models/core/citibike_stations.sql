MODEL (
	name core.citibike_stations,
	kind INCREMENTAL_BY_UNIQUE_KEY (
		unique_key id
	),
	cron "@monthly",
	start "2016-01-01",
	audits (
		not_null(columns := (id, name)),
		unique_values(columns := id)
	),
  grain id
);

WITH start_stations AS (
	SELECT
		start_station_id AS id,
		start_station_name AS name,
		start_station_latitude AS latitude,
		start_station_longitude AS longitude
	FROM staging.rides
),
stop_stations AS (
	SELECT
		stop_station_id AS id,
		stop_station_name AS name,
		stop_station_latitude AS latitude,
		stop_station_longitude AS longitude
	FROM staging.rides
)
SELECT id, name, latitude, longitude
FROM start_stations
UNION
SELECT id, name, latitude, longitude
FROM stop_stations;