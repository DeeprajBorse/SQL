-- DML Comands - Manipulates the Data Into the Table
-- Inserting New Data Into customers table

INSERT INTO customers (id, first_name, country, score)
VALUES (1, 'Maria', 'UK', 350)

SELECT * FROM customers

INSERT INTO customers (id, first_name, country, score)
VALUES 
	(2, 'Maxx', 'USA', 900),
	(3, 'Anna', 'UK', 450),
	(4, 'Alex', 'Germany', 750),
	(5, 'Sarha', 'USA', 0)

INSERT INTO persons (id, person_name, phone, email)
VALUES (1, 'Anna', '9568956896', 'anna@example.com')

SELECT * FROM persons

INSERT INTO persons (id, person_name, phone, email)
VALUES
	(2, 'Jose', '9854632566', 'jose@example.com'),
	(3, 'John', '9963256396', 'john@example.com'),
	(4, 'Ellie', '875963256', 'ellie@example.com'),
	(5, 'Nolan', '9977558866', 'nolan@example.com')

ALTER TABLE persons
ADD country VARCHAR(25)


SELECT * FROM customers

UPDATE customers 
SET score = 0
WHERE score IS NULL

-- DELETING ONLY DATA FROM THE TABLE  
DELETE FROM customers
WHERE id = 10

-- DELETING ALL THE DATA FROM THE TABLE
-- HERE BOTH ARE DOING SAME THING DELETING OVERALL DATA FROM THE TABLE BUT HERE DELETE TAKES MORE TIME AS COMPARE TO TRUNCATE i.e. TRUNCATE is Faster than delete 

DELETE FROM persons  

TRUNCATE TABLE	persons




