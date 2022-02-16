SELECT title, releasedate
FROM movies
WHERE movies.movid IN (
	SELECT movid
	FROM releaselanguages
	WHERE releaselanguages.language = 'French'
) AND movies.movid NOT IN (
	SELECT movid
	FROM releaselanguages
	WHERE releaselanguages.language = 'English'
)
ORDER BY releasedate, title
