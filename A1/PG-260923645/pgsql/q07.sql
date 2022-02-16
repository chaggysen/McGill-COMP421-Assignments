SELECT m.title, m.releasedate, rl.language
FROM movies m, releaselanguages rl
WHERE m.movid IN (
	SELECT movid
	FROM releaselanguages
	WHERE releaselanguages.language = 'French' OR releaselanguages.language = 'Italian'
) AND m.movid = rl.movid
