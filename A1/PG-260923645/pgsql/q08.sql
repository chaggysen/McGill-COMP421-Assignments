SELECT uname, email
FROM users
WHERE userid IN (
	SELECT userid
	FROM review
	WHERE movid IN (
		SELECT movid
		FROM releaselanguages
		GROUP BY movid
		HAVING COUNT(*) = 1 AND MAX(releaselanguages.language) = 'French'
	)
) ORDER BY email;
