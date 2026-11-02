-- Write a query to find all players from Germany who have a score greater than 400, OR any player from the USA regardless of their score.

SELECT *
FROM customers
WHERE ( country = 'Germany' AND score > 400 ) OR country = 'USA'

-- Find all players whose first_name starts with 'M' and contains exactly 5 characters in total.

SELECT *
FROM customers
WHERE first_name LIKE 'M%' AND LEN(first_name) = 5;

-- Find all players whose first_name starts with 'M' and contains exactly 5 characters in total.

SELECT *
FROM customers
WHERE first_name LIKE 'M%' AND LEN(first_name) = 5;

-- Retrieve all columns, but order the results so that players from USA appear first. For all other countries, sort them alphabetically by country ( A - Z ).

SELECT *
FROM customers
ORDER BY 
	CASE 
		WHEN country = 'USA' THEN 0 ELSE 1
	END,
	country ASC;

-- Select all rows and sort the data by country in ascending order. If multiple players are from the same country, sort them by score in descending order.

SELECT *
FROM customers
ORDER BY country ASC, score DESC

-- Write a query to find the details of the player(s) who scored higher than the overall average score of all players in the table.

SELECT * 
FROM customers
WHERE score > (
	SELECT AVG(score) 
	FROM customers
)

-- Find all players who have a score that is neither 0 nor 900, but only if their ID is an odd number.

SELECT *
FROM customers
WHERE ( score != 0 AND score != 900) AND id % 2 != 0

-- Write a query that displays all columns, along with a new column called country_rank that ranks players by their score highest to lowest within their own country.


SELECT 
    id,
    first_name,
    country,
    score,
    DENSE_RANK() OVER(PARTITION BY country ORDER BY score DESC) AS country_rank
FROM customers;

-- Write a query that displays all columns, along with a new column called country_rank that ranks players by their score LOWEST to HIGHEST within their own country.

SELECT 
	*,
	DENSE_RANK() OVER (PARTITION BY country ORDER BY score ASC ) AS country_rank
FROM customers

/*
Display the first_name and score, along with a third column called performance_tier.
• If score is 700 or above, tier is 'Elite'.
• If score is between 1 and 699, tier is 'Average'.
• If score is 0, tier is 'In-Active'.
*/

SELECT 
	id,
	first_name,
	score,
	CASE
		WHEN score >= 700 THEN 'ELITE'
		WHEN score >= 1 AND score <= 699 THEN 'AVERAGE'
		WHEN score = 0 THEN 'IN-ACTIVE'
	END AS performance_tier
FROM customers

-- Without using LIMIT or TOP, write a query to find the second highest score in the entire table.

SELECT MAX(score) AS second_highest
FROM customers
WHERE score < (
	SELECT MAX(	score )
	FROM customers
);

--Without using LIMIT or TOP, write a query to find the second LOWEST score in the entire table.

SELECT MIN(score) as second_lowest
FROM customers
WHERE score > (
	SELECT MIN(score) 
	FROM customers) ;

-- Write a query to find countries where the maximum score is at least 500 AND the minimum score is strictly greater than 0. Return the country name and its total number of players.

SELECT
	country,
	COUNT(id) AS total_players 
FROM customers
GROUP BY country
HAVING MAX(score) <= 500 AND MIN(score) > 0

-- Write a query to calculate the average score of each country. However, using a HAVING clause, only return countries that have at least one player whose individual score is over 800.

SELECT 
	country,
	AVG(score) AS average
FROM customers
GROUP BY country 
Having MAX(score) > 800

-- Write a query using GROUP BY and HAVING to find countries whose average score is higher than the average score of Germany. (Hint: You will need a subquery inside your HAVING clause).

SELECT 
	country,
	AVG(score)
FROM customers
GROUP BY country
HAVING AVG(score) > (
	SELECT AVG(score)
	FROM customers
	WHERE country = 'Germany'
);

-- Write a query using GROUP BY and HAVING to find countries whose average score is higher than the average score of Germany. (Hint: You will need a subquery inside your HAVING clause).

SELECT 
	country,
	AVG(score)
FROM customers
GROUP BY country
HAVING AVG(score) > (
	SELECT AVG(score)
	FROM customers
	WHERE country = 'Germany'
);

-- Write a query that displays the first_name, country, and a column showing the cumulative (running) sum of scores for players within each country, ordered alphabetically by their name.



SELECT 
	first_name,
	country,
	SUM(score) OVER ( ORDER BY first_name ASC ) AS cumulative_sum
FROM customers;

/*
Display the first_name, score, and a new column called country_contribution.
• If a player's score is above their own country's average score, label them 'Above Average'.
• If it is exactly equal or below, label them 'Below or Equal'.
*/

SELECT 
	first_name,
	score,
	CASE
		WHEN score > AVG(score) OVER(PARTITION BY country ) THEN 'ABOVE AVERAGE'
		WHEN score = AVG(score) OVER(PARTITION BY country )  THEN 'EQUAL'
		WHEN score < AVG(score) OVER(PARTITION BY country )  THEN 'BELOW'
	END AS country_contribution
FROM customers
ORDER BY first_name 


		