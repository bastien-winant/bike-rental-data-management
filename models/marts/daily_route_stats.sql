MODEL (
	name marts.daily_route_stats,
	kind VIEW,
	cron "@monthly",
	start "2016-01-01",
	audits (
		unique_combination_of_columns(columns := (date, start_station, stop_station))
	),
  grain (date, start_station, stop_station)
);

WITH daily_ride_stats AS (
    SELECT
        DATE_TRUNC('DAY', start_time)::DATE AS date,
        start_station_id,
        stop_station_id,
        COUNT(1) AS ride_count,
        SUM(EXTRACT(MINUTE FROM stop_time - start_time) * 60 +
            EXTRACT(SECOND FROM stop_time - start_time)
        ) AS total_duration_seconds
    FROM core.rides
    GROUP BY 1, 2, 3
)
SELECT
    r.*,
    w.avg_temp_f,
    w.avg_wind_speed,
    w.precipitation_mm,
    w.snowfall_mm,
    w.snow_depth_mm
FROM daily_ride_stats r
JOIN core.weather_metrics w
ON r.date = w.date;