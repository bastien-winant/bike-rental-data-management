MODEL (
	name marts.route_duration_metrics,
	kind INCREMENTAL_BY_TIME_RANGE (
		time_column date
	),
	cron "@daily",
	start "2016-01-01",
	audits (
		unique_combination_of_columns(columns := (date, start_station, stop_station))
	),
  grain (date, start_station, stop_station)
);

WITH route_ride_durations AS (
	SELECT
		DATE_TRUNC('DAY', start_time)::DATE         AS date,
		start_station_id,
		stop_station_id,
		EXTRACT(MINUTE FROM stop_time - start_time) * 60 +
			EXTRACT(SECOND FROM stop_time - start_time) AS duration_seconds
	FROM core.rides),
route_ride_stats AS (
	SELECT
		date,
		start_station_id,
		stop_station_id,
		COUNT(*) AS ride_count,
		ROUND(AVG(duration_seconds), 2) AS avg_ride_seconds,
		ROUND(STDDEV_POP(duration_seconds), 2) AS std_ride_seconds
	FROM route_ride_durations
	GROUP BY date, start_station_id, stop_station_id
)
SELECT
	r.date,
	start.name AS start_station,
	stop.name AS stop_station,
	r.ride_count,
	r.avg_ride_seconds,
	r.std_ride_seconds,
	w.avg_temp_f,
	w.avg_wind_speed,
	w.precipitation_mm,
	w.snowfall_mm,
	w.snow_depth_mm
FROM route_ride_stats r
JOIN core.weather_metrics w
USING (date)
JOIN core.citibike_stations start
ON r.start_station_id = start.id
JOIN core.citibike_stations stop
ON r.stop_station_id = stop.id;