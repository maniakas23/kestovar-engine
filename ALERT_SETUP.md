# Twilio SMS Alert Setup Guide

This guide walks you through setting up SMS alerts for critical incidents in kestovar-engine.

## Prerequisites

- A Twilio account (free trial: https://www.twilio.com/try-twilio)
- Python 3.8+
- pip

## Step 1: Get Your Twilio Credentials

1. Sign up at https://www.twilio.com/try-twilio
2. Go to **Account Info** in your Twilio Console
3. Copy your **Account SID** (format: ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)
4. Copy your **Auth Token** from the Console
5. Go to **Phone Numbers** and note your **Twilio Phone Number** (starts with +1)

## Step 2: Configure Environment Variables

### Option A: Using .env file (Development)

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and fill in your credentials:
   ```
   TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   TWILIO_AUTH_TOKEN=your_auth_token_here
   TWILIO_PHONE_NUMBER=+1234567890
   MY_PHONE_NUMBER=+1987654321
   ```

### Option B: Using GitHub Secrets (Production/CI-CD)

1. Go to your repository: **Settings → Secrets and variables → Actions**
2. Add these secrets:
   - `TWILIO_ACCOUNT_SID`: (your Account SID from Twilio Console)
   - `TWILIO_AUTH_TOKEN`: (your Auth Token from Twilio Console)
   - `TWILIO_PHONE_NUMBER`: (your Twilio phone number)
   - `MY_PHONE_NUMBER`: (your personal phone number)

3. Use in workflows:
   ```yaml
   env:
     TWILIO_ACCOUNT_SID: ${{ secrets.TWILIO_ACCOUNT_SID }}
     TWILIO_AUTH_TOKEN: ${{ secrets.TWILIO_AUTH_TOKEN }}
     TWILIO_PHONE_NUMBER: ${{ secrets.TWILIO_PHONE_NUMBER }}
     MY_PHONE_NUMBER: ${{ secrets.MY_PHONE_NUMBER }}
   ```

## Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

## Step 4: Usage Examples

### Basic Usage

```python
from alerts import AlertDispatcher

# Initialize dispatcher
dispatcher = AlertDispatcher()

# Send a fix-required alert
dispatcher.dispatch_fix_required(
    issue="Database connection pool exhausted",
    service="auth-service",
    severity_score=9
)

# Send a lockdown alert
dispatcher.dispatch_site_lockdown(
    reason="Unauthorized access attempts detected in payment processing"
)
```

### Direct SMS Handler Usage

```python
from alerts import TwilioAlertHandler

handler = TwilioAlertHandler()

# Send alert with custom formatting
handler.send_critical_alert(
    alert_description="Memory usage at 95% on production server",
    action="fix",
    additional_info={
        "service": "api-gateway",
        "severity_score": 8
    }
)
```

### Batch Alerts

```python
from alerts import TwilioAlertHandler

handler = TwilioAlertHandler()

alerts = [
    {
        "description": "Database replication lag > 5 minutes",
        "action": "fix",
        "additional_info": {"service": "db", "severity_score": 8}
    },
    {
        "description": "DDoS attack detected on API endpoints",
        "action": "lockdown",
        "additional_info": {"severity_score": 10}
    }
]

results = handler.send_batch_alerts(alerts)
print(results)  # {"success": 2, "failed": 0}
```

## Alert Message Format

All SMS alerts follow this format:

```
CRITICAL: <alert description> [FIX REQUIRED|LOCKDOWN SITE] - <timestamp> | Service: <service> | Severity: <score>/10
```

### Examples:

**Fix Required:**
```
CRITICAL: Database connection pool exhausted [FIX REQUIRED] - 2026-07-25T14:30:45.123456Z | Service: auth-service | Severity: 9/10
```

**Lockdown:**
```
CRITICAL: Unauthorized access attempts detected in payment processing [LOCKDOWN SITE] - 2026-07-25T14:30:45.123456Z | Severity: 10/10
```

## Integration Points

### 1. Health Check Monitoring
```python
def health_check():
    dispatcher = AlertDispatcher()
    
    if cpu_usage > 90:
        dispatcher.dispatch_critical_alert(
            "CPU usage critical",
            service="server-01",
            severity_score=9
        )
```

### 2. Error Logging
```python
import logging
from alerts import AlertDispatcher

class AlertingHandler(logging.Handler):
    def emit(self, record):
        if record.levelno >= logging.CRITICAL:
            dispatcher = AlertDispatcher()
            dispatcher.dispatch_critical_alert(
                alert_description=record.getMessage(),
                service=record.name
            )
```

### 3. Webhook Receivers
```python
from flask import Flask, request
from alerts import AlertDispatcher

app = Flask(__name__)
dispatcher = AlertDispatcher()

@app.route('/webhook/alerts', methods=['POST'])
def receive_alert():
    data = request.json
    
    if data.get('severity') == 'critical':
        dispatcher.dispatch_critical_alert(
            alert_description=data.get('message'),
            action=data.get('action', 'fix'),
            service=data.get('service')
        )
    
    return {'status': 'received'}, 200
```

## Testing

Test your SMS configuration:

```python
from alerts import TwilioAlertHandler

handler = TwilioAlertHandler()

# Send a test alert
success = handler.send_critical_alert(
    alert_description="Test alert from kestovar-engine",
    action="fix"
)

if success:
    print("✓ SMS alert sent successfully!")
else:
    print("✗ Failed to send SMS alert")
```

## Troubleshooting

### "Missing Twilio configuration" Error
- Verify all four environment variables are set
- Check for typos in variable names (case-sensitive)
- Ensure `.env` file is in the correct location

### "Authentication failed" Error
- Double-check Account SID and Auth Token from Twilio Console
- Regenerate Auth Token if needed in Twilio Console
- Wait 30 seconds after regenerating token

### "Invalid recipient phone number" Error
- Ensure phone numbers are in E.164 format: +[country code][number]
- Example: +14155552671 for US numbers
- Make sure phone number verification is complete in Twilio

### SMS Not Received
- Check that your Twilio account has sufficient credits (free trial: $15 credit)
- Verify recipient phone number is correct
- Check Twilio Message Logs in Console

### SMS Sent But Taking Time
- Twilio SMS typically delivers within 1-5 seconds
- Check network connectivity
- Verify phone number is active and can receive SMS

## Rate Limiting

To avoid SMS spam, consider implementing rate limiting:

```python
from datetime import datetime, timedelta

class RateLimitedDispatcher(AlertDispatcher):
    def __init__(self):
        super().__init__()
        self.last_alert_time = None
        self.min_interval = timedelta(minutes=5)  # Min 5 min between alerts
    
    def dispatch_critical_alert(self, alert_description, **kwargs):
        now = datetime.utcnow()
        
        if self.last_alert_time and (now - self.last_alert_time) < self.min_interval:
            logger.warning(f"Alert rate limited: {alert_description}")
            return False
        
        self.last_alert_time = now
        return super().dispatch_critical_alert(alert_description, **kwargs)
```

## Security Best Practices

1. **Never commit credentials** - Always use environment variables
2. **Rotate Auth Tokens** - Regenerate tokens regularly in Twilio Console
3. **Use GitHub Secrets** - For production deployments
4. **Minimize permissions** - Use read-only API keys where possible
5. **Monitor usage** - Check Twilio logs for suspicious activity
6. **Rate limit** - Prevent alert fatigue and cost spikes

## Cost Considerations

- **Twilio Free Trial**: $15 credit (typically ~30-50 SMS)
- **Production**: ~$0.01-0.02 per SMS depending on region
- Set up billing alerts in Twilio Console to monitor usage

## Next Steps

1. ✅ Add your Auth Token to `.env` or GitHub Secrets
2. ✅ Add your phone numbers (TWILIO_PHONE_NUMBER and MY_PHONE_NUMBER)
3. ✅ Install dependencies: `pip install -r requirements.txt`
4. ✅ Test the configuration using the examples above
5. ✅ Integrate alerts into your monitoring and error handling

## Support

- Twilio Docs: https://www.twilio.com/docs
- Kestovar Issues: https://github.com/maniakas23/kestovar-engine/issues
