-- FINK Jérôme et SEEL Océane 
-- CreaCB

DROP DATABASE LINK CBB.DBL;
DROP TRIGGER COPIECOTESAVIS;

DROP TABLE PERSONNE_ROLE;
DROP TABLE FILM_COPIE;
DROP TABLE FILM_PRODUCTEUR;
DROP TABLE FILM_GENRE;
DROP TABLE FILM_LANGUE;
DROP TABLE FILM_PAYS;
DROP TABLE EST_REALISATEUR;
DROP TABLE ROLE;
DROP TABLE LANGUE;
DROP TABLE PRODUCTEUR;
DROP TABLE GENRE;
DROP TABLE PAYS;
DROP TABLE EVALUATION;
DROP TABLE UTILISATEUR;
DROP TABLE PERSONNE;
DROP TABLE FILM;
DROP TABLE AFFICHE;

DROP SEQUENCE IDAFFICHE;

CREATE SEQUENCE IDAFFICHE;

-- Les truncates des valeurs trop longues seront traitées dans des procédures d'ajout.
-- La vérification du 9999éme quantile rejeté sera vérifié dans la procédure
-- le troncage d'un nombre modifie drastiquement l'information qu'apporte celui-ci. Cela revient à stocker des information incohérentes j'ai donc décidé de laisser la taille max
-- pour la plupart des nombres stockés

CREATE TABLE AFFICHE
(
	ID 		NUMBER CONSTRAINT PK_AFFICHE_ID PRIMARY KEY,
	IMAGE 	blob default empty_blob()
);

CREATE TABLE FILM
(
	ID				NUMBER CONSTRAINT PK_FILM_ID PRIMARY KEY,
	TITRE			VARCHAR2(58) CONSTRAINT CK_FILM_TITRE CHECK(TITRE IS NOT NULL),  --Si > 9999 film rejeté
	TITRE_ORIGINAL	VARCHAR2(59) CONSTRAINT CK_FILM_ORI_TITRE CHECK(TITRE_ORIGINAL IS NOT NULL), --Si > 9999 film rejeté
	DATE_SORTIE		DATE,
	STATUT			VARCHAR2(15) CONSTRAINT CK_FILM_STATUT CHECK(STATUT IN ('POST PRODUCTION', 'RUMORED', 'RELEASED', 'IN PRODUCTION', 'PLANNED', 'CANCELED')), 
	NOTE_MOYENNE	NUMBER(2,1), --1 decimal
	NOMBRE_NOTE		NUMBER, -- si negatif mis à 0	
	RUNTIME 		NUMBER(5), -- si négatif ou 0 mis à NULL
	CERTIFICATION	VARCHAR2(5), -- Verification des valeurs improbables +  quantille
	AFFICHE			NUMBER CONSTRAINT REF_AFFICHE_FILM_ID REFERENCES AFFICHE(ID), 
	BUDGET			NUMBER(9), -- NULL si trop grand
	REVENU			NUMBER(10), -- NULL si trop grand
	HOMEPAGE		VARCHAR2(122), -- NULL si > 122
	TAGLINE			VARCHAR2(172), --NULL si > 9999 percentile
	OVERVIEW		VARCHAR2(949), --NULL si > 9999 percentile
	NBR_COPIE		NUMBER CONSTRAINT CK_FILM_NBR_COPIE_NULL CHECK(NBR_COPIE IS NOT NULL),
	CONSTRAINT CK_NBR_COPIE_POSITIF CHECK(NBR_COPIE > 0)
);

CREATE TABLE FILM_COPIE
(
	FILM_ID 	NUMBER CONSTRAINT REF_FILM_COPIE_ID REFERENCES FILM (ID),
	NUM_COPIE	NUMBER,
	CONSTRAINT PK_FILM_COPIE  PRIMARY KEY (FILM_ID, NUM_COPIE)
);

CREATE TABLE GENRE
(
	ID 		NUMBER CONSTRAINT PK_GENRE_ID PRIMARY KEY,
	NOM 	VARCHAR2(16) -- tuple rejeté si > 9999
);

CREATE TABLE FILM_GENRE
(
	ID_FILM 	NUMBER CONSTRAINT REF_FILM_GENRE_ID REFERENCES FILM (ID),
	ID_GENRE	NUMBER(5) CONSTRAINT REF_GENRE_ID REFERENCES GENRE(ID),
	CONSTRAINT PK_FILM_GENRE  PRIMARY KEY (ID_FILM, ID_GENRE)
);

CREATE TABLE PRODUCTEUR
(
	ID 		NUMBER CONSTRAINT PK_PRODUCTEUR_ID PRIMARY KEY,
	NOM 	VARCHAR2(45) -- tuple rejeté si > 9999
);

CREATE TABLE FILM_PRODUCTEUR
(
	ID_FILM 		NUMBER CONSTRAINT REF_FILM_PRODUCTEUR_ID REFERENCES FILM (ID),
	ID_PRODUCTEUR	NUMBER CONSTRAINT REF_PRODUCTEUR_ID REFERENCES PRODUCTEUR(ID),
	CONSTRAINT PK_FILM_PRODUCTEUR  PRIMARY KEY (ID_FILM, ID_PRODUCTEUR)
);

CREATE TABLE LANGUE
(
	ID 		VARCHAR2(2) CONSTRAINT PK_LANGUE_ID PRIMARY KEY,
	NOM 	VARCHAR2(15) -- valeur NULL si > 9999 percentile
);

CREATE TABLE FILM_LANGUE
(
	ID_FILM 		NUMBER CONSTRAINT REF_FILM_LANGUE_ID REFERENCES FILM (ID),
	ID_LANGUE		VARCHAR(2) CONSTRAINT REF_LANGUE_ID REFERENCES LANGUE(ID),
	CONSTRAINT PK_FILM_LANGUE  PRIMARY KEY (ID_FILM, ID_LANGUE)
);

CREATE TABLE PAYS
(
	ID 		VARCHAR2(2) CONSTRAINT PK_PAYS_ID PRIMARY KEY,
	NOM 	VARCHAR2(31) -- valeur NULL si > 9999 percentile
);

CREATE TABLE FILM_PAYS
(
	ID_FILM 		NUMBER CONSTRAINT REF_FILM_PAYS_ID REFERENCES FILM (ID),
	ID_PAYS			VARCHAR2(2) CONSTRAINT REF_PAYS_ID REFERENCES PAYS(ID),
	CONSTRAINT PK_FILM_PAYS  PRIMARY KEY (ID_FILM, ID_PAYS)
);

CREATE TABLE PERSONNE
(
	ID 			NUMBER CONSTRAINT PK_PERSONNE_ID PRIMARY KEY,
	NOM 		VARCHAR2(23) CONSTRAINT CK_NOM_PERSONNE_NOTNULL CHECK(NOM IS NOT NULL), -- Si nom trop long tuple rejeté
	PHOTO		VARCHAR2(32) -- valeur NULL si > 32
);


CREATE TABLE EST_REALISATEUR
(
	ID_FILM 		NUMBER CONSTRAINT REF_FILM_REALISATEUR_ID REFERENCES FILM (ID),
	ID_PERSONNE		NUMBER CONSTRAINT REF_REALISATEUR_ID REFERENCES PERSONNE(ID),
	CONSTRAINT PK_FILM_REALISATEUR PRIMARY KEY (ID_FILM, ID_PERSONNE)
);


CREATE TABLE ROLE
(
	ID 				NUMBER,
	FILM_ASSOCIE	NUMBER CONSTRAINT REF_FILM_ROLE_ID REFERENCES FILM (ID),
	NOM 			VARCHAR2(39), -- tuple rejeté si > 9999 percentile
	CONSTRAINT PK_ROLE  PRIMARY KEY (ID, FILM_ASSOCIE)
);

CREATE TABLE PERSONNE_ROLE
(
	ID_PERSONNE		NUMBER CONSTRAINT REF_PERSONNE_ROLE_ID REFERENCES PERSONNE(ID),
	ROLE_FILM		NUMBER,
	ROLE_ID			NUMBER,
	CONSTRAINT PK_ACTEUR_ROLE PRIMARY KEY (ID_PERSONNE, ROLE_FILM, ROLE_ID),
	CONSTRAINT FK_ACTEUR_ROLE FOREIGN KEY(ROLE_FILM, ROLE_ID) REFERENCES ROLE(FILM_ASSOCIE, ID)
);


CREATE TABLE UTILISATEUR
(
	LOGIN		VARCHAR2(10) CONSTRAINT PK_UTILISATEUR_LOGIN PRIMARY KEY,
	PASSWORD	VARCHAR2(10) CONSTRAINT CK_PASSWORD_NOTNULL CHECK (PASSWORD IS NOT NULL),
	TOKEN		VARCHAR2(10) DEFAULT NULL
);


CREATE TABLE EVALUATION
(
	IDFILM		NUMBER CONSTRAINT REF_FILM_ID REFERENCES FILM (ID),
	LOGIN		VARCHAR2(10) CONSTRAINT REF_UTILISATEUR_LOGIN REFERENCES UTILISATEUR (LOGIN),
	COTE		NUMBER,
	AVIS		VARCHAR2(1000),
	DATEEVAL	DATE CONSTRAINT CK_DATEEVAL_NOTNULL CHECK (DATEEVAL IS NOT NULL),
	TOKEN		VARCHAR2(10) DEFAULT NULL,
	CONSTRAINT PK_EVALUATION_IFILM_LOGIN  PRIMARY KEY (IDFILM, LOGIN),
	CONSTRAINT CK_COTEAVIS_NOTNULL CHECK ((COTE IS NOT NULL AND AVIS IS NULL) OR (COTE IS NULL AND AVIS IS NOT NULL) OR (COTE IS NOT NULL AND AVIS IS NOT NULL))
);

CREATE DATABASE LINK CBB.DBL CONNECT TO CBB IDENTIFIED BY CBB USING 'CBB';

-- BEGIN
-- 	INSERT INTO FILM 
-- 	VALUES(6666, 'INCEPTION', 'INCEPTION', to_date('15/06/98', 'DD/MM/RR'), 'RUMORED', 8.3, 1784, 25, 'NR', '/oFWvF7OJfT2ydAAatlnsgChV4FP.jpg', '40000', 
-- 		'80000', 'inception.org', null, null, 2);

-- 	INSERT INTO FILM 
-- 	VALUES(6667, 'INTERSTELLAR', 'INTERSTELLAR', to_date('12/12/12', 'DD/MM/RR'), 'RUMORED', 8.3, 1784, 25, 'NR', '/oFWvF7OJfT2ydAAatlnsgChV4FP.jpg', '40000', 
-- 		'80000', 'inception.org', null, null, 5);

-- 	-- INSERTION DES USERS
-- 	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('JEROME', 'FINK', 'OK');
-- 	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('OCEANE', 'SEEL', 'OK');
-- 	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('AAA', 'AAA', 'OK');
-- 	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('BBB', 'BBB', 'OK');
-- 	INSERT INTO UTILISATEUR (LOGIN, PASSWORD, TOKEN) VALUES ('CCC', 'CCC', 'OK');

-- 	-- INSERTION DES EVALUATION
-- 	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6666, 'JEROME', 5, NULL, to_timestamp('23/09/15 17:24:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
-- 	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6666, 'OCEANE', NULL, 'Film génial', to_timestamp('22/09/15 15:20:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
-- 	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6666, 'AAA', 7, NULL, to_timestamp('21/09/15 18:04:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
-- 	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6667, 'JEROME', 1, 'J''ai détesté ce film', to_timestamp('22/09/15 09:53:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');
-- 	INSERT INTO EVALUATION (IDFILM, LOGIN, COTE, AVIS, DATEEVAL, TOKEN) VALUES (6667, 'OCEANE', 10, NULL, to_timestamp('23/09/15 13:13:00','DD/MM/RR HH24:MI:SSXFF'), 'OK');

-- 	COMMIT;

-- EXCEPTION
-- 	WHEN OTHERS THEN  ROLLBACK; RAISE;
-- END;

EXIT;
