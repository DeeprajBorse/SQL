-- Write a query to find all players from Germany who have a score greater than 400, OR any player from the USA regardless of their score.

SELECT *
FROM customers
WHERE ( country = 'Germany' AND score > 400 ) OR country = 'USA'