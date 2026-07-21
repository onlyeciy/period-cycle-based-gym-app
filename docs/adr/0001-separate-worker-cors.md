# ADR-0001: Separate Worker with CORS

**Date:** 2026-07-21

## Context
The frontend (Cloudflare Pages) and backend (API) are deployed to different Cloudflare services. Pages and Workers have different subdomains, which means browser CORS rules apply.

We had two options:
- **Option A:** Deploy to separate URLs, add CORS headers to Worker responses
- **Option B:** Use Pages Functions to embed the API in the same deployment as the frontend

## Decision
**Option A** — separate Worker with restricted CORS via env var.

The Worker reads `CORS_ORIGIN` from environment (set via `wrangler secret put CORS_ORIGIN`) and returns:

```
Access-Control-Allow-Origin: https://my-app.pages.dev
```

## Rationale
- Decoupled deploy pipelines — frontend and backend can be updated independently
- CI/CD mirrors real-world team workflows where separate services deploy separately
- Restricted origin signals security awareness (wildcard `*` reads as "didn't consider it")
- Pages Functions (Option B) ties backend logic to the frontend build, making it harder to swap either layer later
- Env var approach keeps the origin configurable across environments (dev/staging/prod) without redeploying
