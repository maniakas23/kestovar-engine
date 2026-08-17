# CANONICAL SOURCE — kestovar-engine v5.2.0 (post-recovery)

Recovered production artifact, byte-preserved. SHA-256: 64abf655369844f386d3cdedd493841098263e1af92b6f9e9c186bce3c2d1e04

- Serving version: 6732f44d-477c-46c3-ad9b-468e4077ebd7 (deployment e19485e6-9a3c-432f-b484-7b85a9698233, promoted 2026-08-17T13:23:55Z @100%)
- D1 binding DB -> kestovar-engine-db 792a09ee-9729-4d91-a0c8-ff7574e90a11
- Secrets (names only, values write-only): APP_SECRET, VAPID_PRIVATE_KEY, VAPID_PUBLIC_KEY
- BUILDSIGNAL_WEBHOOK_SECRET intentionally absent (sender does not sign; intake stays fail-closed)
- Rollback: never restore v401 b738a414 (deleted D1 binding 01037e50)
- Deployment gate: no canonical source + verified binding manifest = no production promotion
