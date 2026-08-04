-- Migration 021: Web push
CREATE TABLE IF NOT EXISTS push_subscriptions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  endpoint TEXT NOT NULL UNIQUE,
  p256dh TEXT,
  auth TEXT,
  user_agent TEXT,
  platform TEXT,
  device_name TEXT,
  is_active INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_push_active ON push_subscriptions(is_active);

CREATE TABLE IF NOT EXISTS push_deliveries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  subscription_id INTEGER NOT NULL,
  notification_id TEXT,
  status TEXT,
  result TEXT,
  sent_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_push_deliveries_sub ON push_deliveries(subscription_id);
