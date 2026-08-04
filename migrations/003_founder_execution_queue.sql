-- Migration 003: Founder execution queue
CREATE TABLE IF NOT EXISTS founder_credentials (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service TEXT NOT NULL UNIQUE,
  api_key TEXT,
  token TEXT,
  refresh_token TEXT,
  expires_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS founder_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_token TEXT NOT NULL UNIQUE,
  user_id TEXT NOT NULL,
  expires_at INTEGER NOT NULL,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_founder_sessions_token ON founder_sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_founder_sessions_expires ON founder_sessions(expires_at);
