-- Migration 019: Executive briefs
CREATE TABLE IF NOT EXISTS executive_briefs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  type TEXT NOT NULL,
  date TEXT NOT NULL,
  title TEXT,
  summary TEXT,
  key_metrics TEXT,
  incidents TEXT,
  actions TEXT,
  status TEXT DEFAULT 'draft',
  sent_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_briefs_type_date ON executive_briefs(type, date);

CREATE TABLE IF NOT EXISTS executive_brief_recipients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  brief_id INTEGER NOT NULL,
  channel TEXT,
  destination TEXT,
  status TEXT DEFAULT 'pending',
  delivered_at INTEGER,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_brief_recipients ON executive_brief_recipients(brief_id);
