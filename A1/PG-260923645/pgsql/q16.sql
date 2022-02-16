SELECT title, releasedate, AVG(rv.rating) AS avgrating
FROM movies
LEFT JOIN(
	SELECT *
	FROM review
) rv ON movies.movid = rv.movid
WHERE movies.movid IN (
	SELECT movid
	FROM moviegenres
	WHERE genre = 'Comedy'
) AND movies.movid NOT IN (
	SELECT movid
	FROM review
	WHERE review.userid = (
		SELECT userid
		FROM users
		WHERE users.email = 'cinebuff@movieinfo.com'
	)
)
GROUP BY movies.movid
HAVING AVG(rv.rating) >= (
	SELECT AVG(rating)
	FROM review
	WHERE review.movid IN (SELECT movid FROM moviegenres WHERE moviegenres.genre = 'Comedy')
	AND review.userid = (SELECT userid FROM users WHERE users.email = 'cinebuff@movieinfo.com')
)
ORDER BY avgrating DESC, releasedate, title;
