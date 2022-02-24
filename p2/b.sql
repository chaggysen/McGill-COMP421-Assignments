SELECT labdate, testresult
FROM MEDICALTEST
WHERE forbaby = false AND individualID = (SELECT coupleID FROM COUPLE WHERE motherramqID = (SELECT ramqID FROM MOTHER WHERE name = 'Victoria Gutierrez'))
AND appointmentID = (SELECT appointmentID FROM APPOINTMENT WHERE pregnancyID = (SELECT pregnancyID FROM PREGNANCY WHERE coupleID = individualID ORDER BY expecteddd DESC LIMIT 1,2));
