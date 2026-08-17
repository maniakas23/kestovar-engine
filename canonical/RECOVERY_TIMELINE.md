# KESTOVAR ENGINE — RECOVERY INCIDENT TIMELINE (2026-08-17, UTC)
- Pre-incident: v401 (b738a414, v5.2.0) serving since 2026-08-06; D1 binding DB -> 01037e50 (legacy signalcore-engine-db)
- 2026-08-09 22:18: v402 (68e7b3cd) uploaded with ZERO bindings; 22:26 rolled back to v401 (deployment a83557a3)
- Unknown date: legacy D1 01037e50 deleted -> v401 data routes 503 "Migrations not applied"; ~45% invocation failures
- 08-17 ~09:00: root cause proven to version level (v401 binding -> deleted UUID); correct DB kestovar-engine-db 792a09ee verified healthy (~408MB, 270 tables)
- 08-17 ~10:00: script-body download blocked token-wide (10405); wrangler has no download; founder dashboard editor identified as only source
- 08-17 ~11:15: founder captured exact editor content x3 (byte-identical, SHA-256 64abf655...); etag mismatch explained (CF etags != raw-script SHA-256, proven empirically)
- 08-17 11:43: staged v403 9416d712 created (wrangler 4.34 versions upload, 0% traffic); health healthy; D1 PASS; secrets NOT inherited (APP_SECRET_NOT_CONFIGURED)
- 08-17 12:06: staged v404 91601057 (wrangler 4.80) - same result; API inheritance probe rejected (10021)
- 08-17 12:30: founder dashboard save v405 d5f505d0 (DB rebound); promoted to 100% - D1 outage ended; ready=false (secrets)
- 08-17 12:53-13:00: founder added 4 secret names as EMPTY plain_text placeholders; APP_SECRET converted to secret via wrangler
- 08-17 13:05-13:08: clean rebuild chain: fresh upload d5e8aaac + 3 sequential version-secret puts (APP_SECRET rotated 64B, VAPID P-256 matched pair rotated); webhook secret intentionally absent (sender signs nothing); final staged 6732f44d: ready=true, auth fail-closed, 404 router clean
- 08-17 13:23:55: PROMOTED 6732f44d @100% (deployment e19485e6) with founder approval
- Post: 0% error rate 15m/1h/6h; 24h 21.9% = HISTORICAL_PRE_REPAIR; PLP 12/12 agents green; BS healthy
## Rollback points
- v405 d5f505d0 (same code, correct D1, no secrets) - safe
- v401 b738a414 - FORBIDDEN (deleted-D1 outage); guarded in deploy_gate_audit.py FORBIDDEN_IDS
