-- Migration 016: Autonomous learning
CREATE TABLE IF NOT EXISTS autonomous_learning (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  trigger_type TEXT,
  trigger_id TEXT,
  action_taken TEXT,
  outcome TEXT,
  confidence INTEGER DEFAULT 70,
  approved INTEGER DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_autonomous_learning_trigger ON autonomous_learning(trigger_type, trigger_id);
