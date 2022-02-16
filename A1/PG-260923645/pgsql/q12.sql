SELECT title, releasedate, COUNT(rv.movid) AS numreviews
FROM movies
LEFT JOIN
(
	SELECT movid
	FROM review
) rv ON movies.movid = rv.movid
WHERE releasedate >= '2021-01-01' AND releasedate < '2022-01-01'
GROUP BY movies.movid
ORDER BY numreviews DESC, releasedate, title;
