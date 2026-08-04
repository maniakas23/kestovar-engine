-- Migration 010: Policy security
CREATE TABLE IF NOT EXISTS policies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  category TEXT,
  rules TEXT,
  status TEXT DEFAULT 'active',
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS policy_violations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  policy_id INTEGER NOT NULL,
  entity_type TEXT,
  entity_id TEXT,
  details TEXT,
  severity TEXT DEFAULT 'warning',
  status TEXT DEFAULT 'open',
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_violations_policy ON policy_violations(policy_id);
CREATE INDEX IF NOT EXISTS idx_violations_status ON policy_violations(status);
