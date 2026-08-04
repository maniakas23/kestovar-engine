-- Migration 007: Approval workflow
CREATE TABLE IF NOT EXISTS approval_requests (
  id TEXT PRIMARY KEY,
  requestType TEXT NOT NULL,
  requestedBy TEXT NOT NULL,
  approver TEXT,
  title TEXT,
  description TEXT,
  status TEXT DEFAULT 'pending',
  autoApproveAt INTEGER,
  approvedAt INTEGER,
  rejectedAt INTEGER,
  rejectionReason TEXT,
  escalationLevel INTEGER DEFAULT 0,
  metadata TEXT,
  createdAt INTEGER DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_approvals_status ON approval_requests(status);
CREATE INDEX IF NOT EXISTS idx_approvals_escalation ON approval_requests(escalationLevel, status);
