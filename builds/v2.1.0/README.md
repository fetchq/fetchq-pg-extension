# FetchQ v2.1.0

- Adds `fetchq_queue_create_indexes(qname)` signature that generate per-queue indexes
  based on informations read from the `sys_queues` table.
- Adds `fetchq_trigger_notify_as_json()` that can be attached to any table to emit a full
  JSON representation of the event (INSERT; UPDATE; DELETE).
- Emits full JSON events for `fetchq_sys_queues` so that the client can subscribe to it and
  honor the queue status.
  