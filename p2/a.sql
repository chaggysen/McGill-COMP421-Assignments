CONNECT to cs421;

SELECT a.appointmenttime, m.ramqID, m.name, m.phonenum
FROM APPOINTMENT a, MOTHER m
WHERE a.appointmenttime >= '2022-03-21 00:00:00' AND a.appointmenttime < '2022-03-26 00:00:00' AND
a.midwifeID = (SELECT practitionerID FROM MIDWIFE WHERE MIDWIFE.name = 'Marion Girard') AND
m.ramqID = (SELECT motherramqID FROM COUPLE WHERE coupleID = (SELECT coupleID FROM PREGNANCY WHERE pregnancyID = (a.pregnancyID)));
