# Architecture Design — Personal Gym + Cycle Coach

## Stack
- **Frontend:** React + Tailwind CSS + React Router + React Query
- **Backend:** Cloudflare Workers (TypeScript)
- **Database:** Cloudflare D1 (SQLite)
- **Auth:** JWT (bcryptjs cost 12), KV login rate-limiting (5/15min per IP)
- **Hosting:** Cloudflare Pages (frontend) + Cloudflare Workers (backend)
- **Build:** Vite (frontend) + wrangler (backend) + Turborepo (monorepo orchestration)
- **Test:** Vitest (unit + integration + auth-flow)

## Architecture Pattern
**Option A** — separate deployables, restricted CORS via env var.

## Project Structure
```
/
├── packages/
│   └── shared/
│       └── src/
│           ├── types.ts               ← Shared types (Exercise, PeriodOnset, etc.)
│           └── schemas.ts             ← Zod schemas for request validation
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Home/
│   │   │   ├── Cycle/
│   │   │   ├── Workout/
│   │   │   ├── Settings/
│   │   │   └── Shared/
│   │   ├── hooks/
│   │   ├── api.ts                     ← React Query hooks calling Worker
│   │   └── types.ts                   ← Frontend-only types
│   └── package.json
├── backend/
│   ├── src/
│   │   ├── index.ts                   ← Worker entry, routes, CORS middleware
│   │   ├── auth.ts                    ← JWT sign/verify, login/register handlers
│   │   ├── cycle-engine.ts            ← Phase prediction
│   │   ├── workout-engine.ts          ← Workout generation + progression
│   │   ├── validate.ts               ← Zod validation middleware per route
│   │   └── types.ts                   ← Backend-only types
│   ├── wrangler.toml
│   └── package.json
├── database/
│   ├── db.ts                          ← Data access module
│   ├── migrations/
│   │   └── 001_schema.sql
│   └── seed/
│       └── exercises.sql
├── test/
│   ├── unit/
│   │   ├── cycle-engine.test.ts
│   │   └── workout-engine.test.ts
│   ├── integration/
│   │   └── api.test.ts
│   └── auth/
│       └── auth-flow.test.ts          ← register → login → protected route 401
├── docs/
│   ├── schema.sql
│   ├── architecture.md
│   └── adr/
├── .github/
│   └── workflows/
│       ├── ci.yml                     ← Build + lint + test on PR
│       ├── deploy-frontend.yml
│       └── deploy-backend.yml
├── turbo.json
├── package.json
└── tsconfig.json
```

## API Endpoints

| Endpoint | Auth | Validation Schema | Purpose |
|---|---|---|---|
| `GET /api/health` | No | — | Health check for CI/deploy smoke test |
| `POST /api/auth/register` | No | `RegisterSchema` | Set password (onboarding) |
| `POST /api/auth/login` | No | `LoginSchema` | Returns JWT |
| `POST /api/onboarding` | Yes | `OnboardingSchema` | Submit wizard data (onset, preferences, measurements) |
| `GET /api/dashboard` | Yes | — | Phase banner, today's workout summary, PRs, latest measurements |
| `GET /api/cycle` | Yes | — | Calendar data with phase colors, onsets, predictions |
| `POST /api/period-onsets` | Yes | `PeriodOnsetSchema` | Log onset |
| `POST /api/symptoms` | Yes | `SymptomSchema` | Log symptom |
| `GET /api/workouts/today` | Yes | — | Generated workout for today |
| `POST /api/workout-sessions` | Yes | `WorkoutSessionSchema` | Save completed session |
| `GET /api/preferences` | Yes | — | Read preferences |
| `PATCH /api/preferences` | Yes | `PreferencesSchema` | Update preferences |

## API Design Rules
- **CORS:** Worker reads `CORS_ORIGIN` env var (set via `wrangler secret put CORS_ORIGIN`). Returns `Access-Control-Allow-Origin: <value>`. No wildcard.
- **Auth:** Every protected endpoint returns 401 if JWT is missing/expired. 403 for invalid token signature.
- **Validation:** Zod schemas in `packages/shared/src/schemas.ts`. Applied at the top of each handler before business logic.
- **Errors:** All errors return `{ error: string }` with appropriate HTTP status (400 bad request, 401 unauthorized, 403 forbidden, 404 not found, 409 conflict, 429 rate-limited, 500 server error).
- **Success:** 200 for reads/updates, 201 for resource creation.

## Secret Management
| Secret | Storage | Source |
|---|---|---|
| `JWT_SECRET` | `wrangler secret put` | Random 64-char hex, generated at deploy time |
| `CORS_ORIGIN` | `wrangler secret put` | `https://<project>.pages.dev` |
| `D1 database` | `wrangler.toml` binding | Cloudflare dashboard binding |

No secrets in `wrangler.toml`, `.env`, or committed code.

## Monorepo Tooling (Turborepo)
Root `package.json` defines npm workspaces pointing to `packages/*`, `frontend/`, `backend/`.

```
turbo.json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "test": {
      "dependsOn": ["build"]
    },
    "lint": {}
  }
}
```

**Build order:** `shared` → `frontend` + `backend` (parallel). CI only rebuilds changed packages via Turborepo cache.

## Migration Strategy
Forward-only migrations. D1 does not have native rollback tooling.

- Each migration is a numbered file (`001_schema.sql`, `002_add_index.sql`)
- Migrations are applied sequentially using `wrangler d1 execute --file=`
- Rollbacks are handled by restoring from a D1 backup or writing a forward migration that reverses the change
- Documented as a decision rather than a gap — single-user means backup-restore is a valid rollback strategy

## Key Design Decisions

### Phase Prediction: Compute on Read
Cycle engine calculates phase for any date by loading onsets, computing median cycle length, dividing phases proportionally. No `cycle_days` cache table.

### Workout Generation
1. Determine current phase
2. Load all exercises
3. Filter by phase tags (remove "avoid" types)
4. Rank by "prioritize" tag, then by target muscle groups
5. Pick top N exercises (configurable, default 5)
6. Attach default sets/reps

### Seeding
Manual `wrangler d1 execute --file=seed/exercises.sql` run once during initial setup.

### Health Check
`GET /api/health` returns `200 { "status": "ok", "timestamp": "..." }`. Used as a smoke test in `deploy-backend.yml` CI after deploy.

### Auth-Flow Tests
Three test cases in `test/auth/auth-flow.test.ts`:
1. `POST /api/auth/register` with valid password → 201
2. `POST /api/auth/login` with valid credentials → 200 + JWT in body
3. `GET /api/workouts/today` without `Authorization` header → 401
