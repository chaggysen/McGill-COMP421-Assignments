SELECT userid
FROM review
WHERE review.movid = (
	SELECT movid
	FROM movies
	WHERE movies.title = 'Casablanca'
)
ORDER BY userid
