SELECT title, releasedate
FROM movies
WHERE releasedate >= '2021-01-01' 
AND releasedate <= '2022-01-01'
AND movies.movid IN (
	SELECT movid
	FROM moviegenres
	WHERE moviegenres.genre = 'Comedy'
) AND movies.movid IN(
	SELECT movid
	FROM moviegenres
	WHERE moviegenres.genre = 'Sci-Fi'
)
ORDER BY movies.releasedate, movies.title;
