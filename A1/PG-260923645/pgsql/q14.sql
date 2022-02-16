SELECT title, releasedate, AVG(rv.rating) AS avgrating
FROM movies
LEFT JOIN
(
	SELECT *
	FROM review
) rv ON movies.movid = rv.movid
WHERE (
	SELECT COUNT(*)
	FROM review
	WHERE review.movid = movies.movid
) >= 2
GROUP BY movies.movid
ORDER BY avgrating DESC, releasedate, title;
