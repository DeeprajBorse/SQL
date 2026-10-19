-- Inserting ( -using SELECT- )

INSERT INTO persons (id, person_name, phone, email)
SELECT 
	id,
	first_name,
	'Unknown',
	'abd@example.com',
	Null
FROM customers

SELECT * FROM persons

UPDATE persons
SET email = 'abc@example.com'