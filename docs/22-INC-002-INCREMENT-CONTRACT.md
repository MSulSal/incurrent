# INC-002 Increment API Contract

Issue: `#3`  
Endpoint: `POST /counters/{id}/inc`

## Purpose

Accept increment operations into the event pipeline with strict request
validation and asynchronous acknowledgement.

## Path Parameters

1. `id` (required)
   - Type: string
   - Pattern: `^[A-Za-z0-9:_-]{1,128}$`
   - Example: `counter:123`

## Request Body

Content type: `application/json`

Fields:

1. `delta` (required)
   - Type: integer
   - Range: `1..10000` (MVP bound)
2. `op_id` (required)
   - Type: string
   - Format: UUID (`v4` or `v7`)

Example:

```json
{
  "delta": 1,
  "op_id": "018f72e8-6a16-7c4d-91e4-6bc2dcf4c5f1"
}
```

## Success Response

Status: `202 Accepted`

Body fields:

1. `status`: `"accepted"`
2. `counter_id`: normalized counter id
3. `op_id`: echoed operation id
4. `accepted_at_ms`: server epoch milliseconds
5. `request_id`: request correlation id

Example:

```json
{
  "status": "accepted",
  "counter_id": "counter:123",
  "op_id": "018f72e8-6a16-7c4d-91e4-6bc2dcf4c5f1",
  "accepted_at_ms": 1760000002500,
  "request_id": "4c06ae17-4d07-4f3b-9aa4-84a050d4cf78"
}
```

## Error Responses

1. `400 Bad Request`
   - Invalid JSON syntax
   - Missing required fields
   - Invalid `id` format
   - `delta` out of allowed range
   - Invalid `op_id` format
2. `415 Unsupported Media Type`
   - Non-JSON content type
3. `429 Too Many Requests`
   - Ingress throttling or active load shedding

Error body contract:

```json
{
  "error": "validation_error",
  "message": "delta must be between 1 and 10000",
  "request_id": "4c06ae17-4d07-4f3b-9aa4-84a050d4cf78"
}
```

## Semantics

1. Endpoint is asynchronous by default (`202` does not imply flush to Redis).
2. Idempotent effect is guaranteed downstream by `op_id` dedupe policy.
3. Gateway may accept duplicate `op_id`; worker path enforces dedupe effect.

## Acceptance Criteria

1. Valid request returns `202` with schema-compliant response.
2. Invalid payloads fail with precise `400` validation messages.
3. `request_id` is present in success and error responses.
4. Contract matches JSON schema files in `specs/json/`.
