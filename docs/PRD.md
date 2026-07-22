# PRD: Personal Gym + Cycle Coach — v1 Implementation

## Problem Statement

I want a single web application that tracks my menstrual cycle *and* prescribes phase-aligned workouts. Right now, I'd have to use separate tools — a period tracker app and a workout planner — and manually figure out what exercises to do based on my cycle phase. There's no tool that combines the two, adapts exercise selection automatically, and helps a beginner like me make consistent strength gains while working with my cycle instead of against it.

## Solution

A single-user webapp ("Personal Gym + Cycle Coach") that combines menstrual cycle tracking with automated workout programming. The app:

- Tracks period onsets and predicts the four cycle phases (Menstrual, Follicular, Ovulatory, Luteal) using an adaptive algorithm that self-corrects after 2-3 logged onsets.
- Generates a daily workout based on the current cycle phase and the user's body goal (default: recomp with glute + back focus). Workouts filter exercises by phase-appropriate types (e.g., avoid heavy axial-loaded lower body during Menstrual) and bias toward target muscle groups.
- Logs completed workout sessions with per-set weight, reps, and optional RPE.
- Tracks progress via strength PRs and body measurements (waist, hip, glute).
- Suggests weight progression (+2.5 kg) when the user consistently hits rep targets.
- Provides a dashboard with phase banner, today's workout, latest PRs, and quick log prompts.

## User Stories

### Cycle Tracking

1. As a user, I want to log a period onset as "Day 1" of my cycle, so that the app can track my cycle length and predict future phases.
2. As a user, I want to mark the flow intensity (light/medium/heavy) when logging a period onset, so that I have a richer record of my cycle.
3. As a user, I want the app to validate that a new onset is at least 21 days after the last one, so that mid-cycle spotting is never accidentally recorded as a new period.
4. As a user, I want to log mid-cycle spotting as a symptom instead of a new period onset, so that my cycle tracking remains accurate.
5. As a user, I want to log optional daily symptoms (cramps, energy, mood, flow intensity), so that I can see patterns across cycles.
6. As a user, I want the app to predict my current cycle phase based on my logged onsets, so that I know where I am in my cycle without manual calculation.
7. As a user, I want the prediction algorithm to use the median of my last 3 cycle lengths, so that outliers don't skew predictions.
8. As a user, I want the app to fall back to a 28-day default cycle before I have 2-3 logged onsets, so that the app works from day one.
9. As a user, I want a calendar view that shows my cycle phases with color coding, so that I can visualize past and predicted phases.

### Workout Programming

10. As a user, I want the app to generate a daily workout based on my current cycle phase, so that my training is automatically aligned with my body's hormonal environment.
11. As a user, I want the app to avoid heavy axial-loaded lower body exercises during my Menstrual phase, so that I don't push through unnecessary fatigue or discomfort.
12. As a user, I want the app to prioritize lower body compound lifts (especially glutes) during my Follicular phase, so that I capitalize on peak strength and recovery.
13. As a user, I want the app to cap intensity and add stability work during my Ovulatory phase, so that I reduce injury risk while still making progress.
14. As a user, I want the app to favor upper body and technique work during my Luteal phase, so that I train effectively despite lower energy and reduced capacity.
15. As a user, I want the app to bias exercise selection toward my target muscle groups (glutes, back) as specified in my body goal, so that my training is personalized.
16. As a user, I want the app to pull from a curated library of ~20-30 beginner exercises, so that every prescribed movement is appropriate for my experience level.
17. As a user, I want each exercise to show default sets and reps, so that I know exactly what to do.
18. As a user, I want to swap any prescribed exercise for another exercise of the same type that fits the current phase, so that I have flexibility when equipment or preferences differ.

### Workout Logging

19. As a user, I want a checklist-style interface during my workout, so that I can track completion and log data in real time.
20. As a user, I want to log weight and reps for each exercise (with a single input applied to all sets, overridable per set), so that logging is fast but still accurate.
21. As a user, I want to optionally log RPE for each set, so that I can track perceived effort alongside objective numbers.
22. As a user, I want to tap "Finish Session" to save the complete workout, so that I don't lose my data.
23. As a user, I want completed workout sessions stored with the cycle phase at the time, so that I can review performance across phases later.

### Progression

24. As a user, I want the app to suggest increasing weight by +2.5 kg when I consistently hit my rep targets across all sets, so that I make steady progress.
25. As a user, I want the suggestion to only fire if the last session with that exercise was within 7 days, so that I don't get progression prompts after a layoff.
26. As a user, I want to confirm or decline every weight increase suggestion, so that I never get auto-incremented past what I'm comfortable with.

### Dashboard

27. As a user, I want a home dashboard that shows my current phase banner with the next phase prediction, so that I have immediate cycle awareness.
28. As a user, I want the dashboard to show today's recommended workout with a quick-start button, so that I can begin my session in one tap.
29. As a user, I want the dashboard to show my latest strength PRs, so that I can celebrate progress.
30. As a user, I want the dashboard to show my most recent measurements with cycle day context, so that I can track body changes across phases.
31. As a user, I want the dashboard to include quick log prompts for symptoms or period onset, so that I don't forget to log.

### Onboarding

32. As a new user, I want a mandatory onboarding wizard that asks for my last period start date (approximate is ok), so that the app can start predicting phases immediately.
33. As a new user, I want to confirm my body goal during onboarding (default: recomp with glute + back focus), so that workouts are personalized from day one.
34. As a new user, I want the option to enter initial measurements (waist, hip, glute) during onboarding, so that I have a baseline for progress tracking.
35. As a new user, I want the option to enter my current max lifts during onboarding, so that the progression engine has a smarter starting point.

### Measurement Tracking

36. As a user, I want to log body measurements (waist, hip, glute circumference), so that I can track physical changes over time.
37. As a user, I want the app to remind me to take measurements N days after a period onset (configurable, default 4), so that I measure at a consistent point in each cycle.
38. As a user, I want all measurements timestamped with their cycle day, so that I can compare measurements across phases.

### Settings

39. As a user, I want to configure the measurement reminder delay (days after period onset), so that the reminder timing suits my preference.
40. As a user, I want to review and confirm my body goal preferences in settings, so that I can change my training focus if needed.
41. As a user, I want to export all my data as a JSON download, so that I have a portable backup.
42. As a user, I want to import previously exported data, so that I can restore my history after reset or migration.
43. As a user, I want to reset all my data with a confirmation step, so that I can start fresh if needed.

### Auth & Session

44. As a user, I want to set a username and password during onboarding, so that my data is protected.
45. As a user, I want to log in with my username and password and receive a JWT, so that I can access my data securely.
46. As a user, I want my JWT session to persist until I log out, so that I don't have to re-authenticate on every visit.
47. As a user, I want the login endpoint rate-limited per username and per IP, so that my data is protected from brute-force attempts.

### Navigation

48. As a mobile user, I want a bottom tab bar with Home | Cycle | Workout tabs, so that I can navigate easily with one hand.
49. As a mobile user, I want Settings accessible from a hamburger menu, so that the main navigation stays focused.
50. As a desktop user, I want a left sidebar with the same tabs plus Settings always visible, so that I can navigate without extra clicks.

## Implementation Decisions

### Architecture
- **Frontend:** React + Tailwind CSS + React Router + React Query
- **Backend:** Cloudflare Worker (TypeScript), separate from frontend deployment
- **Database:** Cloudflare D1 (SQLite-based, 5 GB free tier)
- **Auth:** JWT with username + password, bcryptjs (cost 12) for hashing, Cloudflare KV for login rate-limiting (5 attempts / 15 min per username + per IP)
- **Monorepo:** Turborepo with npm workspaces; three packages: `packages/shared`, `frontend/`, `backend/`
- **Validation:** Zod schemas in `packages/shared/src/schemas.ts`, applied per-route in Worker handlers before business logic
- **CORS:** Worker reads `CORS_ORIGIN` env var; no wildcard; set via `wrangler secret put`

### Phase Prediction Algorithm (Compute on Read)
- Load last 3 period onsets, compute median cycle length
- Divide phases proportionally: Menstrual ~5 days, Follicular ~9 days, Ovulatory ~3 days, Luteal = remaining
- Fall back to 28-day default before 2-3 logged onsets
- No `cycle_days` cache table; computed at query time

### Workout Generation
1. Determine current phase
2. Load all exercises
3. Filter by phase tags (remove "avoid" types)
4. Rank by "prioritize" tag, then by target muscle groups
5. Pick top N exercises (configurable, default 5)
6. Attach default sets/reps

### Progression Engine
- Average-based check: if average reps across all sets meets the target, suggest +2.5 kg next time
- Suggestion only fires if the last session with that exercise was within 7 days
- User must confirm all increases; never auto-increment

### Database Schema
9 tables: `users`, `period_onsets`, `exercises`, `phase_tags`, `workout_sessions`, `workout_sets`, `symptoms`, `measurements`, `user_preferences`. Schema defined in `docs/schema.sql`. Migrations are forward-only numbered SQL files applied via `wrangler d1 execute`.

### API Endpoints
12 endpoints under `/api/v1/`:
- `GET /health` -- health check (no auth)
- `POST /auth/register` -- set username + password
- `POST /auth/login` -- returns JWT
- `POST /onboarding` -- submit wizard data
- `GET /dashboard` -- phase, workout, PRs, measurements
- `GET /cycle` -- calendar data with phases
- `POST /period-onsets` -- log onset
- `POST /symptoms` -- log symptom
- `GET /workouts/today` -- generated workout
- `POST /workout-sessions` -- save completed session
- `GET /preferences` -- read preferences
- `PATCH /preferences` -- update preferences

All errors return `{ error: string }` with appropriate HTTP status (400, 401, 403, 404, 409, 429, 500). Success: 200 for reads/updates, 201 for resource creation.

### Seeds
Manual `wrangler d1 execute --file=seed/exercises.sql` for initial exercise library (~20-30 exercises with phase tags).

### API Versioning
All endpoints under `/api/v1/`. Breaking changes increment to `/api/v2/` while keeping v1 running until consumed.

## Testing Decisions

### Testing Philosophy
- Test external behavior, not implementation details
- Prefer the highest possible seam (request-level integration > unit > module internals)
- Use existing seams before introducing new ones

### Test Modules & Seams

1. **Cycle Engine (unit)** -- `test/unit/cycle-engine.test.ts`
   - Seam: The `predictPhase(onsets, targetDate)` pure function
   - What: Given onsets, does prediction return the correct phase for any date?
   - Prior art: None yet (first tests in the repo). Pattern: pure function input/output.

2. **Workout Engine (unit)** -- `test/unit/workout-engine.test.ts`
   - Seam: The `generateWorkout(phase, bodyGoal, exercises, phaseTags)` pure function
   - What: Given phase + body goal, does generation respect phase tags and muscle group bias?
   - Prior art: None yet. Pattern: pure function with seeded data.

3. **API Integration (integration)** -- `test/integration/api.test.ts`
   - Seam: HTTP request/response boundary (highest possible)
   - What: Full request-response cycle against the Worker. Correct status codes, headers, body shapes.
   - Prior art: Planned but not yet written. Use wrangler test helpers or miniflare.

4. **Auth Flow (auth-flow)** -- `test/auth/auth-flow.test.ts`
   - Seam: HTTP request/response boundary
   - What: register -> login -> protected endpoint without auth -> 401
   - Prior art: Explicitly designed in architecture.md. Full flow without mocking.

### Test Configuration
- Framework: Vitest plus wrangler test utils for Worker integration
- CI: `turbo run test` in GitHub Actions, depends on build via Turborepo pipeline

### New Seams Proposed
- None beyond what's documented. The four existing seams (cycle engine, workout engine, API integration, auth flow) cover the application.

## Out of Scope

- AI/LLM integration (post-MVP, once 2-3 months of user data exist)
- Multi-user / multi-account support (staying single-user; JWT + users table designs the path)
- Push notifications or reminders (v1 is a "visit daily" webapp)
- Public deployment or discovery (app is private to the user)
- Native mobile apps (mobile is the responsive webapp)
- Exercise video demonstrations or animation
- Nutrition tracking, meal planning, or supplementation guidance
- Social features, leaderboards, or sharing
- Wearable/device integration (Apple Watch, Fitbit, etc.)

## Further Notes

- The app targets **$0/month** hosting cost -- Cloudflare free tier (Pages + Workers + D1 + KV) is sufficient indefinitely for a single user.
- The primary user is a **beginner** with a body goal of recomp with glute + back focus. Exercise library and progression engine are tuned accordingly.
- The user confirms all weight increases. The app never auto-increments.
- Deploy pipeline: push to `main` GitHub Actions -> `turbo run build` -> `turbo run test` -> `wrangler pages publish` + `wrangler deploy` -> smoke test via `GET /api/v1/health`.
- Secrets (JWT_SECRET, CORS_ORIGIN) set via `wrangler secret put`, never committed.
- Build order: `shared` -> `frontend` + `backend` (parallel). Turborepo cache prevents rebuilding unchanged packages.
- Layout: Mobile -> bottom tab bar with hamburger for Settings. Desktop -> left sidebar with all tabs visible.
