-- Migration 026: Cron execution log
CREATE TABLE IF NOT EXISTS agent_execution_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  agent_id TEXT NOT NULL,
  execution_type TEXT,
  result TEXT,
  error_message TEXT,
  details TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_exec_log_agent ON agent_execution_log(agent_id);
CREATE INDEX IF NOT EXISTS idx_exec_log_created ON agent_execution_log(created_at);

CREATE TABLE IF NOT EXISTS cron_reliability (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  schedule TEXT NOT NULL,
  execution_count INTEGER DEFAULT 0,
  success_count INTEGER DEFAULT 0,
  failure_count INTEGER DEFAULT 0,
  avg_duration_ms INTEGER DEFAULT 0,
  last_run_at INTEGER,
  last_success_at INTEGER,
  last_failure_at INTEGER,
  consecutive_failures INTEGER DEFAULT 0,
  status TEXT DEFAULT 'healthy',
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_cron_reliability_schedule ON cron_reliability(schedule);
