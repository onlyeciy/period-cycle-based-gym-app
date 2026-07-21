# ADR-0002: JWT for Session Auth

**Date:** 2026-07-21

## Context
The app needs authentication even though it is single-user. This ensures the design supports multi-user if needed later and follows real-world conventions.

Options considered:
- **No auth** — simplest, but blocks any future multi-user path
- **Single password gate** — one global password, no sessions
- **JWT** — stateless tokens, password stored in DB, login/register flow
- **Database sessions** — stateful tokens stored in a sessions table

## Decision
**JWT** with a `users` table (one row), bcryptjs password hashing (cost factor 12), and KV-based login rate-limiting.

## Rationale
- No database lookup on every request (stateless)
- JWTs can carry claims (token payload) for future features like token versioning
- DB sessions add a table and a query per request for no benefit at this scale
- JWT is industry standard; skills transfer to future projects
- Password stored in DB (not as an env var) allows in-app password changes without redeploying
- bcrypt cost factor 12 balances security vs latency for a single-user app
- KV rate-limiting on login (5 attempts per 15 min per IP) signals abuse-awareness even though the app is single-user
