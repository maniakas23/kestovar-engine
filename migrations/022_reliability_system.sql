-- Migration 022: Reliability system
CREATE TABLE IF NOT EXISTS reliability_incidents (
  id TEXT PRIMARY KEY,
  severity TEXT NOT NULL,
  service TEXT NOT NULL,
  affectedProducts TEXT,
  title TEXT NOT NULL,
  description TEXT,
  detectedAt INTEGER,
  likelyCause TEXT,
  confidence INTEGER DEFAULT 70,
  recommendedAction TEXT,
  status TEXT DEFAULT 'open',
  playbookId TEXT,
  remediationAttempts INTEGER DEFAULT 0,
  verifiedAt INTEGER,
  closedAt INTEGER,
  correlationId TEXT,
  createdBy TEXT,
  mttr_seconds INTEGER,
  root_cause TEXT,
  learning_applied INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_reliability_service ON reliability_incidents(service, status);
CREATE INDEX IF NOT EXISTS idx_reliability_detected ON reliability_incidents(detectedAt);
CREATE INDEX IF NOT EXISTS idx_reliability_status ON reliability_incidents(status);

CREATE TABLE IF NOT EXISTS anomaly_detections (
  id TEXT PRIMARY KEY,
  service TEXT NOT NULL,
  metric_type TEXT,
  current_value REAL,
  expected_value REAL,
  deviation_sigma REAL,
  severity TEXT DEFAULT 'warning',
  status TEXT DEFAULT 'open',
  detected_at INTEGER DEFAULT (unixepoch()),
  resolved_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_anomalies_service ON anomaly_detections(service, status);
CREATE INDEX IF NOT EXISTS idx_anomalies_detected ON anomaly_detections(detected_at);

CREATE TABLE IF NOT EXISTS smoke_tests (
  id TEXT PRIMARY KEY,
  service TEXT NOT NULL,
  version TEXT,
  test_type TEXT,
  result TEXT DEFAULT 'pending',
  executed_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_smoke_service ON smoke_tests(service, executed_at);

CREATE TABLE IF NOT EXISTS post_incident_reviews (
  id TEXT PRIMARY KEY,
  incident_id TEXT NOT NULL UNIQUE,
  root_cause TEXT,
  mttr_seconds INTEGER,
  severity TEXT,
  status TEXT DEFAULT 'pending',
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_pir_incident ON post_incident_reviews(incident_id);

CREATE TABLE IF NOT EXISTS security_findings (
  id TEXT PRIMARY KEY,
  service TEXT,
  finding_type TEXT,
  severity TEXT DEFAULT 'medium',
  status TEXT DEFAULT 'open',
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_security_status ON security_findings(status);

CREATE TABLE IF NOT EXISTS service_dependencies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  source_service TEXT NOT NULL,
  target_service TEXT NOT NULL,
  dependency_type TEXT,
  strength REAL DEFAULT 1.0,
  last_verified_at INTEGER,
  UNIQUE(source_service, target_service)
);

CREATE INDEX IF NOT EXISTS idx_deps_source ON service_dependencies(source_service);
CREATE INDEX IF NOT EXISTS idx_deps_target ON service_dependencies(target_service);

CREATE TABLE IF NOT EXISTS service_correlations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  primary_service TEXT NOT NULL,
  correlated_services TEXT,
  correlation_score REAL DEFAULT 0,
  common_patterns TEXT,
  root_cause_guess TEXT,
  status TEXT DEFAULT 'active',
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_correlations_primary ON service_correlations(primary_service);

CREATE TABLE IF NOT EXISTS predictions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service TEXT,
  predicted_incident_type TEXT,
  confidence REAL DEFAULT 0,
  trigger_metrics TEXT,
  actual_incident_id TEXT,
  status TEXT DEFAULT 'active',
  created_at INTEGER DEFAULT (unixepoch()),
  resolved_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_predictions_service ON predictions(service, status);

CREATE TABLE IF NOT EXISTS circuit_states (
  name TEXT PRIMARY KEY,
  state TEXT DEFAULT 'closed',
  failures INTEGER DEFAULT 0,
  last_failure INTEGER,
  success_count INTEGER DEFAULT 0,
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS escalation_chains (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  steps TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS oncall_rotations (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  members TEXT,
  current_index INTEGER DEFAULT 0,
  schedule TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);
