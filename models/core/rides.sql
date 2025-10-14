MODEL (
	name core.rides,
  kind INCREMENTAL_BY_TIME_RANGE (
		time_column start_time
  ),
  cron "@daily",
  start "2016-01-01",
	audits (
		not_null(columns := (start_time, bike_id)),
		unique_combination_of_columns(columns := (start_time, bike_id))
	),
  grain (start_time, bike_id)
);

SELECT
	bike_id,
	start_time,
	stop_time,
	start_station_id,
	stop_station_id,
	user_type,
	birth_year,
	gender
FROM staging.rides
WHERE start_time BETWEEN @start_ds AND @end_ds;