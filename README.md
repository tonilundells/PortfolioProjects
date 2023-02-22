# SQL Data Querying/ Human Resources
## Skills Used: `Joins`, `Update`, `Minus`, `Temp Tables`, `Subqueries`, `Grouping`, `CTE's`

### <span style="font-size: 14px;"><b>Project Overview</b></span>

<span style="font-size: 14px;">Using a&nbsp;</span> [sample SQL database](https://www.sqltutorial.org/sql-sample-database/) <span style="font-size: 14px;">&nbsp;that manages HR data of a small buisness.

### **Database Structure**

![Image of database structure](https://www.sqltutorial.org/wp-content/uploads/2016/04/SQL-Sample-Database-Schema.png))


### _Basic filtering_

Looking for employees whose salary is less than $6,000. Return their full name and salary.

```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name, salary
FROM employees
WHERE salary < 6000
```

<table><tr><th>full_name</th><th>salary</th></tr><tr><td>David Austin</td><td>4800.00</td></tr><tr><td>Valli Pataballa</td><td>4800.00</td></tr><tr><td>Diana Lorentz</td><td>4200.00</td></tr><tr><td>Alexander Khoo</td><td>3100.00</td></tr><tr><td>Shelli Baida</td><td>2900.00</td></tr><tr><td>Sigal Tobias</td><td>2800.00</td></tr><tr><td>Guy Himuro</td><td>2600.00</td></tr><tr><td>Karen Colmenares</td><td>2500.00</td></tr><tr><td>Irene Mikkilineni</td><td>2700.00</td></tr><tr><td>Sarah Bell</td><td>4000.00</td></tr><tr><td>Britney Everett</td><td>3900.00</td></tr><tr><td>Jennifer Whalen</td><td>4400.00</td></tr></table>

Looking for employees who were hired after 1997-09-01. Return their full name and hire date.

Using CONCAT will combine strings in the first name column, a space, and last name column.

```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name, hire_date 
FROM employees
WHERE hire_date > '1997-09-01'
```

<table><tr><th>full_name</th><th>hire_date</th></tr><tr><td>Valli Pataballa</td><td>1998-02-05</td></tr><tr><td>Diana Lorentz</td><td>1999-02-07</td></tr><tr><td>John Chen</td><td>1997-09-28</td></tr><tr><td>Ismael Sciarra</td><td>1997-09-30</td></tr><tr><td>Jose Manuel Urman</td><td>1998-03-07</td></tr><tr><td>Luis Popp</td><td>1999-12-07</td></tr><tr><td>Shelli Baida</td><td>1997-12-24</td></tr><tr><td>Guy Himuro</td><td>1998-11-15</td></tr><tr><td>Karen Colmenares</td><td>1999-08-10</td></tr><tr><td>Shanta Vollman</td><td>1997-10-10</td></tr><tr><td>Irene Mikkilineni</td><td>1998-09-28</td></tr><tr><td>Jonathon Taylor</td><td>1998-03-24</td></tr><tr><td>Jack Livingston</td><td>1998-04-23</td></tr><tr><td>Kimberely Grant</td><td>1999-05-24</td></tr><tr><td>Charles Johnson</td><td>2000-01-04</td></tr></table>


### _Alternating tables_

Creating a new column in 'employees' for full name

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

<table><tr><th>employee_id</th><th>first_name</th><th>last_name</th><th>full_name</th></tr><tr><td>100</td><td>Steven</td><td>King</td><td>Steven King</td></tr><tr><td>101</td><td>Neena</td><td>Kochhar</td><td>Neena Kochhar</td></tr><tr><td>102</td><td>Lex</td><td>De Haan</td><td>Lex De Haan</td></tr></table>

### _Filtering and joining_

Job titles within the Finance department


_METHOD 1_, simple queries

What is the department ID for the Finance department?

```sql
SELECT *
FROM departments
WHERE department_name = 'Finance' 
```

<table><tr><th>department_id</th><th>department_name</th><th>location_id</th></tr><tr><td>10</td><td>Finance</td><td>1700</td></tr></table>

Find all job_id's for everyone in the Finance department

```sql
SELECT DISTINCT(job_id) 
FROM employees
WHERE department_id = 10
```

<table><tr><th>job_id</th></tr><tr><td>6</td></tr><tr><td>7</td></tr></table>

Find the job titles for job_id's 7 and 6

```sql
SELECT job_title AS finance_jobs
FROM jobs
WHERE job_id = 7 OR job_id = 6
```

<table><tr><th>finance_jobs</th></tr><tr><td>Accountant</td></tr><tr><td>Finance Manager</td></tr></table>

_METHOD 2_, join

```sql
SELECT DISTINCT(jobs.job_title) AS finance_jobs
FROM employees
JOIN jobs ON employees.job_id = jobs.job_id 
```

<table><tr><th>finance_jobs</th></tr><tr><td>Accountant</td></tr><tr><td>Finance Manager</td></tr></table>

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

<table><tr><th>full_name</th><th>hire_date</th><th>salary</th><th>department_name</th></tr><tr><td>Neena Kochhar</td><td>1989-09-21</td><td>17000.00</td><td>Executive</td></tr><tr><td>Alexander Hunold</td><td>1990-01-03</td><td>9000.00</td><td>IT</td></tr><tr><td>Bruce Ernst</td><td>1991-05-21</td><td>6000.00</td><td>IT</td></tr><tr><td>Valli Pataballa</td><td>1998-02-05</td><td>4800.00</td><td>IT</td></tr><tr><td>Nancy Greenberg</td><td>1994-08-17</td><td>12000.00</td><td>Finance</td></tr><tr><td>John Chen</td><td>1997-09-28</td><td>8200.00</td><td>Finance</td></tr><tr><td>Jose Manuel Urman</td><td>1998-03-07</td><td>7800.00</td><td>Finance</td></tr><tr><td>Luis Popp</td><td>1999-12-07</td><td>6900.00</td><td>Finance</td></tr><tr><td>Alexander Khoo</td><td>1995-05-18</td><td>3100.00</td><td>Purchasing</td></tr><tr><td>Guy Himuro</td><td>1998-11-15</td><td>2600.00</td><td>Purchasing</td></tr><tr><td>Karen Colmenares</td><td>1999-08-10</td><td>2500.00</td><td>Purchasing</td></tr><tr><td>Matthew Weiss</td><td>1996-07-18</td><td>8000.00</td><td>Shipping</td></tr><tr><td>Adam Fripp</td><td>1997-04-10</td><td>8200.00</td><td>Shipping</td></tr><tr><td>Payam Kaufling</td><td>1995-05-01</td><td>7900.00</td><td>Shipping</td></tr><tr><td>Irene Mikkilineni</td><td>1998-09-28</td><td>2700.00</td><td>Shipping</td></tr><tr><td>John Russell</td><td>1996-10-01</td><td>14000.00</td><td>Sales</td></tr><tr><td>Karen Partners</td><td>1997-01-05</td><td>13500.00</td><td>Sales</td></tr><tr><td>Jonathon Taylor</td><td>1998-03-24</td><td>8600.00</td><td>Sales</td></tr><tr><td>Jack Livingston</td><td>1998-04-23</td><td>8400.00</td><td>Sales</td></tr><tr><td>Kimberely Grant</td><td>1999-05-24</td><td>7000.00</td><td>Sales</td></tr><tr><td>Charles Johnson</td><td>2000-01-04</td><td>6200.00</td><td>Sales</td></tr><tr><td>Britney Everett</td><td>1997-03-03</td><td>3900.00</td><td>Shipping</td></tr><tr><td>Jennifer Whalen</td><td>1987-09-17</td><td>4400.00</td><td>Administration</td></tr><tr><td>Michael Hartstein</td><td>1996-02-17</td><td>13000.00</td><td>Marketing</td></tr><tr><td>Pat Fay</td><td>1997-08-17</td><td>6000.00</td><td>Marketing</td></tr><tr><td>Hermann Baer</td><td>1994-06-07</td><td>10000.00</td><td>Public Relations</td></tr><tr><td>William Gietz</td><td>1994-06-07</td><td>8300.00</td><td>Accounting</td></tr></table>

### _Grouping_

Location with the most employees

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

<table><tr><th>department_id</th><th>department_name</th><th>employee_count</th></tr><tr><td>5</td><td>Shipping</td><td>7</td></tr></table>

<table><tr><th>department_name</th><th>city</th><th>country_id</th></tr><tr><td>Shipping</td><td>South San Francisco</td><td>US</td></tr></table>

Which department has the most managers?

```sql
SELECT TOP 1 E.department_id, D.department_name, COUNT(DISTINCT(E.manager_id)) manager_count 
FROM employees E
JOIN departments D ON E.department_id = D.department_id 
GROUP BY E.department_id, D.department_name 
ORDER BY manager_count DESC
```

<table><tr><th>department_id</th><th>department_name</th><th>manager_count</th></tr><tr><td>5</td><td>Shipping</td><td>3</td></tr></table>

### _Temporary tables_

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

<table><tr><th>employee_id</th><th>full_name</th><th>job_id</th><th>old_salary</th><th>percent_inc</th><th>new_salary</th></tr><tr><td>100</td><td>Steven King</td><td>4</td><td>24000.00</td><td>0.05</td><td>25200.0000</td></tr><tr><td>101</td><td>Neena Kochhar</td><td>5</td><td>17000.00</td><td>0.05</td><td>17850.0000</td></tr><tr><td>102</td><td>Lex De Haan</td><td>5</td><td>17000.00</td><td>0.05</td><td>17850.0000</td></tr><tr><td>103</td><td>Alexander Hunold</td><td>9</td><td>9000.00</td><td>0.03</td><td>9270.0000</td></tr><tr><td>104</td><td>Bruce Ernst</td><td>9</td><td>6000.00</td><td>0.03</td><td>6180.0000</td></tr><tr><td>105</td><td>David Austin</td><td>9</td><td>4800.00</td><td>0.03</td><td>4944.0000</td></tr><tr><td>106</td><td>Valli Pataballa</td><td>9</td><td>4800.00</td><td>0.03</td><td>4944.0000</td></tr><tr><td>107</td><td>Diana Lorentz</td><td>9</td><td>4200.00</td><td>0.03</td><td>4326.0000</td></tr><tr><td>108</td><td>Nancy Greenberg</td><td>7</td><td>12000.00</td><td>0.05</td><td>12600.0000</td></tr><tr><td>109</td><td>Daniel Faviet</td><td>6</td><td>9000.00</td><td>0.03</td><td>9270.0000</td></tr><tr><td>110</td><td>John Chen</td><td>6</td><td>8200.00</td><td>0.03</td><td>8446.0000</td></tr><tr><td>111</td><td>Ismael Sciarra</td><td>6</td><td>7700.00</td><td>0.03</td><td>7931.0000</td></tr><tr><td>112</td><td>Jose Manuel Urman</td><td>6</td><td>7800.00</td><td>0.03</td><td>8034.0000</td></tr><tr><td>113</td><td>Luis Popp</td><td>6</td><td>6900.00</td><td>0.03</td><td>7107.0000</td></tr><tr><td>114</td><td>Den Raphaely</td><td>14</td><td>11000.00</td><td>0.05</td><td>11550.0000</td></tr><tr><td>115</td><td>Alexander Khoo</td><td>13</td><td>3100.00</td><td>0.03</td><td>3193.0000</td></tr><tr><td>116</td><td>Shelli Baida</td><td>13</td><td>2900.00</td><td>0.03</td><td>2987.0000</td></tr><tr><td>117</td><td>Sigal Tobias</td><td>13</td><td>2800.00</td><td>0.03</td><td>2884.0000</td></tr><tr><td>118</td><td>Guy Himuro</td><td>13</td><td>2600.00</td><td>0.03</td><td>2678.0000</td></tr><tr><td>119</td><td>Karen Colmenares</td><td>13</td><td>2500.00</td><td>0.03</td><td>2575.0000</td></tr><tr><td>120</td><td>Matthew Weiss</td><td>19</td><td>8000.00</td><td>0.05</td><td>8400.0000</td></tr><tr><td>121</td><td>Adam Fripp</td><td>19</td><td>8200.00</td><td>0.05</td><td>8610.0000</td></tr><tr><td>122</td><td>Payam Kaufling</td><td>19</td><td>7900.00</td><td>0.05</td><td>8295.0000</td></tr><tr><td>123</td><td>Shanta Vollman</td><td>19</td><td>6500.00</td><td>0.05</td><td>6825.0000</td></tr><tr><td>126</td><td>Irene Mikkilineni</td><td>18</td><td>2700.00</td><td>0.03</td><td>2781.0000</td></tr><tr><td>145</td><td>John Russell</td><td>15</td><td>14000.00</td><td>0.05</td><td>14700.0000</td></tr><tr><td>146</td><td>Karen Partners</td><td>15</td><td>13500.00</td><td>0.05</td><td>14175.0000</td></tr><tr><td>176</td><td>Jonathon Taylor</td><td>16</td><td>8600.00</td><td>0.03</td><td>8858.0000</td></tr><tr><td>177</td><td>Jack Livingston</td><td>16</td><td>8400.00</td><td>0.03</td><td>8652.0000</td></tr><tr><td>178</td><td>Kimberely Grant</td><td>16</td><td>7000.00</td><td>0.03</td><td>7210.0000</td></tr><tr><td>179</td><td>Charles Johnson</td><td>16</td><td>6200.00</td><td>0.03</td><td>6386.0000</td></tr><tr><td>192</td><td>Sarah Bell</td><td>17</td><td>4000.00</td><td>0.03</td><td>4120.0000</td></tr><tr><td>193</td><td>Britney Everett</td><td>17</td><td>3900.00</td><td>0.03</td><td>4017.0000</td></tr><tr><td>200</td><td>Jennifer Whalen</td><td>3</td><td>4400.00</td><td>0.03</td><td>4532.0000</td></tr><tr><td>201</td><td>Michael Hartstein</td><td>10</td><td>13000.00</td><td>0.05</td><td>13650.0000</td></tr><tr><td>202</td><td>Pat Fay</td><td>11</td><td>6000.00</td><td>0.03</td><td>6180.0000</td></tr><tr><td>203</td><td>Susan Mavris</td><td>8</td><td>6500.00</td><td>0.03</td><td>6695.0000</td></tr><tr><td>204</td><td>Hermann Baer</td><td>12</td><td>10000.00</td><td>0.03</td><td>10300.0000</td></tr><tr><td>205</td><td>Shelley Higgins</td><td>2</td><td>12000.00</td><td>0.05</td><td>12600.0000</td></tr><tr><td>206</td><td>William Gietz</td><td>1</td><td>8300.00</td><td>0.03</td><td>8549.0000</td></tr></table>

### _CTE_

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

<table><tr><th>employee_id</th><th>full_name</th></tr><tr><td>120</td><td>Matthew Weiss</td></tr><tr><td>121</td><td>Adam Fripp</td></tr><tr><td>122</td><td>Payam Kaufling</td></tr><tr><td>123</td><td>Shanta Vollman</td></tr><tr><td>126</td><td>Irene Mikkilineni</td></tr><tr><td>177</td><td>Jack Livingston</td></tr><tr><td>178</td><td>Kimberely Grant</td></tr><tr><td>179</td><td>Charles Johnson</td></tr><tr><td>192</td><td>Sarah Bell</td></tr><tr><td>193</td><td>Britney Everett</td></tr></table>
