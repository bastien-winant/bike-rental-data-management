MODEL (
	name core.weather_stations,
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

SELECT DISTINCT
	station_id AS id,
	station_name AS name
FROM staging.weather
WHERE date BETWEEN @start_ds AND @end_ds;