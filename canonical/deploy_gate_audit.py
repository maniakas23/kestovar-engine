#!/usr/bin/env python3
"""KESTOVAR PERMANENT DEPLOYMENT GATE — pre-promotion audit (fail-closed).
NO CANONICAL SOURCE + VERIFIED BINDING MANIFEST = NO PRODUCTION PROMOTION.
Usage: CF_API_TOKEN=... python3 deploy_gate_audit.py <account_id> <worker> <version_id>
Exit 0 = PASS (promotion allowed). Exit 1 = FAIL (do not promote)."""
import json, os, sys, urllib.request

REQUIRED_SECRETS = ["APP_SECRET", "VAPID_PRIVATE_KEY", "VAPID_PUBLIC_KEY"]
REQUIRED_BINDINGS = {  # name -> (type, expected target or None)
    "DB": ("d1", "792a09ee-9729-4d91-a0c8-ff7574e90a11"),
    "PROD_QUEUE": ("queue", "kestovar-engine-prod-queue"),
    "ALERT_QUEUE": ("queue", "alert-delivery"),
    "BUILDSIGNAL": ("service", "buildsignal-worker"),
    "ALLOWED_ORIGINS": ("plain_text", None),
    "BUILDSIGNAL_API_URL": ("plain_text", None),
}
REQUIRED_COMPAT = "2026-08-06"
REQUIRED_HANDLERS = {"fetch", "scheduled", "queue"}
FORBIDDEN_IDS = ["01037e50-b09c-4bac-ac28-7fdc9f536413"]

def main():
    acc, worker, vid = sys.argv[1], sys.argv[2], sys.argv[3]
    tok = os.environ["CF_API_TOKEN"]
    req = urllib.request.Request(
        f"https://api.cloudflare.com/client/v4/accounts/{acc}/workers/scripts/{worker}/versions/{vid}/content")
    req.add_header("Authorization", f"Bearer {tok}")
    r = json.loads(urllib.request.urlopen(req).read())["result"]
    fails = []
    bindings = {b["name"]: b for b in r["resources"]["bindings"]}
    blob = json.dumps(r)
    for fid in FORBIDDEN_IDS:
        if fid in blob: fails.append(f"FORBIDDEN deleted resource referenced: {fid}")
    for name, (btype, target) in REQUIRED_BINDINGS.items():
        b = bindings.get(name)
        if not b or b["type"] != btype: fails.append(f"binding {name} missing/wrong type"); continue
        if target:
            actual = b.get("database_id") or b.get("queue_name") or b.get("service")
            if actual != target: fails.append(f"binding {name} target {actual} != {target}")
    for name in REQUIRED_SECRETS:
        b = bindings.get(name)
        if not b or b["type"] != "secret_text": fails.append(f"required secret {name} missing or not secret_text")
    if r["resources"]["script_runtime"]["compatibility_date"] != REQUIRED_COMPAT:
        fails.append("compatibility date drift")
    if set(r["resources"]["script"]["handlers"]) != REQUIRED_HANDLERS:
        fails.append("handler drift")
    if fails:
        print("GATE: FAIL-CLOSED"); [print(" -", f) for f in fails]; sys.exit(1)
    print("GATE: PASS — version", vid, "cleared for promotion review"); sys.exit(0)

if __name__ == "__main__":
    main()
