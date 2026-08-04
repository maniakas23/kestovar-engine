-- Migration 024: Supervisor, QA, Chaos
CREATE TABLE IF NOT EXISTS agent_registry (
  agent_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  version TEXT DEFAULT '4.3.3',
  status TEXT DEFAULT 'registered',
  last_heartbeat INTEGER,
  dependencies TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_agent_status ON agent_registry(status);

CREATE TABLE IF NOT EXISTS agent_health_checks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  agent_id TEXT NOT NULL,
  check_type TEXT,
  result TEXT,
  details TEXT,
  checked_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_health_agent ON agent_health_checks(agent_id);

CREATE TABLE IF NOT EXISTS qa_findings (
  id TEXT PRIMARY KEY,
  inspection_id TEXT,
  finding_type TEXT,
  severity TEXT DEFAULT 'medium',
  description TEXT,
  recommendation TEXT,
  status TEXT DEFAULT 'open',
  resolved_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_qa_inspection ON qa_findings(inspection_id);
CREATE INDEX IF NOT EXISTS idx_qa_status ON qa_findings(status);

CREATE TABLE IF NOT EXISTS qa_inspections (
  id TEXT PRIMARY KEY,
  scope TEXT,
  inspection_type TEXT,
  findings_count INTEGER DEFAULT 0,
  score INTEGER,
  status TEXT DEFAULT 'running',
  started_at INTEGER DEFAULT (unixepoch()),
  completed_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_qa_inspections_status ON qa_inspections(status);

CREATE TABLE IF NOT EXISTS chaos_experiments (
  id TEXT PRIMARY KEY,
  experiment_type TEXT,
  service TEXT,
  hypothesis TEXT,
  result TEXT,
  status TEXT DEFAULT 'pending',
  started_at INTEGER DEFAULT (unixepoch()),
  completed_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_chaos_service ON chaos_experiments(service);
CREATE INDEX IF NOT EXISTS idx_chaos_status ON chaos_experiments(status);

CREATE TABLE IF NOT EXISTS status_page_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service TEXT,
  status TEXT,
  message TEXT,
  incident_id TEXT,
  severity TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_status_page ON status_page_events(service, created_at);

CREATE TABLE IF NOT EXISTS incident_costs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT NOT NULL,
  cost_category TEXT,
  estimated_cost REAL,
  actual_cost REAL,
  currency TEXT DEFAULT 'USD',
  calculated_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_costs_incident ON incident_costs(incident_id);

CREATE TABLE IF NOT EXISTS agent_efficiency (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  agent_name TEXT NOT NULL,
  execution_count INTEGER DEFAULT 0,
  success_count INTEGER DEFAULT 0,
  total_duration_ms INTEGER DEFAULT 0,
  avg_duration_ms INTEGER DEFAULT 0,
  last_execution_at INTEGER,
  recorded_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_efficiency_agent ON agent_efficiency(agent_name);
