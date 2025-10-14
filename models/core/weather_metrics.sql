MODEL (
	name core.weather_metrics,
	kind INCREMENTAL_BY_TIME_RANGE (
		time_column date
	),
	cron "@daily",
	start "2016-01-01",
	audits (
		not_null(columns := (station_id, date)),
		unique_combination_of_columns(columns := (station_id, date))
	),
  grain (station_id, date)
);

SELECT
	station_id,
	date,
	avg_wind_speed,
	peak_gust_time,
	precipitation_mm,
	snowfall_mm,
	snow_depth_mm,
	avg_temp_f,
	max_temp_f,
	min_temp_f,
	sunshine_min,
	max_wind_dir_2m,
	max_wind_dir_5s,
	max_wind_speed_2m,
	max_wind_speed_5s
FROM staging.weather
WHERE date BETWEEN @start_ds AND @end_ds;