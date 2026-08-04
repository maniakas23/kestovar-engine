-- Migration 020: Schema autonomous
CREATE TABLE IF NOT EXISTS schema_versions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  version INTEGER NOT NULL UNIQUE,
  applied_at INTEGER DEFAULT (unixepoch()),
  description TEXT
);

INSERT OR IGNORE INTO schema_versions (version, description) VALUES 
  (20, 'Autonomous schema tracking');
