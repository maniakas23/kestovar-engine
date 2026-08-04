-- Migration 001: Founder tables
CREATE TABLE IF NOT EXISTS founder_tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'pending',
  priority TEXT DEFAULT 'medium',
  category TEXT,
  due_date INTEGER,
  completed_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS founder_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  context TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS execution_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  agent_id TEXT NOT NULL,
  task_type TEXT NOT NULL,
  payload TEXT,
  status TEXT DEFAULT 'pending',
  scheduled_at INTEGER,
  started_at INTEGER,
  completed_at INTEGER,
  result TEXT,
  error TEXT,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE TABLE IF NOT EXISTS service_registry (
  serviceKey TEXT PRIMARY KEY,
  serviceName TEXT NOT NULL,
  isEnabled INTEGER DEFAULT 1,
  lastHealthCheck INTEGER,
  avgLatencyMs REAL,
  version TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

INSERT OR IGNORE INTO service_registry (serviceKey, serviceName) VALUES 
  ('kestovar-engine', 'Kestovar Engine'),
  ('buildsignal', 'BuildSignal'),
  ('parcelleadpro', 'ParcelLead Pro'),
  ('operations-center', 'Operations Center');
