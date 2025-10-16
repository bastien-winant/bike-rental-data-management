MODEL (
	name staging.weather,
	kind INCREMENTAL_BY_TIME_RANGE (
		time_column date
	),
	cron "@monthly",
	start "2016-01-01",
	audits (
		not_null(columns := (station_id, date)),
		unique_combination_of_columns(columns := (station_id, date))
	),
  grain (station_id, date)
);

SELECT
	station_id,
	station_name,
	date,
	awnd AS avg_wind_speed,
	pgtm AS peak_gust_time,
	prcp AS precipitation_mm,
	snow AS snowfall_mm,
	snwd AS snow_depth_mm,
	tavg AS avg_temp_f,
	tmax AS max_temp_f,
	tmin AS min_temp_f,
	tsun AS sunshine_min,
	wdf2 AS max_wind_dir_2m,
	wdf5 AS max_wind_dir_5s,
	wsf2 AS max_wind_speed_2m,
	wsf5 AS max_wind_speed_5s
FROM raw.weather_metrics
WHERE date BETWEEN @start_ds AND @end_ds;