-- WHERE OPERATORS
-- COMPARISION OPERATORS (=,<,<=,>,>=,<>,!=)

USE MyDatabase

SELECT *
FROM customers AS c
WHERE c.score = 900

SELECT *
FROM customers AS c
WHERE c.score > 500

SELECT *
FROM customers AS c
WHERE c.score >= 500

UPDATE customers
SET score = 500
WHERE id = 3

SELECT *
FROM customers AS c
WHERE c.score < 500

SELECT *
FROM customers AS c
WHERE c.score <= 500

SELECT *
FROM customers AS c
WHERE c.score != 0

-- LOGICAL OPERATORS
SELECT *
FROM customers AS c
WHERE c.country = 'USA' AND score > 500

SELECT *
FROM customers AS c
WHERE c.country = 'USA' OR score > 500

SELECT *
FROM customers AS c
WHERE NOT(c.score>500)

-- RANGE OPERATOR

SELECT *
FROM customers
WHERE score BETWEEN 100 AND 750

-- BUT HERE CORNER VALUES ARE INCLUSIVE 
--PREFER THIS
SELECT * 
FROM customers AS c
WHERE c.score >= 100 AND c.score <= 750

-- Membership Operator
SELECT *
FROM customers AS c
WHERE c.country IN ('USA')

SELECT *
FROM customers AS c
WHERE c.country NOT IN ('USA')

-- SEARCH OPERATOR 
SELECT *
FROM customers AS c
WHERE c.first_name LIKE 'M%'

SELECT *
FROM customers AS c
WHERE c.first_name LIKE '%a'

SELECT *
FROM customers AS c
WHERE c.first_name LIKE '%R%'

SELECT *
FROM customers AS c
WHERE c.first_name LIKE '__e%'