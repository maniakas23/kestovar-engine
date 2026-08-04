-- Migration 011: Founder bootstrap sessions
CREATE TABLE IF NOT EXISTS bootstrap_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL UNIQUE,
  stage TEXT DEFAULT 'initializing',
  progress_percent INTEGER DEFAULT 0,
  logs TEXT,
  result TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  completed_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_bootstrap_session ON bootstrap_sessions(session_id);
