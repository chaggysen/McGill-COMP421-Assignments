SELECT t.genre FROM (SELECT genre, AVG(gr.rating) AS avgrating
FROM moviegenres
INNER JOIN (
	SELECT * FROM review WHERE review.userid = (SELECT userid FROM users WHERE users.email = 'cinebuff@movieinfo.com')
) gr ON moviegenres.movid = gr.movid
GROUP BY genre
ORDER BY avgrating DESC, genre) AS t WHERE t.avgrating = (SELECT MAX(x.avgrating) FROM (SELECT genre, AVG(gr.rating) AS avgrating
FROM moviegenres
INNER JOIN (
        SELECT * FROM review WHERE review.userid = (SELECT userid FROM users WHERE users.email = 'cinebuff@movieinfo.com')
) gr ON moviegenres.movid = gr.movid
GROUP BY genre
ORDER BY avgrating DESC, genre) AS x);
