-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.
CREATE TABLE HEALTHINSTITUTION
(
  email varchar(128) NOT NULL,
  address varchar(128),
  phonenum varchar(128),
  name varchar(128),
  website varchar(128),
  PRIMARY KEY (email)
);

CREATE TABLE CLINIC
(
  email varchar(128) NOT NULL,
  PRIMARY KEY (email),
  FOREIGN KEY (email) REFERENCES HEALTHINSTITUTION(email)
);

CREATE TABLE BIRTHINGCENTER
(
  email varchar(128) NOT NULL,
  PRIMARY KEY (email),
  FOREIGN KEY (email) REFERENCES HEALTHINSTITUTION(email)
);

CREATE TABLE MIDWIFE
(
  practitionerID int NOT NULL,
  hemail varchar(128) NOT NULL,
  phonenum varchar(128),
  name varchar(128),
  email varchar(128),
  PRIMARY KEY (practitionerID),
  FOREIGN KEY (hemail) REFERENCES HEALTHINSTITUTION(email)
);

CREATE TABLE MOTHER
(
  ramqID varchar(128) NOT NULL,
  bloodtype varchar(16),
  phonenum varchar(128),
  profession varchar(128),
  email varchar(128),
  birthday DATE,
  address varchar(128),
  name varchar(128),
  PRIMARY KEY (ramqID)
);

CREATE TABLE FATHER
(
  ramqID varchar(128) NOT NULL,
  bloodtype varchar(16),
  phonenum varchar(128),
  profession varchar(128),
  email varchar(128),
  birthday DATE,
  address varchar(128),
  name varchar(128),
  PRIMARY KEY (ramqID)
);

CREATE TABLE COUPLE
(
  coupleID int NOT NULL,
  motherramqID varchar(128) NOT NULL,
  PRIMARY KEY (coupleID),
  FOREIGN KEY (motherramqID) REFERENCES MOTHER(ramqID)
);

CREATE TABLE COUPLEMOTHER
(
  ramqID varchar(128) NOT NULL,
  coupleID int NOT NULL,
  PRIMARY KEY (ramqID, coupleID),
  FOREIGN KEY (ramqID) REFERENCES MOTHER(ramqID),
  FOREIGN KEY (coupleID) REFERENCES COUPLE(coupleID)
);

CREATE TABLE COUPLEFATHER
(
  ramqID varchar(128) NOT NULL,
  coupleID int NOT NULL,
  PRIMARY KEY (ramqID, coupleID),
  FOREIGN KEY (ramqID) REFERENCES FATHER(ramqID),
  FOREIGN KEY (coupleID) REFERENCES COUPLE(coupleID)
);

CREATE TABLE PREGNANCY
(
  pregnancyID int NOT NULL,
  coupleID int NOT NULL,
  midwifeID int NOT NULL,
  lastmenperiodd DATE,
  ultrasounddd DATE,
  bcemail varchar(128),
  birthloc varchar(128),
  expecteddd DATE,
  PRIMARY KEY (pregnancyID),
  FOREIGN KEY (coupleID) REFERENCES COUPLE(coupleID),
  FOREIGN KEY (midwifeID) REFERENCES MIDWIFE(practitionerID),
  FOREIGN KEY (bcemail) REFERENCES BIRTHINGCENTER(email)
);

CREATE TABLE ONLINEINFOSESSION
(
  sessionID int NOT NULL,
  midwifeID int NOT NULL,
  language varchar(128),
  sessiontime DATETIME,
  PRIMARY KEY (sessionID),
  FOREIGN KEY (midwifeID) REFERENCES MIDWIFE(practitionerID)
);

CREATE TABLE MAINMIDWIFE
(
  pregnancyID int NOT NULL,
  midwifeID int NOT NULL,
  FOREIGN KEY (pregnancyID) REFERENCES PREGNANCY(pregnancyID),
  FOREIGN KEY (midwifeID) REFERENCES MIDWIFE(practitionerID)
);

CREATE TABLE BACKUPMIDWIFE
(
  pregnancyID int NOT NULL,
  midwifeID int NOT NULL,
  FOREIGN KEY (pregnancyID) REFERENCES PREGNANCY(pregnancyID),
  FOREIGN KEY (midwifeID) REFERENCES MIDWIFE(practitionerID)
);

CREATE TABLE INFOSESSIONATTENDANCE
(
  coupleID int NOT NULL,
  sessionID int NOT NULL,
  FOREIGN KEY (coupleID) REFERENCES COUPLE(coupleID),
  FOREIGN KEY (sessionID) REFERENCES ONLINEINFOSESSION(sessionID)
);

CREATE TABLE APPOINTMENT
(
  appointmentID int NOT NULL,
  midwifeID int NOT NULL,
  pregnancyID int NOT NULL,
  appointmenttime DATETIME,
  PRIMARY KEY (appointmentID),
  FOREIGN KEY (midwifeID) REFERENCES MIDWIFE(practitionerID),
  FOREIGN KEY (pregnancyID) REFERENCES PREGNANCY(pregnancyID)
);

CREATE TABLE OBSERVATIONNOTE
(
  noteID int NOT NULL,
  appointmentID int NOT NULL,
  notetime DATETIME,
  PRIMARY KEY (noteID),
  FOREIGN KEY (appointmentID) REFERENCES APPOINTMENT(appointmentID)
);

CREATE TABLE MEDICALTEST
(
  testID int NOT NULL,
  appointmentID int NOT NULL,
  forbaby boolean NOT NULL,
  individualID int NOT NULL,
  prescribeddate DATE,
  sampleddate DATE,
  location varchar(128),
  labdate DATE,
  testresult varchar(128),
  testtype varchar(128),
  PRIMARY KEY (testID),
  FOREIGN KEY (appointmentID) REFERENCES APPOINTMENT(appointmentID)
);

CREATE TABLE TECHNICIAN
(
  techID int NOT NULL,
  name varchar(128),
  phonenum varchar(128),
  PRIMARY KEY (techID)
);

CREATE TABLE TECHINCHARGE
(
  techID int NOT NULL,
  testID int NOT NULL,
  FOREIGN KEY (techID) REFERENCES TECHNICIAN(techID),
  FOREIGN KEY (testID) REFERENCES MEDICALTEST(testID)
);

CREATE TABLE BABY
(
  babyID int NOT NULL,
  pregnancyID int NOT NULL,
  gender varchar(128),
  bloodtype varchar(8),
  birthday DATE,
  name varchar(128),
  PRIMARY KEY (babyID),
  FOREIGN KEY (pregnancyID) REFERENCES PREGNANCY(pregnancyID)
);
