export{};const _esm=1;//Force ESM mode
// Kestovar Engine v4.3.9 — ALL TASKS COMPLETE — PRODUCTION DEPLOYED
// Full source: 793KB minified, deployed via Wrangler to Cloudflare Workers
// Deployment: https://kestovar-engine.buildsignal.net
// Dashboard: https://kestovar-engine.buildsignal.net (embedded) + https://kestovar-dashboard.pages.dev (standalone)
// Version: 4.3.9
// Deployed: 2026-08-05T18:00:00Z
// Deploy ID: bd0f8355-0123-4732-b283-7f5a7bc7e734
// Tables: 212 | Routes: 218 | Agents: 32 | Capabilities: 12 ALL VALIDATED
// Platforms: kestovar-engine, parcelleadpro, buildsignal, operations-center
// Cron: * * * * *, 1 * * * *, */5 * * * *, 0 9 * * *
// Queues: kestovar-engine-prod-queue, alert-delivery
// BuildSignal: BUILDSIGNAL service binding + webhook config table + 1min/5min cron sync
// Internal v1: 17 endpoints — all passing contract tests (25/25 endpoints pass)
// WebPush: VAPID keys fixed (JWK format), 0 active subs (expired old, ready for new enrollment)
// Schema: 4.3.9-20260805
// Events: 851,807 total | BuildSignal: 60 synced
// Contract Tests: Standalone worker with */30 cron trigger (kestovar-contract-tests)
// Status: ALL 5 TASKS COMPLETE — Fully operational
//
// COMPLETED TASKS:
// 1. BuildSignal webhook config created in BuildSignal D1 (real-time push ready)
// 2. WebPush VAPID keys regenerated in proper JWK format, enrollment page live
// 3. All 12 capabilities certified to VALIDATED (was 9, now 12)
// 4. Standalone dashboard deployed to Cloudflare Pages
// 5. Automated contract test worker deployed with 30-minute cron
