MODEL (
	name marts.daily_user_stats,
	kind VIEW,
	cron "@monthly",
	start "2016-01-01",
	audits (
		unique_combination_of_columns(columns := (date, age_group, gender, user_type))
	),
  grain (date, age_group, gender, user_type)
);

WITH with_age AS (
    SELECT
        DATE_TRUNC('DAY', start_time)::DATE AS date,
        DATE_PART('YEAR', start_time) - birth_year AS age,
        *
    FROM core.rides
),
daily_aggregates AS (
    SELECT
        date,
        CASE
            WHEN age < 20 THEN '< 20'
            WHEN age < 26 THEN '20 - 25'
            WHEN age < 36 THEN '26 - 35'
            WHEN age < 46 THEN '36 - 45'
            ELSE '> 45'
        END AS age_group,
        gender,
        user_type,
        COUNT(1) AS ride_count,
        SUM(EXTRACT(MINUTE FROM stop_time - start_time) * 60 +
            EXTRACT(SECOND FROM stop_time - start_time)
        ) AS total_duration_seconds
    FROM with_age
    GROUP BY 1, 2, 3, 4
)
SELECT
    d.*,
    w.avg_temp_f,
    w.avg_wind_speed,
    w.precipitation_mm,
    w.snowfall_mm,
    w.snow_depth_mm
FROM daily_aggregates d
JOIN core.weather_metrics w
ON d.date = w.date;