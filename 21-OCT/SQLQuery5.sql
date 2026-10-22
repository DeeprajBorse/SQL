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