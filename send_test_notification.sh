#!/bin/bash

# Script to send test notification to iOS Simulator
# Usage: ./send_test_notification.sh

BUNDLE_ID="com.example.notificationapp"
NOTIFICATION_FILE="test_notification.json"

echo "Sending test notification to iOS Simulator..."
echo "Bundle ID: $BUNDLE_ID"
echo "Notification file: $NOTIFICATION_FILE"

if [ ! -f "$NOTIFICATION_FILE" ]; then
    echo "Error: $NOTIFICATION_FILE not found!"
    echo "Make sure you're running this from the project directory."
    exit 1
fi

# Check if simulator is running
if ! xcrun simctl list devices | grep -q "Booted"; then
    echo "Error: No iOS Simulator is currently running."
    echo "Please start the iOS Simulator first."
    exit 1
fi

# Send the notification
xcrun simctl push booted "$BUNDLE_ID" "$NOTIFICATION_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Test notification sent successfully!"
    echo ""
    echo "What to do next:"
    echo "1. If the app is running, you should see the notification"
    echo "2. If the app is closed, tap the notification to open it"
    echo "3. Check that the app displays the notification content"
else
    echo "❌ Failed to send notification"
    echo ""
    echo "Troubleshooting:"
    echo "- Make sure the app is installed in the simulator"
    echo "- Verify the bundle ID matches: $BUNDLE_ID"
    echo "- Check that notifications are enabled for the app"
fi