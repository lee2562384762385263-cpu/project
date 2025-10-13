# iOS Testing Guide

## 🍎 Building for iOS

### Prerequisites
- macOS with Xcode installed
- Qt 6.8.2 with iOS kit configured
- iOS Simulator or physical iOS device

### Build Steps
1. **Open in Qt Creator**
   ```
   File → Open File or Project → NotificationApp.pro
   ```

2. **Select iOS Kit**
   - In the kit selector (bottom left), choose your iOS kit
   - For simulator: "iOS Simulator" kit
   - For device: "iOS Device" kit

3. **Build Project**
   ```
   Build → Build Project "NotificationApp"
   ```

4. **Run on Simulator**
   ```
   Run → Run (Cmd+R)
   ```

## 🧪 Testing Notifications

### Step 1: Test Permission Request
1. Launch the app in iOS Simulator
2. Tap "Request Permission" button
3. **Expected**: iOS permission dialog should appear
4. Grant permission

### Step 2: Send Test Notification (App Running)
**Method A: Using Simulator Menu**
1. In iOS Simulator: `Device → Notifications → Send Notification`
2. Or use the notification center

**Method B: Using Command Line**
```bash
# Send a test notification to the simulator
xcrun simctl push booted com.example.notificationapp notification.json
```

Create `notification.json`:
```json
{
  "aps": {
    "alert": {
      "title": "Test Notification",
      "body": "This is a test notification from command line"
    },
    "badge": 1,
    "sound": "default"
  },
  "customData": {
    "message": "Hello from test notification!",
    "timestamp": "2024-01-01T12:00:00Z"
  }
}
```

### Step 3: Test Background Launch
1. **Close the app completely**
   - Double-tap home button (or swipe up)
   - Swipe up on the app to close it
   - Or use `Cmd+Shift+H` twice in simulator

2. **Send notification** (using Method A or B above)

3. **Tap the notification** when it appears

4. **Expected Result**:
   - App should launch
   - Main screen should show notification content
   - Should display: "Opened from notification: [notification data]"

## 🔧 Troubleshooting

### Build Issues
- **"iOS kit not found"**: Install Xcode and configure iOS kit in Qt Creator
- **"Provisioning profile"**: For device testing, you need Apple Developer account
- **"Architecture mismatch"**: Ensure Qt is built for iOS architecture

### Runtime Issues
- **Permission dialog not appearing**: Check iOS deployment target (iOS 10+)
- **Notifications not received**: Verify bundle identifier matches
- **App not launching from notification**: Check Info.plist configuration

### Debug Output
Check Qt Creator's "Application Output" pane for debug messages:
```
IOSNotificationHandler::initialize() - iOS implementation
IOSNotificationHandler::requestPermission() - requesting...
```

## 📱 Testing on Physical Device

1. **Connect iOS device**
2. **Select device kit** in Qt Creator
3. **Configure signing** (requires Apple Developer account)
4. **Build and deploy**

Note: Physical device testing requires proper code signing and provisioning profiles.

## 🎯 Success Criteria

✅ App builds and runs on iOS Simulator  
✅ Permission request dialog appears and works  
✅ Notifications are received while app is running  
✅ App launches from notification when terminated  
✅ Notification content is displayed in the app  

## Next Steps

Once iOS testing is complete, we can:
- Refine the notification handling
- Add more notification features
- Test on physical devices
- Optimize the cross-platform code