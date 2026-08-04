-- Migration 006: Production hardening
CREATE TABLE IF NOT EXISTS rate_limits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ip TEXT NOT NULL,
  endpoint TEXT,
  window_start INTEGER NOT NULL,
  request_count INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_rate_limits_ip ON rate_limits(ip, window_start);

CREATE TABLE IF NOT EXISTS deployments (
  id TEXT PRIMARY KEY,
  version TEXT NOT NULL,
  environment TEXT DEFAULT 'production',
  status TEXT DEFAULT 'pending',
  deployedAt INTEGER,
  deployedBy TEXT,
  rollbackVersion TEXT,
  metadata TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_deployments_env ON deployments(environment, status);

CREATE TABLE IF NOT EXISTS api_keys (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  keyHash TEXT NOT NULL,
  scopes TEXT,
  expiresAt INTEGER,
  lastUsedAt INTEGER,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_api_keys_hash ON api_keys(keyHash);
