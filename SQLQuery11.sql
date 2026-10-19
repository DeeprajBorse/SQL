-- Find all players who have a score that is neither 0 nor 900, but only if their ID is an odd number.

SELECT *
FROM customers
WHERE ( score != 0 AND score != 900) AND id % 2 != 0