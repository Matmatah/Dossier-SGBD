CREATE DATABASE LINK CBB CONNECT TO CBB IDENTIFIED BY CBB USING 'LINK.DBL';


CREATE OR REPLACE TRIGGER COPIECOTESAVIS
BEFORE UPDATE ON EVALUATION
FOR EACH ROW
BEGIN
	IF :NEW.TOKEN IS NULL THEN :NEW.TOKEN := 'TRANSFERT';
		UPDATE EVALUATION@LINK.DBL
		SET	IDFILM = :NEW.IDFILM,
			LOGIN = :NEW.LOGIN,
			COTE = :NEW.COTE,
			AVIS = :NEW.AVIS,
			DATEEVAL = :NEW.DATEEVAL;

	END IF;

	:NEW.TOKEN := NULL;
END;
/
