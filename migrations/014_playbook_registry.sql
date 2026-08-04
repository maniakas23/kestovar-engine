-- Migration 014: Playbook registry
CREATE TABLE IF NOT EXISTS playbook_registry (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  version TEXT DEFAULT '1.0.0',
  trigger_type TEXT,
  risk_level TEXT DEFAULT 'medium',
  auto_execute INTEGER DEFAULT 0,
  definition TEXT,
  status TEXT DEFAULT 'active',
  execution_count INTEGER DEFAULT 0,
  success_count INTEGER DEFAULT 0,
  avg_duration_ms INTEGER DEFAULT 0,
  last_executed_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_playbook_registry_trigger ON playbook_registry(trigger_type, status);

CREATE TABLE IF NOT EXISTS playbook_executions (
  id TEXT PRIMARY KEY,
  playbook_id TEXT NOT NULL,
  incident_id TEXT,
  status TEXT DEFAULT 'running',
  started_at INTEGER,
  completed_at INTEGER,
  duration_ms INTEGER,
  result TEXT,
  error TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_playbook_execs_playbook ON playbook_executions(playbook_id);
CREATE INDEX IF NOT EXISTS idx_playbook_execs_incident ON playbook_executions(incident_id);
