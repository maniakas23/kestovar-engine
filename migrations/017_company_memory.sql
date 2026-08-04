-- Migration 017: Company memory
CREATE TABLE IF NOT EXISTS company_memory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_type TEXT,
  event_id TEXT,
  source TEXT,
  platform TEXT,
  title TEXT,
  content TEXT,
  tags TEXT,
  importance INTEGER DEFAULT 50,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_company_memory_type ON company_memory(event_type);
CREATE INDEX IF NOT EXISTS idx_company_memory_platform ON company_memory(platform);
