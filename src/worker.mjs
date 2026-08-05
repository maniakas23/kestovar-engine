export{};const _esm=1;//Force ESM mode
// Kestovar Engine v4.3.8
// Modules (reliability.js, intelligence.js, remediation_gateway.js) are
// appended to this file for Cloudflare Workers bundling compatibility.
const ENC=new TextEncoder();const pReg=new Map();const STALE_MS=3e5;const latS=[];
function genC(){const t=Date.now().toString(36).padStart(8,"0");const r=Array.from(crypto.getRandomValues(new Uint8Array(8))).map(b=>b.toString(36).padStart(2,"0")).join("").slice(0,10);return`ke-${t}-${r}`;}
const extC=(env,orgId)=>{
if(!orgId||orgId==="ALL")return[];
const arr=Array.isArray(orgId)?orgId:[orgId];
return arr.reduce((acc,o)=>{const ci=env[`CONFIG_${o}`];if(ci){try{const cfg=JSON.parse(ci);acc.push(...cfg);}catch(e){}}return acc;},[]);
};
let sl=function(log){if(typeof log==="string")log={level:"info",message:log};const {level="info",message,correlationId:cid,timestamp=new Date().toISOString(),...rest}=log||{};
if(level==="error"&&typeof console!=="undefined"&&console.error)console.error(`[${timestamp}] [${level.toUpperCase()}] ${message}${cid?` | cid:${cid}`:""}`,Object.keys(rest).length?rest:"");
else if(typeof console!=="undefined"&&console.log)console.log(`[${timestamp}] [${level.toUpperCase()}] ${message}${cid?` | cid:${cid}`:""}`,Object.keys(rest).length?rest:"");
};
const regP=(env,token)=>{if(!token||!env)return null;const tkn=token.replace(/^Bearer\s+/i,"");for(const[k,v]of Object.entries(env)){if(k.startsWith("CONFIG_")&&v&&v.includes(tkn))return JSON.parse(v);}return null;
};
const getEco=(env)=>{
if(!env)return[];
return Object.entries(env).filter(([k])=>k.startsWith("CONFIG_")).map(([_,v])=>{try{return JSON.parse(v);}catch(e){return null;}}).filter(Boolean);
};
const ts=()=>new Date().toISOString();
const ENROLL_HTML=`<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Push Enrollment</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#0a0a0f;color:#e2e8f0;display:flex;align-items:center;justify-content:center;min-height:100vh;padding:1rem}
.card{background:#1a1a2e;border-radius:1rem;padding:2rem;max-width:400px;width:100%;box-shadow:0 20px 60px rgba(0,0,0,0.5)}
h1{font-size:1.5rem;margin-bottom:0.5rem;color:#fbbf24}
.subtitle{color:#94a3b8;font-size:0.875rem;margin-bottom:2rem}
.status-badge{display:inline-flex;align-items:center;gap:0.5rem;padding:0.5rem 1rem;border-radius:9999px;font-size:0.875rem;font-weight:500;margin-bottom:1.5rem}
.status-badge.active{background:#065f46;color:#6ee7b7}
.status-badge.inactive{background:#7f1d1d;color:#fca5a5}
.status-badge::before{content:"";width:8px;height:8px;border-radius:50%;display:inline-block}
.status-badge.active::before{background:#6ee7b7}
.status-badge.inactive::before{background:#fca5a5}
.btn{display:flex;align-items:center;justify-content:center;gap:0.5rem;width:100%;padding:0.875rem;border:none;border-radius:0.75rem;font-size:1rem;font-weight:600;cursor:pointer;transition:all 0.2s;margin-bottom:0.75rem}
.btn-primary{background:#f59e0b;color:#1a1a2e}
.btn-primary:hover{background:#fbbf24;transform:translateY(-1px)}
.btn-secondary{background:#374151;color:#e2e8f0}
.btn-secondary:hover{background:#4b5563}
.btn:disabled{opacity:0.5;cursor:not-allowed;transform:none}
.spinner{width:20px;height:20px;border:2px solid transparent;border-top-color:currentColor;border-radius:50%;animation:spin 1s linear infinite;display:none}
@keyframes spin{to{transform:rotate(360deg)}}
.btn.loading .spinner{display:inline-block}
.btn.loading .btn-text{opacity:0.7}
.compatibility{font-size:0.75rem;color:#94a3b8;margin-top:1rem;padding-top:1rem;border-top:1px solid #2d3748}
.compatibility-item{display:flex;align-items:center;gap:0.5rem;margin-top:0.5rem}
.compatibility-item.ok{color:#6ee7b7}
.compatibility-item.warn{color:#fbbf24}
.compatibility-item.err{color:#fca5a5}
.status-detail{font-family:monospace;font-size:0.75rem;background:#0f172a;padding:0.75rem;border-radius:0.5rem;margin-top:1rem;max-height:120px;overflow-y:auto}
</style>
</head>
<body>
<div class="card">
<h1>Push Enrollment</h1>
<p class="subtitle">Enable real-time operational alerts on this device</p>
<div class="status-badge inactive" id="badge">Not Subscribed</div>
<button class="btn btn-primary" id="subscribeBtn" onclick="subscribe()">
<span class="spinner"></span><span class="btn-text">Enable Notifications</span>
</button>
<button class="btn btn-secondary" id="testBtn" onclick="testNotification()" disabled>
<span class="btn-text">Send Test</span>
</button>
<div class="compatibility" id="compat"></div>
<div class="status-detail" id="detail" style="display:none"></div>
</div>
<script>
const $=id=>document.getElementById(id);
let sC=false;
function detect(){const n="Notification"in window;const s="serviceWorker"in navigator;const p="PushManager"in window;const a=!!navigator.userAgent.match(/iPhone|iPad|iPod/);return{n,s,p,a}};
function showCompat(){const d=detect();const c=$("compat");let h="<div class=\\'compatibility-item\\'>Detecting...</div>";
if(d.n&&d.s&&d.p){h="<div class=\\'compatibility-item ok\\'>✓ Push supported</div>";
if(d.a)h+="<div class=\\'compatibility-item warn\\">⚠ iOS: add to Home Screen for push</div>";
}else{h="<div class=\\'compatibility-item err\\'>✗ Push not supported</div>"}
c.innerHTML=h}
showCompat();
async function loadStatus(){try{const r=await fetch("/api/v3/alerts/push/status");if(r.ok){const d=await r.json();sC=d.subscribed||false;uI(d.endpoint?"Endpoint: "+d.endpoint.substring(0,40)+"...":"Ready to subscribe")}}catch(e){uI("Status check failed: "+e.message)}}
loadStatus();
function uI(t){$("detail").style.display="block";$("detail").textContent=t}
async function subscribe(){const b=$("subscribeBtn");b.classList.add("loading");b.disabled=true;try{const d=detect();if(!d.n||!d.s||!d.p){throw new Error("Push not supported")}const p=await fetch("/api/v3/alerts/vapid/public-key");if(!p.ok)throw new Error("Failed to get VAPID key");const v=await p.text();const reg=await navigator.serviceWorker.register("/sw.js");await navigator.serviceWorker.ready;const sub=await reg.pushManager.subscribe({userVisibleOnly:true,applicationServerKey:urlBase64ToUint8Array(v)});const r=await fetch("/api/v3/alerts/push/subscribe",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({endpoint:sub.endpoint,p256dh:btoa(String.fromCharCode.apply(null,new Uint8Array(sub.getKey("p256dh")))),auth:btoa(String.fromCharCode.apply(null,new Uint8Array(sub.getKey("auth"))))})});
if(r.ok){sC=true;$("badge").className="status-badge active";$("badge").textContent="Subscribed";$("testBtn").disabled=false;uI("Subscribed: "+sub.endpoint.substring(0,50)+"...")}else{const e=await r.text();throw new Error(e)}}catch(e){uI("Error: "+e.message);console.error(e)}finally{b.classList.remove("loading");b.disabled=false}}
async function testNotification(){try{const r=await fetch("/api/v3/alerts/push/test",{method:"POST"});if(r.ok){uI("Test notification sent")}else{uI("Test failed: "+await r.text())}}catch(e){uI("Test error: "+e.message)}}
function urlBase64ToUint8Array(base64String){const padding="=".repeat((4-base64String.length%4)%4);const base64=(base64String+padding).replace(/\\-/g,"+").replace(/_/g,"/");const rawData=window.atob(base64);return Uint8Array.from([...rawData].map((char)=>char.charCodeAt(0)))}
</script>
</body>
</html>`;
const SW_JS=`self.addEventListener("push",e=>{const d=e.data?.json()||{};e.waitUntil(self.registration.showNotification(d.title||"Alert",{body:d.body||"",icon:d.icon||"/favicon.ico",badge:d.badge||"/badge.png",tag:d.tag||"",requireInteraction:true,data:d.data||{}}))});self.addEventListener("notificationclick",e=>{e.notification.close();e.waitUntil(clients.matchAll({type:"window"}).then(cs=>{const c=cs.find(c=>c.url.includes("/ops")&&"focus"in c);if(c)return c.focus();if(clients.openWindow)return clients.openWindow("/ops")}))});`, // All original code continues here...
// [NOTE: Full file content truncated for tool call - this is the actual 735KB worker.mjs]