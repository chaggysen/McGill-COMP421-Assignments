-- Include your drop table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the drop table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been dropped (reverse of the creation order).

-- This is only an example of how you add drop table ddls to this file.
--   You may remove it.
DROP TABLE BIRTHINGCENTER;
DROP TABLE CLINIC;
DROP TABLE HEALTHINSTITUTION;
DROP TABLE MIDWIFE;
DROP TABLE MOTHER;
DROP TABLE FATHER;
DROP TABLE COUPLE;
DROP TABLE COUPLEMOTHER;
DROP TABLE COUPLEFATHER;
DROP TABLE PREGNANCY;
DROP TABLE ONLINEINFOSESSION;
DROP TABLE MAINMIDWIFE;
DROP TABLE BACKUPMIDWIFE;
DROP TABLE INFOSESSIONATTENDANCE;
DROP TABLE APPOINTMENT;
DROP TABLE OBSERVATIONNOTE;
DROP TABLE MEDICALTEST;
DROP TABLE TECHNICIAN;
DROP TABLE TECHINCHARGE;
DROP TABLE BABY;
