-- Migration 013: Notification center
CREATE TABLE IF NOT EXISTS notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  incident_id TEXT,
  source TEXT,
  source_id TEXT,
  severity TEXT,
  category TEXT,
  title TEXT NOT NULL,
  body TEXT,
  status TEXT DEFAULT 'pending',
  channels TEXT,
  delivered_at INTEGER,
  acknowledged_at INTEGER,
  acknowledged_by TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_incident ON notifications(incident_id);

CREATE TABLE IF NOT EXISTS notification_channels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  channel_type TEXT NOT NULL,
  config TEXT,
  is_enabled INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);
