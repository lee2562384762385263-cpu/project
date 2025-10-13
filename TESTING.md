# Testing Guide for Notification App

This guide explains how to test the notification functionality on both Android and iOS platforms.

## Prerequisites

- Qt 6.8.2 or later installed
- For Android: Android SDK, NDK, and a physical device or emulator
- For iOS: Xcode, iOS SDK, and a physical device (notifications don't work in simulator)

## Building the App

### Desktop (for initial testing)
```bash
./build.sh desktop
```

### Android
```bash
export ANDROID_NDK=/path/to/android-ndk
export QT_ANDROID_PATH=/path/to/qt/android
./build.sh android
```

### iOS
```bash
./build.sh ios
```

## Testing Scenarios

### 1. Basic App Launch
1. Build and install the app on your device
2. Launch the app
3. Verify the UI displays correctly with all sections visible
4. Test the "Simulate Test Notification" button to verify the UI updates

### 2. Permission Request
1. Tap "Request Permission" button
2. Grant notification permission when prompted
3. Verify the status text updates to show permission granted

### 3. Foreground Notifications (Android)
1. With the app open and permission granted
2. Send a test notification using ADB:
   ```bash
   adb shell am broadcast -a com.example.notificationapp.TEST_NOTIFICATION \
       --es title "Test Title" \
       --es body "Test Body" \
       --es data '{"key":"value"}'
   ```
3. Verify the notification appears and the app UI updates

### 4. Background Notification Handling
1. Ensure the app has notification permission
2. Close the app completely (remove from recent apps)
3. Send a notification to the device (via push service or test method)
4. Tap the notification
5. Verify the app opens and displays the notification content

### 5. App Launch from Terminated State
This is the main feature being tested:

#### Android Testing
1. Install the app and grant notification permission
2. Close the app completely
3. Send a notification using a test service or ADB command
4. Tap the notification in the notification panel
5. The app should launch and display:
   - "App opened from notification!" status
   - The notification title and body
   - Any additional data from the notification

#### iOS Testing
1. Install the app and grant notification permission
2. Close the app completely (double-tap home button and swipe up)
3. Send a push notification to the device
4. Tap the notification
5. The app should launch and display the notification content

## Test Notification Formats

### Android Intent Extras
```
notification_title: "Your Title Here"
notification_body: "Your message body here"
notification_data: '{"custom_key": "custom_value", "timestamp": "2023-10-13T10:00:00Z"}'
```

### iOS Push Notification Payload
```json
{
  "aps": {
    "alert": {
      "title": "Your Title Here",
      "body": "Your message body here"
    },
    "sound": "default"
  },
  "custom_key": "custom_value",
  "timestamp": "2023-10-13T10:00:00Z"
}
```

## Debugging

### Android Debugging
1. Use `adb logcat` to view debug output:
   ```bash
   adb logcat | grep NotificationApp
   ```

2. Check if the app receives the intent:
   ```bash
   adb logcat | grep "NOTIFICATION_CLICKED"
   ```

### iOS Debugging
1. Use Xcode's device console to view debug output
2. Look for NSLog messages from the notification handlers

### Common Issues

1. **Permissions not granted**: Ensure notification permissions are granted in device settings
2. **App not launching from notification**: Check that the notification intent/payload includes the correct data
3. **Data not displaying**: Verify the JSON parsing is working correctly
4. **iOS simulator**: Notifications don't work in iOS simulator, use a physical device

## Manual Testing Checklist

- [ ] App builds successfully for target platform
- [ ] App launches and displays UI correctly
- [ ] Permission request works and updates status
- [ ] Simulate test notification button works
- [ ] App can receive notifications while in foreground
- [ ] App can be launched from notification when terminated
- [ ] Notification content is correctly parsed and displayed
- [ ] Clear notification data button works
- [ ] App handles malformed notification data gracefully

## Automated Testing

For automated testing, you can:

1. Use the "Simulate Test Notification" button in the app
2. Create unit tests for the NotificationManager class
3. Use platform-specific testing frameworks to send test notifications

## Performance Considerations

- The app should launch quickly when opened from a notification
- Notification data parsing should be efficient
- UI should update smoothly when notification data changes