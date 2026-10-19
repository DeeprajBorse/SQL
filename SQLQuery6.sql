-- Find all players whose first_name starts with 'M' and contains exactly 5 characters in total.

SELECT *
FROM customers
WHERE first_name LIKE 'M%' AND LEN(first_name) = 5;

