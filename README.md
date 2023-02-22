# Human Resources Data Analysis
## Skills used: Joins, Update, Minus, Temp Tables, Subqueries, Grouping, CTE's


_Basic filtering_

Find employees whose salary is less than $6,000. Return their full name and salary.

```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name, salary
FROM employees
WHERE salary < 6000
```

<table><tr><th>full_name</th><th>salary</th></tr><tr><td>David Austin</td><td>4800.00</td></tr><tr><td>Valli Pataballa</td><td>4800.00</td></tr><tr><td>Diana Lorentz</td><td>4200.00</td></tr><tr><td>Alexander Khoo</td><td>3100.00</td></tr><tr><td>Shelli Baida</td><td>2900.00</td></tr><tr><td>Sigal Tobias</td><td>2800.00</td></tr><tr><td>Guy Himuro</td><td>2600.00</td></tr><tr><td>Karen Colmenares</td><td>2500.00</td></tr><tr><td>Irene Mikkilineni</td><td>2700.00</td></tr><tr><td>Sarah Bell</td><td>4000.00</td></tr><tr><td>Britney Everett</td><td>3900.00</td></tr><tr><td>Jennifer Whalen</td><td>4400.00</td></tr></table>

Find employees who were hired after 1997-09-01. Return their full name and hire date.

Using CONCAT will combine strings in the first name column, a space, and last name column.

```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name, hire_date 
FROM employees
WHERE hire_date > '1997-09-01'
```

<table><tr><th>full_name</th><th>hire_date</th></tr><tr><td>Valli Pataballa</td><td>1998-02-05</td></tr><tr><td>Diana Lorentz</td><td>1999-02-07</td></tr><tr><td>John Chen</td><td>1997-09-28</td></tr><tr><td>Ismael Sciarra</td><td>1997-09-30</td></tr><tr><td>Jose Manuel Urman</td><td>1998-03-07</td></tr><tr><td>Luis Popp</td><td>1999-12-07</td></tr><tr><td>Shelli Baida</td><td>1997-12-24</td></tr><tr><td>Guy Himuro</td><td>1998-11-15</td></tr><tr><td>Karen Colmenares</td><td>1999-08-10</td></tr><tr><td>Shanta Vollman</td><td>1997-10-10</td></tr><tr><td>Irene Mikkilineni</td><td>1998-09-28</td></tr><tr><td>Jonathon Taylor</td><td>1998-03-24</td></tr><tr><td>Jack Livingston</td><td>1998-04-23</td></tr><tr><td>Kimberely Grant</td><td>1999-05-24</td></tr><tr><td>Charles Johnson</td><td>2000-01-04</td></tr></table>


_Alternating tables_

Create a new column in 'employees' for full name

```sql
ALTER TABLE employees
ADD full_name TEXT 
```

```sql
UPDATE employees
SET full_name = CONCAT(employees.first_name, ' ', employees.last_name) 
```

```sql
SELECT TOP (3) employee_id, first_name, last_name, full_name
FROM employees
```

_Filtering and joining_

Job titles are within the Finance department?


METHOD 1, simple queries

What is the department ID for the Finance department?

```sql
SELECT *
FROM departments
WHERE department_name = 'Finance' 
```

Find all job_id's for everyone in the Finance department

```sql
SELECT DISTINCT(job_id) 
FROM employees
WHERE department_id = 10
```

Find the job titles for job_id's 7 and 6

```sql
SELECT job_title AS finance_jobs
FROM jobs
WHERE job_id = 7 OR job_id = 6
```

METHOD 2, join

```sql
SELECT DISTINCT(jobs.job_title) AS finance_jobs
FROM employees
JOIN jobs ON employees.job_id = jobs.job_id 
```

Which employees have first names OR last names that do not start with the letters 'D' or 'S'? Return their hire date, salary, and department.

```sql
SELECT employees.full_name, employees.hire_date, employees.salary, departments.department_name
FROM employees
JOIN departments on employees.department_id = departments.department_id
WHERE employees.first_name NOT LIKE 'D%' AND --Find values that start with D or S and DO NOT include them in the result
        employees.first_name NOT LIKE 'S%' AND
        employees.last_name NOT LIKE 'D%' AND
        employees.last_name NOT LIKE 'S%'
```

_Grouping_

Which location has the most employees?

Which is the biggest department?

```sql
SELECT TOP 1 E.department_id, D.department_name, COUNT(*) AS employee_count 
FROM employees E 
JOIN departments D
ON E.department_id = D.department_id
GROUP BY E.department_id, D.department_name
ORDER BY employee_count DESC
```
Where is the biggest department?

```sql
SELECT D.department_name, L.city, L.country_id
FROM departments D
JOIN locations L ON D.location_id = L.location_id
WHERE department_id = 5
```

Which department has the most managers?

```sql
SELECT TOP 1 E.department_id, D.department_name, COUNT(DISTINCT(E.manager_id)) manager_count 
FROM employees E
JOIN departments D ON E.department_id = D.department_id 
GROUP BY E.department_id, D.department_name 
ORDER BY manager_count DESC
```

_Temporary tables_

What are the new salaries of all employees, based on their titles?

```sql
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
```

_CTE_

Which employees do not have dependents?
 
 ```sql
WITH dependentless AS (
    SELECT employee_id
    FROM employees
    EXCEPT --Do not include rows that appear in this query below
    SELECT employee_id
    FROM dependents)
SELECT D.employee_id, E.full_name
FROM dependentless D
JOIN employees E ON D.employee_id = E.employee_id
```
