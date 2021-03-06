-- declare test case
CREATE OR REPLACE FUNCTION fetchq_test.queue_drop_logs_01(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT SHOULD DROP ERRORS AFTER A GIVEN RETENTION STRING';
    VAR_r RECORD;
BEGIN
    
    -- initialize test

    PERFORM fetchq.queue_create('foo');

    INSERT INTO fetchq_data.foo__logs( created_at, subject, message ) VALUES
   ( NOW(), 'a', 'b' ),
   ( NOW() - INTERVAL '1d', 'a', 'b' ),
   ( NOW() - INTERVAL '2d', 'a', 'b' );

    SELECT * INTO VAR_r FROM fetchq.queue_drop_logs('foo', '24 hours');
    IF VAR_r.affected_rows IS NULL THEN
        RAISE EXCEPTION 'failed -(null value) %', VAR_testName;
    END IF;
    IF VAR_r.affected_rows != 1 THEN
        RAISE EXCEPTION 'failed -(expected: 1, got: %) %', VAR_r.affected_rows, VAR_testName;
    END IF;


    passed = TRUE;
END; $$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fetchq_test.queue_drop_logs_02(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT SHOULD DROP ERRORS AFTER A RETENTION DATE';
    VAR_r RECORD;
BEGIN
    
    -- initialize test

    PERFORM fetchq.queue_create('foo');

    INSERT INTO fetchq_data.foo__logs( created_at, subject, message ) VALUES
   ( NOW(), 'a', 'b' ),
   ( NOW() - INTERVAL '1d', 'a', 'b' ),
   ( NOW() - INTERVAL '2d', 'a', 'b' );

    SELECT * INTO VAR_r FROM fetchq.queue_drop_logs('foo', NOW() - INTERVAL '24h');
    IF VAR_r.affected_rows IS NULL THEN
        RAISE EXCEPTION 'failed -(null value) %', VAR_testName;
    END IF;
    IF VAR_r.affected_rows != 1 THEN
        RAISE EXCEPTION 'failed -(expected: 1, got: %) %', VAR_r.affected_rows, VAR_testName;
    END IF;


    passed = TRUE;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fetchq_test.queue_drop_logs_03(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT SHOULD DROP ERRORS USING THE QUEUE SETTINGS';
    VAR_r RECORD;
BEGIN
    
    -- initialize test

    PERFORM fetchq.queue_create('foo');
    PERFORM fetchq.queue_set_logs_retention('foo', '1h');

    INSERT INTO fetchq_data.foo__logs( created_at, subject, message ) VALUES
   ( NOW(), 'a', 'b' ),
   ( NOW() - INTERVAL '1d', 'a', 'b' ),
   ( NOW() - INTERVAL '2d', 'a', 'b' );

    SELECT * INTO VAR_r FROM fetchq.queue_drop_logs('foo');
    IF VAR_r.affected_rows IS NULL THEN
        RAISE EXCEPTION 'failed -(null value) %', VAR_testName;
    END IF;
    IF VAR_r.affected_rows != 2 THEN
        RAISE EXCEPTION 'failed -(expected: 2, got: %) %', VAR_r.affected_rows, VAR_testName;
    END IF;


    passed = TRUE;
END; $$
LANGUAGE plpgsql;
