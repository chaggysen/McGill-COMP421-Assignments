SELECT title, COUNT(rv.movid) AS numreviews
FROM movies
LEFT JOIN
(
	SELECT *
	FROM review
)rv ON movies.movid = rv.movid
WHERE releasedate = (
	SELECT releasedate
	FROM movies
	ORDER BY releasedate DESC LIMIT 1
)
GROUP BY movies.movid
ORDER BY title;
