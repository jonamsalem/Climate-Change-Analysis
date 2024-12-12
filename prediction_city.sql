USE hive.as17979_nyu_edu;

SELECT 
  md.city, 
  md.country, 
  ROUND(AVG(regress(features(CAST(fy.year AS DOUBLE)), md.model)), 3) AS Avg_Temp_Next_Decade
FROM (
  SELECT 
    city, 
    country, 
    learn_regressor(
      averagetemperature, 
      features(CAST(
        CASE
          WHEN REGEXP_LIKE(dt, '^\d{4}-\d{2}-\d{2}$') THEN SUBSTR(dt, 1, 4)
          WHEN REGEXP_LIKE(dt, '^\d{1,2}/\d{1,2}/\d{4}$') THEN CAST(SPLIT_PART(dt, '/', 3) AS VARCHAR)
          ELSE NULL
        END AS DOUBLE))
    ) AS model
  FROM city
  WHERE REGEXP_LIKE(dt, '^\d{4}-\d{2}-\d{2}$') OR REGEXP_LIKE(dt, '^\d{1,2}/\d{1,2}/\d{4}$')
  GROUP BY city, country
) md
CROSS JOIN (
  SELECT year 
  FROM UNNEST(SEQUENCE(2025, 2035)) AS t(year)
) fy
GROUP BY md.city, md.country
ORDER BY md.city;



-- Run using "trino --output-format CSV -f predicted_temp_for_next_decade.sql > results_predicted_temp.csv"
