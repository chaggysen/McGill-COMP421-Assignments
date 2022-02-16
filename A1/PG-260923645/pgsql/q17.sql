SELECT email
FROM users
WHERE users.email != 'cinebuff@movieinfo.com'
AND users.userid IN (
	SELECT userid
	FROM review AS rv
	WHERE rv.movid IN (
		SELECT movid
		FROM review
		WHERE userid = (
			SELECT userid
			FROM users
			WHERE users.email = 'cinebuff@movieinfo.com'
		)
	) AND ABS(rv.rating - (SELECT rating FROM review WHERE userid = (SELECT userid FROM users WHERE users.email = 'cinebuff@movieinfo.com') AND rv.movid = review.movid)) <= 1 
) ORDER BY email;
