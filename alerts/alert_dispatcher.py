"""
Alert Dispatcher - Routes critical alerts to SMS handler
"""

import logging
from typing import Optional, Dict, Any
from alerts.twilio_handler import TwilioAlertHandler

logger = logging.getLogger(__name__)


class AlertDispatcher:
    """Dispatcher for routing alerts based on severity"""
    
    def __init__(self):
        """Initialize alert dispatcher with SMS handler"""
        try:
            self.sms_handler = TwilioAlertHandler()
            self.sms_enabled = True
            logger.info("SMS alert handler initialized successfully")
        except ValueError as e:
            logger.warning(f"SMS alerts disabled: {str(e)}")
            self.sms_enabled = False
    
    def dispatch_critical_alert(
        self,
        alert_description: str,
        action: str = "fix",
        service: Optional[str] = None,
        severity_score: Optional[int] = None
    ) -> bool:
        """
        Dispatch a critical alert
        
        Args:
            alert_description: What happened
            action: "fix" to start fixing, "lockdown" to lockdown site
            service: Which service/component triggered the alert
            severity_score: 1-10 severity rating
        
        Returns:
            bool: True if alert was sent successfully
        """
        if not self.sms_enabled:
            logger.error(f"SMS alerts disabled. Alert not sent: {alert_description}")
            return False
        
        additional_info = {}
        if service:
            additional_info["service"] = service
        if severity_score:
            additional_info["severity_score"] = severity_score
        
        return self.sms_handler.send_critical_alert(
            alert_description=alert_description,
            action=action,
            additional_info=additional_info
        )
    
    def dispatch_site_lockdown(self, reason: str) -> bool:
        """
        Dispatch a site lockdown alert
        
        Args:
            reason: Why the site is being locked down
        
        Returns:
            bool: True if alert was sent successfully
        """
        return self.dispatch_critical_alert(
            alert_description=reason,
            action="lockdown",
            severity_score=10
        )
    
    def dispatch_fix_required(
        self, 
        issue: str, 
        service: str,
        severity_score: int = 9
    ) -> bool:
        """
        Dispatch a fix-required alert
        
        Args:
            issue: What needs to be fixed
            service: Which service has the issue
            severity_score: Severity level (default: 9)
        
        Returns:
            bool: True if alert was sent successfully
        """
        return self.dispatch_critical_alert(
            alert_description=issue,
            action="fix",
            service=service,
            severity_score=severity_score
        )
