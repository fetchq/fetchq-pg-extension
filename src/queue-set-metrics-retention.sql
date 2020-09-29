
DROP FUNCTION IF EXISTS fetchq_catalog.fetchq_queue_set_metrics_retention(CHARACTER VARYING, CHARACTER VARYING);
CREATE OR REPLACE FUNCTION fetchq_catalog.fetchq_queue_set_metrics_retention(
	PAR_queue VARCHAR,
	PAR_retention VARCHAR,
	OUT affected_rows INTEGER
) AS $$
DECLARE
	VAR_q VARCHAR;
BEGIN
	-- initial values
	affected_rows = 0;

	-- change value in the table
	VAR_q = '';
	VAR_q = VAR_q || 'UPDATE __fetchq_queues ';
	VAR_q = VAR_q || 'SET metrics_retention = ''%s''  ';
	VAR_q = VAR_q || 'WHERE name = ''%s''';
	VAR_q = FORMAT(VAR_q, PAR_retention, PAR_queue);
	EXECUTE VAR_q;
	GET DIAGNOSTICS affected_rows := ROW_COUNT;

	EXCEPTION WHEN OTHERS THEN BEGIN
		affected_rows = 0;
	END;
END; $$
LANGUAGE plpgsql;
