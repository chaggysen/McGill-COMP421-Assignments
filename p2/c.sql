CONNECT to cs421;

SELECT HEALTHINSTITUTION.name, (SELECT COUNT(*)  FROM PREGNANCY pg, MIDWIFE mw WHERE pg.midwifeID = mw.practitionerID
AND mw.hemail = HEALTHINSTITUTION.email AND pg.expecteddd >= '2022-07-01' AND pg.expecteddd <= '2022-07-31')
AS pregnancynum FROM HEALTHINSTITUTION;
