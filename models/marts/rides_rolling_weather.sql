MODEL (
	name marts.rides_rolling_weather,
	kind VIEW,
	cron "@monthly",
	start "2016-01-01",
	audits (
		unique_values(columns := date)
	),
  grain date
);

WITH previous_precipitation AS (
    SELECT
        date,
        SUM((precipitation_mm > 0)::int) OVER (
            ORDER BY date
            ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING
            ) AS precip_days_last_7,
        SUM(precipitation_mm) OVER (
            ORDER BY date
            ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING
            ) AS total_precip_last_7,
        SUM((precipitation_mm > 0)::int) OVER (
            ORDER BY date
            ROWS BETWEEN 31 PRECEDING AND 1 PRECEDING
            ) AS precip_days_last_30,
        SUM(precipitation_mm) OVER (
            ORDER BY date
            ROWS BETWEEN 31 PRECEDING AND 1 PRECEDING
            ) AS total_precip_last_30,
        SUM((snowfall_mm > 0)::int) OVER (
            ORDER BY date
            ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING
            ) AS snow_days_last_7,
        sum(snowfall_mm) OVER (
            ORDER BY date
            ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING
            ) AS total_snow_last_7,
        SUM((snowfall_mm > 0)::int) OVER (
            ORDER BY date
            ROWS BETWEEN 31 PRECEDING AND 1 PRECEDING
            ) AS snow_days_last_30,
        sum(snowfall_mm) OVER (
            ORDER BY date
            ROWS BETWEEN 31 PRECEDING AND 1 PRECEDING
            ) AS total_snow_last_30
    FROM core.weather_metrics
    ORDER BY date
),
daily_rides AS (
    SELECT
        DATE_TRUNC('DAY', start_time)::DATE AS date,
        COUNT(1) AS ride_count,
        SUM(EXTRACT(MINUTE FROM stop_time - start_time) * 60 +
            EXTRACT(SECOND FROM stop_time - start_time)
        ) AS total_duration_seconds
    FROM core.rides
    GROUP BY 1
)
SELECT *
FROM daily_rides r
JOIN previous_precipitation p
USING (date);