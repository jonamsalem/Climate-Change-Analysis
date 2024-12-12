USE hive.ja3404_nyu_edu;

SELECT 
  country, 
  ROUND(AVG(averagetemperature), 3) AS Avg_Temp_1993_2013
FROM citytemp
WHERE (
  (REGEXP_LIKE(dt, '^\d{4}-\d{2}-\d{2}$') AND CAST(SUBSTR(dt, 1, 4) AS INT) BETWEEN 1993 AND 2013) OR
  (REGEXP_LIKE(dt, '^\d{1,2}/\d{1,2}/\d{4}$') AND LENGTH(SPLIT_PART(dt, '/', 3)) = 4 AND CAST(SPLIT_PART(dt, '/', 3) AS INT) BETWEEN 1993 AND 2013)
)
GROUP BY country
ORDER BY country;