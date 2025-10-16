MODEL (
	name staging.rides,
  kind INCREMENTAL_BY_TIME_RANGE (
		time_column start_time
  ),
  cron "@monthly",
  start "2016-01-01",
	audits (
		not_null(columns := (start_time, bike_id)),
		unique_combination_of_columns(columns := (start_time, bike_id))
	),
  grain (start_time, bike_id)
);

SELECT *
FROM raw.citibike_rides
WHERE start_time BETWEEN @start_ds AND @end_ds;