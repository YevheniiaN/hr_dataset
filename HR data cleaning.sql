CREATE DATABASE hr_dataset;

USE hr_dataset;

SELECT * FROM hr;

SELECT termdate FROM hr;

UPDATE hr
SET termdate = CAST(CONVERT(datetime,REPLACE(termdate, ' UTC', ''),120) AS date)
WHERE termdate IS NOT NULL AND termdate !='';

UPDATE hr
SET termdate = CAST(CONVERT(datetime, termdate, 126) AS date)
WHERE termdate IS NOT NULL AND termdate !='';

SELECT termdate FROM hr;

SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'hr';

ALTER TABLE hr
ALTER COLUMN termdate DATE;

SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'hr';

SELECT * FROM hr;

ALTER TABLE hr
ADD age INT;

UPDATE hr
SET age = DATEDIFF(YEAR, birthdate, GETDATE());

SELECT * FROM hr;

SELECT age FROM hr
WHERE age LIKE '-%';

SELECT 
	MIN(age) AS min_age,
	MAX(age) AS max_age
FROM hr;

SELECT termdate 
FROM hr
WHERE termdate IS NOT NULL AND termdate > GETDATE();

SELECT 
	termdate, 
	hire_date 
FROM hr
WHERE hire_date>=termdate;

