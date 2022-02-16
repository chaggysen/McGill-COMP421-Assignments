SELECT DISTINCT title, releasedate
FROM movies
LEFT JOIN
(
	SELECT *
	FROM review
) rv on movies.movid = rv.movid
WHERE (
	SELECT AVG(rating)
	FROM review
	WHERE review.movid = movies.movid AND review.reviewdate < '2019-01-01'
) >= 7 AND
((
	SELECT AVG(rating)
	FROM review
	WHERE review.movid = movies.movid AND review.reviewdate >= '2019-01-01'
) <= 5 OR (SELECT COUNT(*) FROM review WHERE review.movid = movies.movid AND review.reviewdate >= '2019-01-01') = 0)
ORDER BY releasedate, title;
