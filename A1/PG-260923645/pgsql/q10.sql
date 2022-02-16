SELECT title, releasedate
FROM movies
WHERE movies.movid IN (
	SELECT movid
	FROM releaselanguages
	WHERE releaselanguages.language = 'French'
) AND movies.movid IN (
	SELECT movid
	FROM releaselanguages
	WHERE releaselanguages.language = 'English'
) AND (
	SELECT COUNT(*)
	FROM review
	WHERE review.movid = movies.movid
) >= 5
ORDER BY releasedate, title;
