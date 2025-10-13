# iOS Build Troubleshooting Guide

## Getting Verbose Build Output in Qt Creator

Since you're using Qt Creator's build hammer (GUI), here's how to see the detailed linker invocation:

### Method 1: Qt Creator Build Output
1. **Open Qt Creator**
2. **Go to**: `Tools` → `Options` → `Build & Run` → `General`
3. **Check**: "Open Compile Output pane when building"
4. **Set**: "Save all files before build" 
5. **Build** your project
6. **Look at**: "Compile Output" tab at bottom - shows full command lines

### Method 2: Enable Verbose Makefile
Add to your `.pro` file:
```qmake
CONFIG += debug_and_release
CONFIG += verbose
```

### Method 3: Terminal Build (Most Verbose)
```bash
# In your project directory
qmake -spec macx-ios-clang CONFIG+=debug CONFIG+=verbose NotificationApp.pro
make VERBOSE=1
```

## Fixed iOS Version Issues

### Problem: `'path' is unavailable: introduced in iOS 13.0`
**Root Cause**: Deployment target was too low for modern APIs

### Solution Applied:
1. **Updated deployment target** to iOS 14.0:
   ```qmake
   QMAKE_IOS_DEPLOYMENT_TARGET = 14.0
   ```

2. **Fixed deprecated notification API**:
   ```objc
   // OLD (deprecated in iOS 14):
   UNNotificationPresentationOptionAlert
   
   // NEW (iOS 14+):
   UNNotificationPresentationOptionBanner
   ```

3. **Added availability checks**:
   ```objc
   if (@available(iOS 14.0, *)) {
       // Use modern API
       completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound);
   } else {
       // Fallback for older versions
       completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
   }
   ```

## Common iOS Build Errors & Solutions

### Error: `'path' is unavailable: introduced in iOS X.X`
**Solution**: Increase `QMAKE_IOS_DEPLOYMENT_TARGET` in `.pro` file

### Error: `Undefined symbols for architecture arm64`
**Solutions**:
- Add missing frameworks: `-framework UserNotifications`
- Enable Objective-C++: `CONFIG += objective_c`
- Check static member access patterns

### Error: `clang++: error: linker command failed with exit code 1`
**Solutions**:
1. Check frameworks are linked
2. Verify deployment target compatibility
3. Ensure Objective-C++ compilation is enabled
4. Look for deprecated API usage

## Current Configuration

✅ **iOS Deployment Target**: 14.0 (compatible with iOS 18 simulator)
✅ **Required Frameworks**: Foundation, UIKit, UserNotifications  
✅ **Objective-C++**: Enabled with `CONFIG += objective_c`
✅ **Modern APIs**: Using iOS 14+ notification presentation options
✅ **Backward Compatibility**: Availability checks for older iOS versions

## Testing Steps

1. **Clean Build**: `Build` → `Clean All`
2. **Rebuild**: `Build` → `Rebuild All` 
3. **Check Output**: Look at "Compile Output" tab for errors
4. **Run on Simulator**: iOS 18 simulator should work

The iOS version compatibility issues should now be resolved!