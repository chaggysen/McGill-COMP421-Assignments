CONNECT TO cs421;

ALTER TABLE MEDICALTEST
ADD CHECK (MEDICALTEST.labdate >= MEDICALTEST.prescribeddate); 
