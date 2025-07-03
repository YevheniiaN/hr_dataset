-- QUESTIONS 

-- 1. What is the breakdown of employees in the company?

SELECT 
	gender, 
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT 
	race, 
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?

SELECT 
	MIN(age) AS min_age,
	MAX(age) AS max_age
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE();

WITH age_groups AS(
	SELECT 
		CASE
			WHEN age >=18 AND age <=24 THEN '18-24'
			WHEN age >=25 AND age <=34 THEN '25-34'
			WHEN age >=35 AND age <=44 THEN '35-44'
			WHEN age >=45 AND age <=54 THEN '45-54'
			WHEN age >=55 AND age <=64 THEN '55-64'
			ELSE '65+'
		END AS age_group
	FROM hr
	WHERE termdate IS NULL OR termdate > GETDATE()
)
SELECT 
	age_group, 
	COUNT(*) AS count
FROM age_groups
GROUP BY age_group
ORDER BY age_group;

WITH age_groups AS(
	SELECT 
		CASE
			WHEN age >=18 AND age <=24 THEN '18-24'
			WHEN age >=25 AND age <=34 THEN '25-34'
			WHEN age >=35 AND age <=44 THEN '35-44'
			WHEN age >=45 AND age <=54 THEN '45-54'
			WHEN age >=55 AND age <=64 THEN '55-64'
			ELSE '65+'
		END AS age_group, gender
	FROM hr
	WHERE termdate IS NULL OR termdate > GETDATE()
)
SELECT 
	age_group, gender, 
	COUNT(*) AS count
FROM age_groups
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote location?

SELECT 
	location, 
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location;

-- 5. What is the avarage length of employment for employees who have terminated?

SELECT
	AVG(DATEDIFF(YEAR,hire_date, termdate)) AS avg_length_employment
FROM hr
WHERE termdate IS NOT NULL OR termdate <= GETDATE();

-- 6. How does the gender distribution vary across department and job titles?

SELECT 
	department, 
	gender, 
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY department, gender
ORDER BY department, gender;

-- 7. What is the distribution of job titles across the company?

SELECT 
	jobtitle, 
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8. Which department has the highest turnover rate?

SELECT 
	department,
	total_count,
	terminated_count,
	CAST(terminated_count AS FLOAT)/total_count AS termanation_rate
FROM (
	SELECT 
		department,
		COUNT(*) AS total_count,
		SUM(CASE 
				WHEN termdate IS NOT NULL AND termdate <= GETDATE()
				THEN 1 ELSE 0
			END) as terminated_count
	FROM hr
	GROUP BY department
	) AS subquery
ORDER BY department;


-- 9. What is the distribution of employees across location by city and state?
	
SELECT 
	location_state,
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location_state
ORDER BY count DESC;

SELECT 
	location_city,
	COUNT(*) AS count
FROM hr
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location_city
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT
	year,
	hires,
	terminations,
	hires - terminations AS net_change,
	round (CAST((hires - terminations) AS FLOAT)/hires*100,2) AS net_change_percent
FROM (
	SELECT 
		YEAR(hire_date) AS year,
		COUNT(*) AS hires,
		SUM (CASE 
			WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 
			ELSE 0 
			END) AS terminations
	FROM hr
	GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year;

-- 11. What is the tenure distribution for each department?

SELECT 
	department,
	AVG(DATEDIFF(YEAR, hire_date, termdate)) AS avg_tenure
FROM hr
WHERE termdate IS NOT NULL OR termdate <= GETDATE()
GROUP BY department
ORDER BY department;