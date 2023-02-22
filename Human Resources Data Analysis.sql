/*
Human Resources Data Analysis
Skills used: Joins, Update, Minus, Temp Tables, Subqueries, Grouping, CTE's
*/

-- Basic filtering
-- Find employees whose salary is less than $6,000. Return their full name and salary.

SELECT CONCAT(first_name, ' ', last_name) AS full_name, salary
FROM employees
WHERE salary < 6000

-- Find employees who were hired after 1997-09-01. Return their full name and hire date.
-- Using CONCAT will combine strings in the first name column, a space, and last name column.

SELECT CONCAT(first_name, ' ', last_name) AS full_name, hire_date 
FROM employees
WHERE hire_date > '1997-09-01'

-- Alternating tables
-- Create a new column in 'employees' for full name

ALTER TABLE employees
ADD full_name TEXT 

UPDATE employees
SET full_name = CONCAT(employees.first_name, ' ', employees.last_name) 


SELECT TOP (3) employee_id, first_name, last_name, full_name
FROM employees

-- Filtering and joining
-- Job titles are within the Finance department?

--METHOD 1, simple queries
--What is the department ID for the Finance department?

SELECT *
FROM departments
WHERE department_name = 'Finance' 

--Find all job_id's for everyone in the Finance department

SELECT DISTINCT(job_id) 
FROM employees
WHERE department_id = 10


--Find the job titles for job_id's 7 and 6

SELECT job_title AS finance_jobs
FROM jobs
WHERE job_id = 7 OR job_id = 6

--METHOD 2, join

SELECT DISTINCT(jobs.job_title) AS finance_jobs
FROM employees
JOIN jobs ON employees.job_id = jobs.job_id 

-- Which employees have first names OR last names that do not start with the letters 'D' or 'S'? Return their hire date, salary, and department.

SELECT employees.full_name, employees.hire_date, employees.salary, departments.department_name
FROM employees
JOIN departments on employees.department_id = departments.department_id
WHERE employees.first_name NOT LIKE 'D%' AND --Find values that start with D or S and DO NOT include them in the result
        employees.first_name NOT LIKE 'S%' AND
        employees.last_name NOT LIKE 'D%' AND
        employees.last_name NOT LIKE 'S%'

-- Grouping
-- Which location has the most employees?
-- Which is the biggest department?

SELECT TOP 1 E.department_id, D.department_name, COUNT(*) AS employee_count 
FROM employees E 
JOIN departments D
ON E.department_id = D.department_id
GROUP BY E.department_id, D.department_name
ORDER BY employee_count DESC

--Where is the biggest department?

SELECT D.department_name, L.city, L.country_id
FROM departments D
JOIN locations L ON D.location_id = L.location_id
WHERE department_id = 5

-- Which department has the most managers?

SELECT TOP 1 E.department_id, D.department_name, COUNT(DISTINCT(E.manager_id)) manager_count 
FROM employees E
JOIN departments D ON E.department_id = D.department_id 
GROUP BY E.department_id, D.department_name 
ORDER BY manager_count DESC


-- Temporary tables
-- What are the new salaries of all employees, based on their titles?

DROP TABLE IF EXISTS #raises                             
SELECT job_id, job_title,
    (CASE
        WHEN [job_title] LIKE '%President%' OR
            [job_title] LIKE '%Manager%'
            THEN 0.05
        ELSE 0.03 END) AS percent_inc 
INTO #raises 
FROM jobs
SELECT E.employee_id, E.full_name, E.job_id, E.salary AS old_salary, R.percent_inc, (E.salary + E.salary*R.percent_inc) AS new_salary 
FROM employees E
JOIN #raises R ON E.job_id = R.job_id


-- CTE
-- Which employees do not have dependents?
 
WITH dependentless AS (
    SELECT employee_id
    FROM employees
    EXCEPT --Do not include rows that appear in this query below
    SELECT employee_id
    FROM dependents)
SELECT D.employee_id, E.full_name
FROM dependentless D
JOIN employees E ON D.employee_id = E.employee_id