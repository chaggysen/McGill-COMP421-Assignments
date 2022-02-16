SELECT COUNT(movid) AS nummovies
FROM moviegenres
WHERE moviegenres.genre = 'Comedy' AND moviegenres.movid IN (
	SELECT movid
	FROM movies
	WHERE releasedate >= '2021-01-01' AND releasedate <= '2021-12-31'
)
