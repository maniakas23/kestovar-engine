-- Migration 012: Schema canonicalization
-- Comprehensive schema update to canonicalize all tables

-- Ensure all tables use INTEGER for timestamps
CREATE TABLE IF NOT EXISTS events_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  orgId INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  severity TEXT DEFAULT 'info',
  status TEXT DEFAULT 'open',
  providerType TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

INSERT OR IGNORE INTO events_new SELECT * FROM events WHERE id IS NOT NULL;
DROP TABLE IF EXISTS events;
ALTER TABLE events_new RENAME TO events;

CREATE INDEX IF NOT EXISTS idx_events_created ON events(createdAt);
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);

-- Canonicalize provider_runs
CREATE TABLE IF NOT EXISTS provider_runs_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  orgId INTEGER NOT NULL,
  providerType TEXT,
  status TEXT,
  recordsFound INTEGER DEFAULT 0,
  recordsAccepted INTEGER DEFAULT 0,
  recordsRejected INTEGER DEFAULT 0,
  durationMs INTEGER,
  errorMessage TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

INSERT OR IGNORE INTO provider_runs_new SELECT * FROM provider_runs WHERE id IS NOT NULL;
DROP TABLE IF EXISTS provider_runs;
ALTER TABLE provider_runs_new RENAME TO provider_runs;

CREATE INDEX IF NOT EXISTS idx_provider_runs_created ON provider_runs(createdAt);
