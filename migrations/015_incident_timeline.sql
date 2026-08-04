-- Migration 015: Incident timeline
CREATE TABLE IF NOT EXISTS incident_timeline (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT NOT NULL,
  phase TEXT,
  description TEXT,
  actor TEXT,
  severity TEXT,
  metadata TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_timeline_incident ON incident_timeline(incident_id);
