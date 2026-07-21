# Personal Gym + Cycle Coach

A single-user webapp for period tracking and phase-aligned workout programming.

## Language

**Onboarding**:
A mandatory wizard that captures the user's last period start date (approximate is acceptable), body goal preferences, optional initial measurements, and optional current max lifts. The app self-corrects phase prediction after 2-3 logged onsets.

**Period Onset**:
Day 1 of a new menstrual cycle, defined as the first day of any bleeding or spotting that follows >21 days since the last onset.
_Avoid_: Period start, bleeding day

**Mid-Cycle Spotting**:
Any bleeding or spotting that occurs between logged period onsets. Logged as a symptom under the current cycle phase, never as a new period onset.
_Avoid_: Breakthrough bleeding

**Cycle Phase**:
One of four phases that a calendar day belongs to: Menstrual, Follicular, Ovulatory, Luteal. Determined by the adaptive prediction algorithm based on logged period onsets and symptoms. A property of the calendar day, not of workouts or exercises.

**Exercise**:
A single movement (e.g., barbell squat, dumbbell row). Has a name, muscle group, exercise type, difficulty level, default sets/reps, and phase tags.

**Exercise Type**:
The movement pattern category: hinge, squat, pull, push, core, or accessory. Phase filtering rules attach to exercise type, not to muscle group.

**Muscle Group**:
The anatomical target (e.g., glutes, hamstrings, quads, back, chest, shoulders, arms, core). Used for progress tracking and user reference, not for phase-based filtering.

**Phase Tag**:
A rule that marks an exercise type as "prioritize" or "avoid" during a given cycle phase. Applied at workout-generation time to filter and rank exercises.

**Symptom**:
A user-logged qualitative marker for a given day: cramps, energy level, mood, or flow intensity. Optional. Used to refine phase prediction and contextualize coaching recommendations.

**Body Goal**:
The user's stated training objective (e.g., recomp with glute + back focus). Biases exercise selection toward target muscle groups within the types permitted by the current cycle phase.

**Workout**:
A generated plan — a set of exercises suggested for a given day. Produced by the intersection of the user's current cycle phase and body goal.

**Workout Session**:
A logged instance of a completed workout. Contains the date, cycle phase at the time, duration, and one or more workout sets.

**Workout Set**:
A single recorded set within a workout session. Contains set number, weight, reps, and optional RPE.

**JWT**:
JSON Web Token used for stateless session auth. Signed with a `JWT_SECRET` environment variable set via `wrangler secret`. Verified on every protected request by middleware in the Worker entry point.

**CORS Origin**:
The frontend's deployment URL, stored as the `CORS_ORIGIN` env var. The Worker reads this to set the `Access-Control-Allow-Origin` response header. Never uses wildcard.

**Monorepo**:
A single repository containing `packages/shared`, `frontend/`, and `backend/`, orchestrated by Turborepo. The `shared` package compiles first; frontend and backend depend on it. CI rebuilds only changed packages.

**Migration**:
A numbered SQL file (e.g., `001_schema.sql`) applied forward-only via `wrangler d1 execute`. D1 has no native rollback; reversions are handled by backup restore or a compensating forward migration.

**Rate Limiting**:
Login endpoint limited to 5 attempts per 15 minutes per IP using Cloudflare KV. Returns 429 when exceeded. Applied even though the app is single-user.
