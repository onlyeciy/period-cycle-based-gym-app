-- Personal Gym + Cycle Coach — D1 Schema

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE period_onsets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  onset_date DATE NOT NULL UNIQUE,
  flow_intensity TEXT CHECK(flow_intensity IN ('light', 'medium', 'heavy')),
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE exercises (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  muscle_group TEXT NOT NULL,
  exercise_type TEXT NOT NULL CHECK(exercise_type IN (
    'hinge', 'squat', 'pull', 'push', 'core', 'accessory'
  )),
  difficulty TEXT CHECK(difficulty IN ('beginner', 'intermediate', 'advanced')),
  default_sets INTEGER NOT NULL DEFAULT 3,
  default_reps INTEGER NOT NULL DEFAULT 10
);

CREATE TABLE phase_tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phase TEXT NOT NULL CHECK(phase IN ('menstrual', 'follicular', 'ovulatory', 'luteal')),
  exercise_type TEXT NOT NULL CHECK(exercise_type IN (
    'hinge', 'squat', 'pull', 'push', 'core', 'accessory'
  )),
  tag TEXT NOT NULL CHECK(tag IN ('prioritize', 'avoid')),
  UNIQUE(phase, exercise_type)
);

CREATE TABLE workout_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_date DATE NOT NULL,
  cycle_phase TEXT NOT NULL CHECK(cycle_phase IN (
    'menstrual', 'follicular', 'ovulatory', 'luteal'
  )),
  duration_minutes INTEGER,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE workout_sets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL REFERENCES workout_sessions(id),
  exercise_id INTEGER NOT NULL REFERENCES exercises(id),
  set_number INTEGER NOT NULL DEFAULT 1,
  weight_kg REAL NOT NULL DEFAULT 0,
  reps INTEGER NOT NULL DEFAULT 0,
  rpe REAL,
  UNIQUE(session_id, exercise_id, set_number)
);

CREATE TABLE symptoms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  symptom_date DATE NOT NULL,
  cycle_phase TEXT NOT NULL CHECK(cycle_phase IN (
    'menstrual', 'follicular', 'ovulatory', 'luteal'
  )),
  cramps TEXT CHECK(cramps IN ('none', 'mild', 'moderate', 'severe')),
  energy TEXT CHECK(energy IN ('low', 'medium', 'high')),
  mood TEXT CHECK(mood IN ('low', 'neutral', 'good', 'great')),
  flow_intensity TEXT CHECK(flow_intensity IN ('none', 'light', 'medium', 'heavy')),
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE measurements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  measurement_date DATE NOT NULL,
  waist_cm REAL,
  hip_cm REAL,
  glute_cm REAL,
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE user_preferences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  body_goal TEXT DEFAULT 'recomp',
  target_muscle_groups TEXT DEFAULT 'glutes,back',
  measurement_reminder_days INTEGER DEFAULT 4,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);
