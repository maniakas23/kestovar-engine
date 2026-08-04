-- Migration 028: v4.3.6 Evidence + Policy
CREATE TABLE IF NOT EXISTS capability_evidence (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  capability_name TEXT NOT NULL UNIQUE,
  status TEXT DEFAULT 'NOT_STARTED',
  evidence_count INTEGER DEFAULT 0,
  required_evidence INTEGER DEFAULT 10,
  first_run_at INTEGER,
  last_run_at INTEGER,
  details TEXT,
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS capability_evidence_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  capability_name TEXT NOT NULL,
  event_type TEXT,
  records_written INTEGER DEFAULT 0,
  details TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_evidence_log_capability ON capability_evidence_log(capability_name);
CREATE INDEX IF NOT EXISTS idx_evidence_log_created ON capability_evidence_log(created_at);

CREATE TABLE IF NOT EXISTS notification_preferences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  channels TEXT,
  min_severity_webpush TEXT DEFAULT 'critical',
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS notification_delivery_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT,
  channel TEXT,
  destination TEXT,
  status TEXT,
  result TEXT,
  sent_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_notif_delivery_incident ON notification_delivery_log(incident_id);

CREATE TABLE IF NOT EXISTS notification_severity_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT,
  severity TEXT,
  channel TEXT,
  throttled INTEGER DEFAULT 0,
  reason TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_severity_log_incident ON notification_severity_log(incident_id);

CREATE TABLE IF NOT EXISTS alert_audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action TEXT NOT NULL,
  entity_type TEXT,
  entity_id TEXT,
  details TEXT,
  performed_by TEXT,
  ip_address TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_alert_audit_action ON alert_audit_log(action);

CREATE TABLE IF NOT EXISTS alert_throttle_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT,
  severity TEXT,
  channel TEXT,
  throttled INTEGER DEFAULT 0,
  reason TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_throttle_incident ON alert_throttle_log(incident_id);

CREATE TABLE IF NOT EXISTS remediation_gateway_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  action TEXT,
  target TEXT,
  status TEXT,
  result TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_remediation_gateway ON remediation_gateway_log(created_at);

-- Seed capabilities
INSERT OR IGNORE INTO capability_evidence (capability_name, status, required_evidence, details) VALUES
  ('web_push', 'NOT_STARTED', 10, 'Web push notification delivery capability'),
  ('executive_brief', 'NOT_STARTED', 10, 'Executive brief generation and delivery'),
  ('auto_remediate', 'NOT_STARTED', 10, 'Autonomous remediation execution'),
  ('pattern_detect', 'NOT_STARTED', 10, 'Pattern detection and alerting'),
  ('sla_monitor', 'NOT_STARTED', 10, 'SLA monitoring and violation detection'),
  ('cost_track', 'NOT_STARTED', 10, 'Incident cost tracking'),
  ('knowledge_graph', 'NOT_STARTED', 10, 'Knowledge graph population'),
  ('health_agents', 'NOT_STARTED', 10, 'Agent health monitoring'),
  ('cron_reliability', 'NOT_STARTED', 10, 'Cron execution reliability tracking'),
  ('capability_cert', 'NOT_STARTED', 10, 'Capability certification evidence');
