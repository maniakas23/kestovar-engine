-- Migration 004: Learning tables
CREATE TABLE IF NOT EXISTS learning_reviews (
  id TEXT PRIMARY KEY,
  incidentId TEXT NOT NULL,
  whatHappened TEXT,
  rootCause TEXT,
  impact TEXT,
  actionItems TEXT,
  confidence INTEGER DEFAULT 70,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_learning_incident ON learning_reviews(incidentId);

CREATE TABLE IF NOT EXISTS learning_outcomes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT,
  playbook_id TEXT,
  platform TEXT,
  root_cause TEXT,
  fix_description TEXT,
  effectiveness INTEGER DEFAULT 0,
  confidence INTEGER DEFAULT 70,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_outcomes_incident ON learning_outcomes(incident_id);
CREATE INDEX IF NOT EXISTS idx_outcomes_platform ON learning_outcomes(platform);
