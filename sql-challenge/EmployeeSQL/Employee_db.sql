
CREATE TABLE titles(
	title_id VARCHAR PRIMARY KEY,
	title VARCHAR NOT NULL
);

SELECT * FROM titles;

CREATE TABLE departments(
	dept_no VARCHAR PRIMARY KEY,
	dept_name VARCHAR
);

SELECT * FROM departments;

CREATE TABLE employees(
	emp_no INT PRIMARY KEY,
	emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY(emp_title_id) REFERENCES titles(title_id)
);

SELECT * FROM employees;

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE salaries(
	emp_no INT PRIMARY KEY,
	salary INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM salaries;

CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM dept_manager;

--#1 List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.first_name, employees.last_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON
salaries.emp_no=employees.emp_no;

--#2 List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date FROM employees
WHERE hire_date >= '1986-01-01' AND hire_date <= '1986-12-31';

--#3 List the manager of each department along with their department number, department name, employee number, last name, and first name.
CREATE VIEW manager AS
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no
FROM departments
INNER JOIN dept_manager ON
departments.dept_no= dept_manager.dept_no;

SELECT * FROM manager;

SELECT manager.dept_no, manager.dept_name, manager.emp_no, employees.first_name, employees.last_name
FROM manager
INNER JOIN employees ON
manager.emp_no=employees.emp_no;

--#4 List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
CREATE VIEW employee_department AS
SELECT dept_emp.emp_no, dept_emp.dept_no, departments.dept_name 
FROM dept_emp
INNER JOIN departments ON
dept_emp.dept_no=departments.dept_no;

SELECT * FROM employee_department;

CREATE VIEW emp_dept AS
SELECT employees.first_name, employees.last_name, employee_department.emp_no, employee_department.dept_no, employee_department.dept_name
FROM employees
INNER JOIN employee_department ON
employees.emp_no=employee_department.emp_no;

SELECT * FROM emp_dept;

--#5 List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--#6 List each employee in the Sales department, including their employee number, last name, and first name.
SELECT emp_no, last_name, first_name
FROM emp_dept
WHERE dept_name='Sales';

--#7 List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT emp_no, last_name, first_name, dept_name
FROM emp_dept
WHERE dept_name='Sales' OR dept_name='Development';

--#8 List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "last_name count"
FROM employees
GROUP BY last_name
ORDER BY "last_name count" DESC;