-- Migration 027: Missing tables
CREATE TABLE IF NOT EXISTS alert_rules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  orgId INTEGER NOT NULL,
  name TEXT NOT NULL,
  conditions TEXT,
  actions TEXT,
  enabled INTEGER DEFAULT 1,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_alert_rules_org ON alert_rules(orgId);

CREATE TABLE IF NOT EXISTS webhook_configs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  org_id INTEGER,
  name TEXT,
  url TEXT,
  events TEXT,
  headers TEXT,
  active INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS webhook_deliveries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  webhook_id INTEGER,
  event_type TEXT,
  payload TEXT,
  response_status INTEGER,
  response_body TEXT,
  success INTEGER DEFAULT 0,
  duration_ms INTEGER,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_webhook_deliveries ON webhook_deliveries(webhook_id);
