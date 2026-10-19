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


		