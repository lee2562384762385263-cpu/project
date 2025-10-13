#!/usr/bin/env python3
"""
Test notification sender for NotificationApp
This script helps send test notifications to verify the app functionality.
"""

import json
import subprocess
import sys
import argparse
from datetime import datetime

def send_android_notification(title, body, data=None):
    """Send a test notification to Android device via ADB"""
    if data is None:
        data = {}
    
    # Add timestamp to data
    data['timestamp'] = datetime.now().isoformat()
    data['source'] = 'test_script'
    
    data_json = json.dumps(data)
    
    cmd = [
        'adb', 'shell', 'am', 'broadcast',
        '-a', 'com.example.notificationapp.TEST_NOTIFICATION',
        '--es', 'title', title,
        '--es', 'body', body,
        '--es', 'data', data_json
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✓ Notification sent successfully to Android device")
            print(f"  Title: {title}")
            print(f"  Body: {body}")
            print(f"  Data: {data_json}")
        else:
            print(f"✗ Failed to send notification: {result.stderr}")
    except FileNotFoundError:
        print("✗ ADB not found. Make sure Android SDK is installed and ADB is in PATH")

def create_ios_payload(title, body, data=None):
    """Create iOS push notification payload"""
    if data is None:
        data = {}
    
    # Add timestamp to data
    data['timestamp'] = datetime.now().isoformat()
    data['source'] = 'test_script'
    
    payload = {
        "aps": {
            "alert": {
                "title": title,
                "body": body
            },
            "sound": "default",
            "badge": 1
        }
    }
    
    # Add custom data
    payload.update(data)
    
    return json.dumps(payload, indent=2)

def main():
    parser = argparse.ArgumentParser(description='Send test notifications to NotificationApp')
    parser.add_argument('platform', choices=['android', 'ios'], help='Target platform')
    parser.add_argument('--title', default='Test Notification', help='Notification title')
    parser.add_argument('--body', default='This is a test notification from the test script', help='Notification body')
    parser.add_argument('--data', help='Additional JSON data to include')
    
    args = parser.parse_args()
    
    # Parse additional data if provided
    additional_data = {}
    if args.data:
        try:
            additional_data = json.loads(args.data)
        except json.JSONDecodeError:
            print(f"✗ Invalid JSON data: {args.data}")
            return 1
    
    if args.platform == 'android':
        send_android_notification(args.title, args.body, additional_data)
    elif args.platform == 'ios':
        payload = create_ios_payload(args.title, args.body, additional_data)
        print("iOS Push Notification Payload:")
        print("=" * 40)
        print(payload)
        print("=" * 40)
        print("\nTo send this notification:")
        print("1. Use a push notification service like Firebase Cloud Messaging")
        print("2. Or use a tool like 'pusher' or 'apn' command line tools")
        print("3. Send the above payload to your device's push token")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())