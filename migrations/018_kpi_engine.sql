-- Migration 018: KPI engine
CREATE TABLE IF NOT EXISTS kpi_snapshots (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  service TEXT,
  metric_type TEXT,
  metric_value REAL,
  recorded_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_kpi_service ON kpi_snapshots(service, metric_type);
CREATE INDEX IF NOT EXISTS idx_kpi_recorded ON kpi_snapshots(recorded_at);
