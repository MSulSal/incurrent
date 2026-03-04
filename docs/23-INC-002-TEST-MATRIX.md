# INC-002 Test Matrix

Issue: `#3`  
Scope: `POST /counters/{id}/inc` validation and ack contract

## Unit Tests (Gateway Validation Layer)

1. Accept valid payload (`delta=1`, valid UUID)
2. Reject missing `delta`
3. Reject missing `op_id`
4. Reject `delta=0`
5. Reject `delta<0`
6. Reject `delta>10000`
7. Reject non-integer `delta`
8. Reject invalid `op_id` format
9. Reject invalid counter id format

## Web/API Tests (MockMvc)

1. `POST` valid request -> `202` with required response fields
2. Invalid JSON body -> `400`
3. Wrong content type -> `415`
4. Validation failure -> `400` with `error` and `request_id`
5. Rate-limited path -> `429` with error contract

## Contract Schema Tests

1. Validate request sample against `increment-request.schema.json`
2. Validate `202` response against `increment-accepted-response.schema.json`
3. Validate error response against `error-response.schema.json`

## Integration Tests (Testcontainers, Next Step)

1. Accepted request publishes event to `inc_events`
2. Event key equals counter id for partition consistency
3. Published event contains `counter_id`, `delta`, `op_id`, timestamp

## Required Red Tests Before Feature Implementation

1. At least one failing validation test (example: `delta=0`)
2. At least one failing API contract test for response shape
3. Contract schema assertion test wired into test run

## Done Signals

1. All INC-002 tests are green in local run.
2. CI test job passes once Java test workflow is added.
3. Issue comment includes commands and pass/fail evidence.
