-- Write a query to create a table named Departments with three columns: dept_id (Integer, Primary Key), dept_name (Text/VARCHAR of length 50, Not Null), and city (Text/VARCHAR of length 50).

CREATE TABLE department (
	dept_id INT PRIMARY KEY NOT NULL,
	dept_name VARCHAR(50) NOT NULL UNIQUE,
	city VARCHAR(50)
);

SELECT * FROM department

-- Add a new column named email (VARCHAR(100)) to the existing Employees table using the ALTER TABLE statement.

ALTER TABLE department
ADD email VARCHAR(100) NOT NULL

-- Inserting New Values into the Table
INSERT INTO department(dept_id, dept_name, city, email)
VALUES
	(1, 'Computer', 'Pune', 'comp@example.com'),
	(2, 'ELectronics', 'Nagpur', 'ele@example.com'),
	(3, 'Wine Tech', 'Nashik', 'wine@example.com'),
	(4, 'Bussiness', 'Mumbai', 'buss@example.com')

-- Deleting Only Data from the Table
TRUNCATE TABLE department

-- Deleting Whole Table From Database
Drop Table department
