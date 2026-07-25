"""
Twilio SMS Alert Handler for Kestovar Engine
Sends critical alerts via SMS with action recommendations
"""

import os
import logging
from typing import Optional, Dict, Any
from twilio.rest import Client
from datetime import datetime

logger = logging.getLogger(__name__)


class TwilioAlertHandler:
    """Handle SMS notifications for critical alerts"""
    
    def __init__(self):
        """Initialize Twilio client with credentials from environment"""
        self.account_sid = os.getenv('TWILIO_ACCOUNT_SID')
        self.auth_token = os.getenv('TWILIO_AUTH_TOKEN')
        self.from_number = os.getenv('TWILIO_PHONE_NUMBER')
        self.to_number = os.getenv('MY_PHONE_NUMBER')
        
        if not all([self.account_sid, self.auth_token, self.from_number, self.to_number]):
            raise ValueError(
                "Missing Twilio configuration. Set: "
                "TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, "
                "TWILIO_PHONE_NUMBER, MY_PHONE_NUMBER"
            )
        
        self.client = Client(self.account_sid, self.auth_token)
    
    def send_critical_alert(
        self, 
        alert_description: str,
        action: str = "fix",
        additional_info: Optional[Dict[str, Any]] = None
    ) -> bool:
        """
        Send a critical alert via SMS
        
        Args:
            alert_description: Description of the critical issue
            action: Action to take - "fix" or "lockdown" (default: "fix")
            additional_info: Optional dict with context (service, timestamp, etc.)
        
        Returns:
            bool: True if message sent successfully, False otherwise
        """
        try:
            # Format the SMS message
            message_body = f"CRITICAL: {alert_description}"
            
            # Add action indicator
            if action.lower() == "lockdown":
                message_body += " [LOCKDOWN SITE]"
            else:
                message_body += " [FIX REQUIRED]"
            
            # Add timestamp
            message_body += f" - {datetime.utcnow().isoformat()}Z"
            
            # Add additional context if provided
            if additional_info:
                if "service" in additional_info:
                    message_body += f" | Service: {additional_info['service']}"
                if "severity_score" in additional_info:
                    message_body += f" | Severity: {additional_info['severity_score']}/10"
            
            logger.info(f"Sending SMS alert to {self.to_number}: {message_body}")
            
            # Send via Twilio
            message = self.client.messages.create(
                body=message_body,
                from_=self.from_number,
                to=self.to_number
            )
            
            logger.info(f"Alert sent successfully. Message SID: {message.sid}")
            return True
            
        except Exception as e:
            logger.error(f"Failed to send SMS alert: {str(e)}")
            return False
    
    def send_batch_alerts(self, alerts: list) -> Dict[str, int]:
        """
        Send multiple critical alerts
        
        Args:
            alerts: List of dicts with keys: description, action (optional)
        
        Returns:
            Dict with counts of successful and failed sends
        """
        results = {"success": 0, "failed": 0}
        
        for alert in alerts:
            description = alert.get("description", "Unknown alert")
            action = alert.get("action", "fix")
            additional_info = alert.get("additional_info")
            
            if self.send_critical_alert(description, action, additional_info):
                results["success"] += 1
            else:
                results["failed"] += 1
        
        logger.info(f"Batch alert results: {results}")
        return results
