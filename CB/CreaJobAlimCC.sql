BEGIN
	DBMS_SCHEDULER.CREATE_JOB
	(
		JOB_NAME => 'JOB_ALIMCC',
		JOB_TYPE => 'STORED_PROCEDURE',
		JOB_ACTION => 'ALIMCC.JOB',
		START_DATE => SYSTIMESTAMP,
		REPEAT_INTERVAL => 'FREQ=WEEKLY;BYHOUR=0;BYMINUTE=0;BYSECOND=0;',
		ENABLED => TRUE,
		COMMENTS => 'Alimentation hebdomadaire des salles de cinémas'
	);

EXCEPTION
	WHEN OTHERS THEN LOGEVENT('CB : CREATE JOB_BACKUP', 'Job non créé => ' || SQLCODE || ' : ' || SQLERRM); RAISE;

END;
/

COMMIT;
