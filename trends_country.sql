USE hive.ja3404_nyu_edu;

SELECT 
  year, 
  ROUND(AVG(averagetemperature), 3) AS Global_Avg_Temperature
FROM (
  SELECT 
    CAST(
      CASE
        WHEN REGEXP_LIKE(dt, '^\d{4}-\d{2}-\d{2}$') THEN SUBSTR(dt, 1, 4)
        WHEN REGEXP_LIKE(dt, '^\d{1,2}/\d{1,2}/\d{4}$') THEN SPLIT_PART(dt, '/', 3)
        ELSE NULL
      END AS INTEGER
    ) AS year, 
    country, 
    averagetemperature
  FROM countryTemp
  WHERE 
    (REGEXP_LIKE(dt, '^\d{4}-\d{2}-\d{2}$') OR REGEXP_LIKE(dt, '^\d{1,2}/\d{1,2}/\d{4}$')) 
    AND CAST(
      CASE
        WHEN REGEXP_LIKE(dt, '^\d{4}-\d{2}-\d{2}$') THEN SUBSTR(dt, 1, 4)
        WHEN REGEXP_LIKE(dt, '^\d{1,2}/\d{1,2}/\d{4}$') THEN SPLIT_PART(dt, '/', 3)
        ELSE NULL
      END AS INTEGER
    ) BETWEEN 1743 AND 2013
) yearly_avg
GROUP BY year
ORDER BY year;
