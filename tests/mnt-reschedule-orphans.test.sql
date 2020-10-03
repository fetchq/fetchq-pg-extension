-- declare test case
CREATE OR REPLACE FUNCTION fetchq_test.fetchq_test__mnt_reschedule_orphans_01(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT WAS NOT POSSIBLE TO RESCHEDULE ORPHANS';
    VAR_r RECORD;
BEGIN
    
    -- initialize test
    PERFORM fetchq_test.fetchq_test_init();
    PERFORM fetchq.queue_create('foo');

    -- insert dummy data & force the date in the past
    PERFORM fetchq.doc_push('foo', 'a1', 0, 0, NOW() - INTERVAL '1 milliseconds', '{}');
    PERFORM fetchq.doc_pick('foo', 0, 1, '5m');
    UPDATE fetchq_data.foo__docs SET next_iteration = NOW() - INTERVAL '1 milliseconds';
    
    PERFORM fetchq.mnt_reschedule_orphans('foo', 100);
    PERFORM fetchq.metric_log_pack();

    -- run the test
    SELECT * INTO VAR_r FROM fetchq.metric_get('foo', 'err');
    IF VAR_r.current_value != 1 THEN
        RAISE EXCEPTION 'failed - %', VAR_testName;
    END IF;



    passed = TRUE;
END; $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fetchq_test.fetchq_test__mnt_reschedule_orphans_02(
    OUT passed BOOLEAN
) AS $$
DECLARE
    VAR_testName VARCHAR = 'IT WAS NOT POSSIBLE TO RESCHEDULE ORPHANS WITH DYNAMIC MAX_ATTEMPTS';
    VAR_r RECORD;
BEGIN
    
    -- initialize test
    PERFORM fetchq_test.fetchq_test_init();
    PERFORM fetchq.queue_create('foo');

    PERFORM fetchq.queue_set_max_attempts('foo', 1);

    -- insert dummy data & force the date in the past
    PERFORM fetchq.doc_push('foo', 'a1', 0, 0, NOW() - INTERVAL '1 milliseconds', '{}');
    PERFORM fetchq.doc_pick('foo', 0, 1, '5m');
    UPDATE fetchq_data.foo__docs SET next_iteration = NOW() - INTERVAL '1 milliseconds';
    
    PERFORM fetchq.mnt_reschedule_orphans('foo', 100);
    PERFORM fetchq.metric_log_pack();

    -- run the test
    SELECT * INTO VAR_r FROM fetchq.metric_get('foo', 'err');
    IF VAR_r.current_value IS NULL THEN
        RAISE EXCEPTION 'failed - %', VAR_testName;
    END IF;
    IF VAR_r.current_value != 0 THEN
        RAISE EXCEPTION 'failed - %', VAR_testName;
    END IF;



    passed = TRUE;
END; $$
LANGUAGE plpgsql;
