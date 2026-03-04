# Multi-Language Strategy

This project intentionally uses more than one language. This document defines
why and how to prevent a polyglot setup from becoming chaotic.

## Language Roles

1. Java 21
   - Core services and domain behavior.
   - API contracts, worker processing, and integration tests.
2. Bash
   - Repository automation and operational helper scripts.
3. Python (narrow support role)
   - Data parsing helpers inside Bash scripts when JSON handling is needed.

## Governance Rules

1. No feature is split across languages without explicit reason.
2. Core business logic stays in Java services.
3. Bash scripts orchestrate tasks; they do not encode domain behavior.
4. Python helpers must stay small and embedded unless they justify dedicated
   scripts.
5. Every new language dependency must be justified in `docs/10-DECISION-LOG.md`.

## Decision Matrix

Use this matrix when deciding where code should live:

1. Is it domain behavior?
   - Use Java.
2. Is it workflow automation (CI/bootstrap/release)?
   - Use Bash.
3. Is it complex structured parsing in script context?
   - Use small Python helper, called from Bash.

## Anti-Patterns

1. Re-implementing service logic in scripts.
2. Writing one-off tools in a new language for minor convenience.
3. Splitting one codepath into multiple languages without a clear boundary.
4. Introducing opaque build chains for small helper tasks.

## Growth Benefits

1. Java depth in production service architecture.
2. Bash competence for CI and operational automation.
3. Pragmatic Python usage for utility parsing.
4. Stronger judgment around tooling boundaries and maintainability.

## Exit Strategy

If script complexity grows:

1. Promote repeated helper logic into versioned Java/Python utilities.
2. Keep interfaces stable and documented.
3. Remove duplicated logic from ad hoc scripts.
