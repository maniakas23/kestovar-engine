-- Migration 005: Playbooks and executions
CREATE TABLE IF NOT EXISTS playbooks (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  triggers TEXT,
  steps TEXT,
  autoExecute INTEGER DEFAULT 0,
  createdAt INTEGER DEFAULT (unixepoch()),
  updatedAt INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS execution_logs (
  id TEXT PRIMARY KEY,
  playbookId TEXT NOT NULL,
  incidentId TEXT,
  status TEXT DEFAULT 'running',
  steps TEXT,
  startedAt INTEGER,
  completedAt INTEGER,
  durationMs INTEGER,
  error TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_exec_playbook ON execution_logs(playbookId);
CREATE INDEX IF NOT EXISTS idx_exec_incident ON execution_logs(incidentId);
