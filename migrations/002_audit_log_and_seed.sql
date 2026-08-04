-- Migration 002: Audit log and seed
CREATE TABLE IF NOT EXISTS audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id TEXT,
  details TEXT,
  performed_by TEXT,
  ip_address TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS errors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT,
  message TEXT,
  path TEXT,
  method TEXT,
  stack TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_errors_created ON errors(createdAt);
