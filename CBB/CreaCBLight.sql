-- FINK Jérôme et SEEL Océane 
-- CreaCBLight

DROP DATABASE LINK CB.DBL;
DROP TRIGGER COPIECOTESAVIS;
DROP TABLE EVALUATION;
DROP TABLE UTILISATEUR;


CREATE TABLE UTILISATEUR
(
	LOGIN		VARCHAR2(10) CONSTRAINT PK_UTILISATEUR_LOGIN PRIMARY KEY,
	PASSWORD	VARCHAR2(10),
	TOKEN		VARCHAR2(10) DEFAULT NULL
);


CREATE TABLE EVALUATION
(
	IDFILM		NUMBER(10),
	LOGIN		VARCHAR2(10) CONSTRAINT REF_UTILISATEUR_LOGIN REFERENCES UTILISATEUR (LOGIN),
	COTE		NUMBER(2),
	AVIS		VARCHAR2(1000),
	DATEEVAL	DATE CONSTRAINT CK_DATEEVAL_NOTNULL CHECK (DATEEVAL IS NOT NULL),
	TOKEN		VARCHAR2(10) DEFAULT NULL,
	CONSTRAINT PK_EVALUATION_IFILM_LOGIN  PRIMARY KEY (IDFILM, LOGIN),
	CONSTRAINT CK_COTEAVIS_NOTNULL CHECK ((COTE IS NOT NULL AND AVIS IS NULL) OR (COTE IS NULL AND AVIS IS NOT NULL) OR (COTE IS NOT NULL AND AVIS IS NOT NULL))
);





CREATE DATABASE LINK CB.DBL CONNECT TO CB IDENTIFIED BY CB USING 'CB';
