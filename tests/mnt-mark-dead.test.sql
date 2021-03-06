
CREATE OR REPLACE FUNCTION fetchq_test.mnt_mark_dead_01(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT WAS NOT POSSIBLE TO MARK AS DEAD';
    VAR_r RECORD;
BEGIN
    
    -- initialize test

    PERFORM fetchq.queue_create('foo');

    -- insert dummy data & force the date in the past
    PERFORM fetchq.doc_push('foo', 'a1', 0, 0, NOW() - INTERVAL '1 milliseconds', '{}');
    PERFORM fetchq.doc_pick('foo', 0, 1, '5m');
    UPDATE fetchq_data.foo__docs SET attempts = 5, next_iteration = NOW() - INTERVAL '1 milliseconds';
    
    PERFORM fetchq.mnt_mark_dead('foo', 100);
    PERFORM fetchq.metric_log_pack();

    -- run the test
    SELECT * INTO VAR_r FROM fetchq.metric_get('foo', 'kll');
    IF VAR_r.current_value != 1 THEN
        RAISE EXCEPTION 'failed - %', VAR_testName;
    END IF;



    passed = TRUE;
END; $$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fetchq_test.mnt_mark_dead_02(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT WAS NOT POSSIBLE TO MARK AS DEAD WITH DYNAMIC MAX ATTEMPTS';
    VAR_r RECORD;
BEGIN
    
    -- initialize test

    PERFORM fetchq.queue_create('foo');

    PERFORM fetchq.queue_set_max_attempts('foo', 1);

    -- insert dummy data & force the date in the past
    PERFORM fetchq.doc_push('foo', 'a1', 0, 0, NOW() - INTERVAL '1 milliseconds', '{}');
    PERFORM fetchq.doc_pick('foo', 0, 1, '5m');
    UPDATE fetchq_data.foo__docs SET next_iteration = NOW() - INTERVAL '1 milliseconds';
    
    PERFORM fetchq.mnt_mark_dead('foo', 100);
    PERFORM fetchq.metric_log_pack();

    -- run the test
    SELECT * INTO VAR_r FROM fetchq.metric_get('foo', 'kll');
    IF VAR_r.current_value != 1 THEN
        RAISE EXCEPTION 'failed - %', VAR_testName;
    END IF;



    passed = TRUE;
END; $$
LANGUAGE plpgsql;
