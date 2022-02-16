SELECT rl.language, mg.genre
FROM releaselanguages rl, moviegenres mg
WHERE rl.movid = mg.movid AND mg.genre IN (
	SELECT 
)

SELECT rl.language,COUNT(mg.genre)
FROM releaselanguages rl
LEFT JOIN(
	SELECT * FROM moviegenres
) mg ON rl.movid = mg.movid
GROUP BY rl.language;
