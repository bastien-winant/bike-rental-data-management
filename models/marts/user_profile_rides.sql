MODEL (
	name marts.user_profile_rides,
	kind VIEW,
	cron "@monthly",
	start "2016-01-01"
);

WITH user_profile_rides AS (
	SELECT
		user_type,
		DATE_TRUNC('DAY', start_time)::DATE AS date,
		EXTRACT(YEAR FROM start_time) - birth_year  AS age,
		gender,
		EXTRACT(MINUTE FROM stop_time - start_time) * 60 +
			EXTRACT(SECOND FROM stop_time - start_time) AS duration_seconds
	FROM core.rides)
SELECT
	date,
	user_type,
	age,
	CASE
		WHEN age IS NULL THEN 'Unknown'
		WHEN age < 15 THEN '< 15'
		WHEN age <= 25 THEN '15-25'
		WHEN age <= 40 THEN '25-40'
		ELSE '40+'
	END AS age_group,
	duration_seconds
FROM user_profile_rides;