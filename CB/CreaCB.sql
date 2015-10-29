-- FINK Jérôme et SEEL Océane 
-- CreaCB

DROP DATABASE LINK CBB.DBL;
DROP TRIGGER COPIECOTESAVIS;

DROP TABLE FILM_GENRE;
DROP TABLE FILM_PRODUCTEUR;
DROP TABLE FILM_LANGUE;
DROP TABLE FILM_PAYS;
DROP TABLE FILM_REALISATEUR;
DROP TABLE LANGUE;
DROP TABLE PRODUCTEUR;
DROP TABLE GENRE;
DROP TABLE PAYS;
DROP TABLE REALISATEUR;
DROP TABLE EVALUATION;
DROP TABLE FILM;
DROP TABLE UTILISATEUR;

CREATE TABLE FILM
(
	ID				NUMBER(6) CONSTRAINT PK_FILM_ID PRIMARY KEY,
	TITRE			VARCHAR2(58) CONSTRAINT CK_FILM_TITRE CHECK(TITRE IS NOT NULL),
	TITRE_ORIGINAL	VARCHAR2(59) CONSTRAINT CK_FILM_ORI_TITRE CHECK(TITRE_ORIGINAL IS NOT NULL),
	DATE_SORTIE		DATE,
	STATUS			VARCHAR2(15) CONSTRAINT CK_FILM_STATUS CHECK(STATUS IN ('POST PRODUCTION', 'RUMORED', 'RELEASED', 'IN PRODUCTION', 'PLANNED', 'CANCELED')),
	NOTE_MOYENNE	NUMBER(2,1),
	NOMBRE_NOTE		NUMBER,	--Rapport non respecté : pas de plafond sur nbr de notes.
	RUNTIME 		NUMBER(3), 
	CERTIFICATION	VARCHAR2(5),
	LIEN_POSTER		VARCHAR2(32), 
	BUDGET			NUMBER(8), 
	REVENU			NUMBER(8), 
	HOMEPAGE		VARCHAR2(122), 
	TAGLINE			VARCHAR2(172),
	OVERVIEW		VARCHAR2(949)
);

CREATE TABLE GENRE
(
	ID 		NUMBER(5) CONSTRAINT PK_GENRE_ID PRIMARY KEY,
	NOM 	VARCHAR2(16)
);

CREATE TABLE FILM_GENRE
(
	ID_FILM 	NUMBER(6) CONSTRAINT REF_FILM_GENRE_ID REFERENCES FILM (ID),
	ID_GENRE	NUMBER(5) CONSTRAINT REF_GENRE_ID REFERENCES GENRE(ID),
	CONSTRAINT PK_FILM_GENRE  PRIMARY KEY (ID_FILM, ID_GENRE)
);

CREATE TABLE PRODUCTEUR
(
	ID 		NUMBER(5) CONSTRAINT PK_PRODUCTEUR_ID PRIMARY KEY,
	NOM 	VARCHAR2(45)
);

CREATE TABLE FILM_PRODUCTEUR
(
	ID_FILM 		NUMBER(6) CONSTRAINT REF_FILM_PRODUCTEUR_ID REFERENCES FILM (ID),
	ID_PRODUCTEUR	NUMBER(5) CONSTRAINT REF_PRODUCTEUR_ID REFERENCES PRODUCTEUR(ID),
	CONSTRAINT PK_FILM_PRODUCTEUR  PRIMARY KEY (ID_FILM, ID_PRODUCTEUR)
);

CREATE TABLE LANGUE
(
	ID 		VARCHAR2(2) CONSTRAINT PK_LANGUE_ID PRIMARY KEY,
	NOM 	VARCHAR2(15)
);

CREATE TABLE FILM_LANGUE
(
	ID_FILM 		NUMBER(6) CONSTRAINT REF_FILM_LANGUE_ID REFERENCES FILM (ID),
	ID_LANGUE		VARCHAR(2) CONSTRAINT REF_LANGUE_ID REFERENCES LANGUE(ID),
	CONSTRAINT PK_FILM_LANGUE  PRIMARY KEY (ID_FILM, ID_LANGUE)
);

CREATE TABLE PAYS
(
	ID 		NUMBER(2) CONSTRAINT PK_PAYS_ID PRIMARY KEY,
	NOM 	VARCHAR2(31)
);

CREATE TABLE FILM_PAYS
(
	ID_FILM 		NUMBER(6) CONSTRAINT REF_FILM_PAYS_ID REFERENCES FILM (ID),
	ID_PAYS			NUMBER(2) CONSTRAINT REF_PAYS_ID REFERENCES PAYS(ID),
	CONSTRAINT PK_FILM_PAYS  PRIMARY KEY (ID_FILM, ID_PAYS)
);

CREATE TABLE REALISATEUR
(
	ID 		NUMBER(7) CONSTRAINT PK_REALISATEUR_ID PRIMARY KEY,
	NOM 	VARCHAR2(23) CONSTRAINT CK_NOM_NOTNULL CHECK(NOM IS NOT NULL),
	PHOTO	VARCHAR2(32)
);

CREATE TABLE FILM_REALISATEUR
(
	ID_FILM 		NUMBER(6) CONSTRAINT REF_FILM_REALISATEUR_ID REFERENCES FILM (ID),
	ID_REALISATEUR	NUMBER(7) CONSTRAINT REF_REALISATEUR_ID REFERENCES REALISATEUR(ID),
	CONSTRAINT PK_FILM_REALISATEUR  PRIMARY KEY (ID_FILM, ID_REALISATEUR)
);


CREATE TABLE UTILISATEUR
(
	LOGIN		VARCHAR2(10) CONSTRAINT PK_UTILISATEUR_LOGIN PRIMARY KEY,
	PASSWORD	VARCHAR2(10) CONSTRAINT CK_PASSWORD_NOTNULL CHECK (PASSWORD IS NOT NULL),
	TOKEN		VARCHAR2(10) DEFAULT NULL
);


CREATE TABLE EVALUATION
(
	IDFILM		NUMBER(6) CONSTRAINT REF_FILM_ID REFERENCES FILM (ID),
	LOGIN		VARCHAR2(10) CONSTRAINT REF_UTILISATEUR_LOGIN REFERENCES UTILISATEUR (LOGIN),
	COTE		NUMBER(2),
	AVIS		VARCHAR2(1000),
	DATEEVAL	DATE CONSTRAINT CK_DATEEVAL_NOTNULL CHECK (DATEEVAL IS NOT NULL),
	TOKEN		VARCHAR2(10) DEFAULT NULL,
	CONSTRAINT PK_EVALUATION_IFILM_LOGIN  PRIMARY KEY (IDFILM, LOGIN),
	CONSTRAINT CK_COTEAVIS_NOTNULL CHECK ((COTE IS NOT NULL AND AVIS IS NULL) OR (COTE IS NULL AND AVIS IS NOT NULL) OR (COTE IS NOT NULL AND AVIS IS NOT NULL))
);



CREATE DATABASE LINK CBB.DBL CONNECT TO CBB IDENTIFIED BY CBB USING 'CBB';

BEGIN
	INSERT INTO FILM 
	VALUES(6666, 'INCEPTION', 'INCEPTION', to_date('03-OCT-88', 'DD-MON-YY'), 'RUMORED', 8.3, 1784, 25, 'NR', '/oFWvF7OJfT2ydAAatlnsgChV4FP.jpg', '40000', 
		'80000', 'inception.org', null, null);

	INSERT INTO FILM 
	VALUES(6667, 'INTERSTELLAR', 'INTERSTELLAR', to_date('03-OCT-88', 'DD-MON-YY'), 'RUMORED', 8.3, 1784, 25, 'NR', '/oFWvF7OJfT2ydAAatlnsgChV4FP.jpg', '40000', 
		'80000', 'inception.org', null, null);

	-- INSERTION DES USERS
	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('JEROME', 'FINK', 'OK');
	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('OCEANE', 'SEEL', 'OK');
	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('AAA', 'AAA', 'OK');
	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('BBB', 'BBB', 'OK');
	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('CCC', 'CCC', 'OK');

	-- INSERTION DES EVALUATION
	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6666, 'JEROME', 5, NULL, to_timestamp('23/09/15 17:24:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6666, 'OCEANE', NULL, 'Film génial', to_timestamp('22/09/15 15:20:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6666, 'AAA', 7, NULL, to_timestamp('21/09/15 18:04:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6667, 'JEROME', 1, 'J''ai détesté ce film', to_timestamp('22/09/15 09:53:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6667, 'OCEANE', 10, NULL, to_timestamp('23/09/15 13:13:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN  ROLLBACK; RAISE;
END;

EXIT;
