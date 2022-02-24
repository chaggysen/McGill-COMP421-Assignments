
SELECT m.ramqID, m.name, m.phonenum
FROM MOTHER m, COUPLE c, PREGNANCY pg
WHERE m.ramqID = c.motherramqID AND c.coupleID = pg.coupleID
AND pg.MIDWIFEid = (SELECT practitionerID FROM MIDWIFE WHERE MIDWIFE.name = 'Lac-Saint-Louis')
AND pg.expecteddd > '2022-02-21';
