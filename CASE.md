# CASE.md — Personal Gym + Cycle Coach

Decisions captured from the grill-me session (July 12, 2026).

## Vision
A single-user webapp that replaces Flo for period tracking *and* serves as a personal gym coach — prescribing phase-aligned workouts that maximize beginner gains while working *with* the user's menstrual cycle, not against it. Body goal: recomp with a glute + back focus for a toned, proportional look.

---

## Design Decisions

### Cycle Tracking
- **Phases tracked:** All 4 — Menstrual, Follicular, Ovulatory, Luteal
- **Period onset:** Day 1 = first day of any bleeding or spotting that follows >21 days since the last onset, with a light/heavy intensity marker
- **Mid-cycle spotting:** Logged as a symptom under the current cycle phase, never as a new period onset
- **Prediction algorithm:** Median of the last 3 logged cycle lengths. Phase durations are proportional (Menstrual ~5 days, Follicular ~9 days, Ovulatory ~3 days, Luteal = remaining). Symptoms do not affect the prediction — they provide context for coaching only. Starts with a 28-day default, self-corrects after 2-3 logged onsets.
- **Symptom logging:** Optional — cramps, energy, mood, flow intensity. Contextualizes coaching recommendations.

### Exercise Programming
- **Library:** Curated ~20-30 beginner exercises with fields: name, muscle group, type (hinge/squat/pull/push/core/accessory), difficulty, default sets/reps
- **Phase filtering:** Phase tags (prioritize / avoid) attach to exercise type, not to individual exercises. Workout generation filters by type, then biases toward target muscle groups based on body goals.
- **Progression engine:** Average-based check — if the average reps across all sets meet the target, the app suggests +2.5kg next time. Suggestion only fires if the last session with that exercise was within 7 days. The user confirms all increases; never auto-increments.
- **Phase-specific rules:**
  - **Menstrual:** Avoid heavy axial-loaded lower body. Prescribe upper body, light isolation, walking. Reduce sets (5-6 RPE).
  - **Follicular:** Push volume and intensity on lower body compounds, especially glutes (7-9 RPE).
  - **Ovulatory:** Maintain intensity, add stability/accessory work (7-8 RPE). Higher injury risk — no PR chasing.
  - **Luteal:** Cap intensity (5-7 RPE), favor upper body, slower eccentrics, technique work. Reduce total volume.

### Workout Flow
- **Generation:** Combines the current cycle phase (which exercise types to prioritize/avoid) with body goals (which muscle groups to emphasize).
- **During:** Checklist of exercises. For each exercise, an in-app input to log weight + reps (single entry per exercise, applied to all sets — overridable per set). User can swap any exercise for any other exercise of the same type that fits the current phase.
- **After:** Tap "Finish Session" → saved to history (workout_sessions → workout_sets, normalized per-set). If all targets hit on average, next session flags a suggested increase.

### Progress Tracking
- **Primary metrics:** Strength progression (weight on bar) + body measurements (waist, hip, glute circumference)
- **Measurement scheduling:** Reminder fires N days after a logged period onset (user-configured, default 4 days). All measurements timestamped with cycle day.

### Home Tab
Dashboard showing: phase banner + next phase prediction, today's recommended workout (quick-start button), latest strength PRs, latest measurement context, quick symptom/period log prompt. Progress screens are merged into this tab rather than a dedicated tab.

### Onboarding (Full Wizard)
1. Last period start date — mandatory, but approximate is acceptable. The app self-corrects after 2-3 logged onsets.
2. Body goal confirmation (recomp, lower body + back)
3. Initial measurements (waist, hip, glute) — optional, skip-able with guidance
4. Optional: current max lifts for a smarter starting point

### Navigation
- **Mobile:** Bottom tab bar (3): Home | Cycle | Workout. Hamburger menu (top-left) for Settings.
- **Desktop:** Left sidebar with the same 3 tabs + Settings at the bottom. No hamburger — Settings is always visible in the sidebar.
- **Cycle tab:** Calendar view with phase colors.

### Architecture
- **Frontend:** React + Tailwind CSS
- **Hosting + API:** Cloudflare Pages + Workers
- **Database:** Cloudflare D1 (SQLite-based, 5GB free)
- **Auth:** None (single-user)
- **AI:** None in v1. All coaching is deterministic (if/else + lookup tables). AI may be added later via Cloudflare Workers AI for free-text logging or pattern detection.

### Settings
1. **Measurement schedule** — N days after period onset to auto-remind (default: 4)
2. **Goal preferences** — one-time confirmation, set-and-forget
3. **Data management** — Export (JSON download), Import (restore), Reset (delete all)

### What Was Explicitly Deferred
- AI/LLM integration (post-MVP, once 2-3 months of data exist)
- Multi-user / auth (staying single-user)
- Push notifications / reminders (v1 is a "visit daily" webapp)
- Public deployment (app is private to the user)

### Cost
- **$0/month** — Cloudflare free tier (Pages + Workers + D1) is sufficient indefinitely for a single user
- **Upgrade path:** Worker CPU/RAM limits or D1 storage can scale paid if usage grows, but unnecessary at this scale
