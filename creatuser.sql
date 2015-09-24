
DROP USER cb CASCADE;
DROP USER cbb CASCADE;


CREATE ROLE CBROLE NOT IDENTIFIED;
GRANT ALTER SESSION TO CBROLE;
GRANT CREATE DATABASE LINK TO CBROLE;
GRANT CREATE SESSION TO CBROLE;
GRANT CREATE PROCEDURE TO CBROLE;
GRANT CREATE SEQUENCE TO CBROLE;
GRANT CREATE TABLE TO CBROLE;
GRANT CREATE TRIGGER TO CBROLE;
GRANT CREATE TYPE TO CBROLE;
GRANT CREATE SYNONYM TO CBROLE;
GRANT CREATE VIEW TO CBROLE;
GRANT CREATE JOB TO CBROLE;
GRANT CREATE MATERIALIZED VIEW TO CBROLE;
GRANT EXECUTE ON SYS.DBMS_LOCK TO CBROLE;
GRANT EXECUTE ON SYS.OWA_OPT_LOCK TO CBROLE;


CREATE USER CB IDENTIFIED BY CB DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER CB QUOTA UNLIMITED ON USERS;
GRANT CBROLE TO CB;

CREATE USER CBB IDENTIFIED BY CBB DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
ALTER USER CBB QUOTA UNLIMITED ON USERS;
GRANT CBROLE TO CBB;
