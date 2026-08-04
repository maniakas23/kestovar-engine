-- Migration 025: Improvement agent
CREATE TABLE IF NOT EXISTS improvement_cycles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cycle_type TEXT NOT NULL,
  status TEXT DEFAULT 'running',
  recommendations_found INTEGER DEFAULT 0,
  recommendations_applied INTEGER DEFAULT 0,
  summary TEXT,
  started_at INTEGER DEFAULT (unixepoch()),
  completed_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_improvement_status ON improvement_cycles(status);

CREATE TABLE IF NOT EXISTS improvement_recommendations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cycle_id INTEGER NOT NULL,
  category TEXT,
  title TEXT,
  description TEXT,
  expected_impact TEXT,
  confidence INTEGER DEFAULT 70,
  status TEXT DEFAULT 'pending',
  applied_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_recommendations_cycle ON improvement_recommendations(cycle_id);
CREATE INDEX IF NOT EXISTS idx_recommendations_status ON improvement_recommendations(status);
