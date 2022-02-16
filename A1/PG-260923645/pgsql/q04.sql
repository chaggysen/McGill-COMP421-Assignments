SELECT m.title, m.releasedate, r.rating
FROM movies m, review r
WHERE r.userid = (
	SELECT userid
	FROM users
	WHERE users.email = 'talkiesdude@movieinfo.com'
) AND m.movid = r.movid
ORDER BY r.rating DESC, m.releasedate, m.title;
