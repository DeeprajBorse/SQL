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
