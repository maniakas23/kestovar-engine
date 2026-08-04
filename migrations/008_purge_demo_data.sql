-- Migration 008: Purge demo data
DELETE FROM events WHERE orgId = 0;
DELETE FROM provider_runs WHERE orgId = 0;
