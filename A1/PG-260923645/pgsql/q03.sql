SELECT userid
FROM review
WHERE review.movid = (
	SELECT movid
	FROM movies
	WHERE movies.title = 'Ben-Hur' AND movies.releasedate = '1959-11-18' 
) AND review.rating >= 7 AND review.userid NOT IN
(
        SELECT userid
        FROM review
        WHERE review.movid = (
                SELECT movid
                FROM movies
                WHERE movies.title = 'Ben-Hur' AND movies.releasedate = '2016-08-19'
        ) AND review.rating > 4
) ORDER BY review.userid;


