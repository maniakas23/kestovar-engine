-- Migration 023: Intelligence system
CREATE TABLE IF NOT EXISTS metric_baselines (
  id TEXT PRIMARY KEY,
  service TEXT NOT NULL,
  metric_type TEXT NOT NULL,
  mean_value REAL,
  std_dev REAL,
  sample_size INTEGER DEFAULT 0,
  window_start INTEGER,
  window_end INTEGER,
  updated_at INTEGER DEFAULT (unixepoch()),
  UNIQUE(service, metric_type)
);

CREATE INDEX IF NOT EXISTS idx_baselines_service ON metric_baselines(service);

CREATE TABLE IF NOT EXISTS knowledge_graph (
  id TEXT PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_name TEXT NOT NULL,
  properties TEXT,
  first_seen INTEGER DEFAULT (unixepoch()),
  last_seen INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_kg_entity ON knowledge_graph(entity_type, entity_name);

CREATE TABLE IF NOT EXISTS kg_relationships (
  id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL,
  target_id TEXT NOT NULL,
  relation_type TEXT,
  properties TEXT,
  first_observed_at INTEGER DEFAULT (unixepoch()),
  last_observed_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_kg_rel_source ON kg_relationships(source_id);
CREATE INDEX IF NOT EXISTS idx_kg_rel_target ON kg_relationships(target_id);

CREATE TABLE IF NOT EXISTS intelligence_reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  report_type TEXT NOT NULL,
  service TEXT,
  findings TEXT,
  recommendations TEXT,
  confidence INTEGER DEFAULT 70,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_intel_type ON intelligence_reports(report_type, service);

CREATE TABLE IF NOT EXISTS log_patterns (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pattern TEXT NOT NULL,
  service TEXT,
  frequency INTEGER DEFAULT 1,
  severity TEXT DEFAULT 'info',
  first_seen INTEGER DEFAULT (unixepoch()),
  last_seen INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_patterns_service ON log_patterns(service);

CREATE TABLE IF NOT EXISTS config_baselines (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service TEXT NOT NULL,
  config_key TEXT NOT NULL,
  config_value TEXT,
  baseline_value TEXT,
  status TEXT DEFAULT 'ok',
  detected_at INTEGER DEFAULT (unixepoch()),
  UNIQUE(service, config_key)
);

CREATE INDEX IF NOT EXISTS idx_config_service ON config_baselines(service);

CREATE TABLE IF NOT EXISTS backup_verifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  backup_type TEXT,
  service TEXT,
  status TEXT DEFAULT 'pending',
  details TEXT,
  verified_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_backup_service ON backup_verifications(service);

CREATE TABLE IF NOT EXISTS compliance_metrics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  metric_name TEXT NOT NULL,
  service TEXT,
  target_value REAL,
  actual_value REAL,
  period TEXT,
  status TEXT DEFAULT 'compliant',
  recorded_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_compliance_name ON compliance_metrics(metric_name, service);

CREATE TABLE IF NOT EXISTS sla_violations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service TEXT,
  sla_type TEXT,
  threshold_value REAL,
  actual_value REAL,
  violation_duration_seconds INTEGER,
  status TEXT DEFAULT 'open',
  detected_at INTEGER DEFAULT (unixepoch()),
  resolved_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_sla_service ON sla_violations(service, status);
