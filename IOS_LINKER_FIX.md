# iOS Linker Error Fix

## Problem
`clang++: error: linker command failed with exit code 1 (use -v to see invocation)`

## Root Cause
iOS builds require specific frameworks and linker configuration that were missing from the project file.

## Solution Applied

### 1. Added Required iOS Frameworks
```qmake
LIBS += -framework Foundation
LIBS += -framework UIKit  
LIBS += -framework UserNotifications
```

**Why needed:**
- `Foundation`: Core Objective-C runtime and basic classes (NSString, NSDictionary, etc.)
- `UIKit`: iOS UI framework (UIApplication, app lifecycle)
- `UserNotifications`: iOS 10+ notification framework (UNUserNotificationCenter, etc.)

### 2. Set iOS Deployment Target
```qmake
QMAKE_IOS_DEPLOYMENT_TARGET = 10.0
```

**Why needed:**
- UserNotifications framework requires iOS 10.0+
- Ensures compatibility with notification APIs used

### 3. Enabled Objective-C++ Compilation
```qmake
CONFIG += objective_c
```

**Why needed:**
- Required to compile `.mm` files (Objective-C++)
- Links Objective-C runtime properly

### 4. Added iOS Preprocessor Define
```qmake
DEFINES += Q_OS_IOS
```

**Why needed:**
- Ensures `#ifdef Q_OS_IOS` blocks are compiled
- Activates iOS-specific code paths

## Common iOS Linker Issues & Solutions

### Issue 1: Missing Framework
```
Undefined symbols for architecture arm64:
  "_OBJC_CLASS_$_UNUserNotificationCenter", referenced from:
```
**Solution:** Add `-framework UserNotifications`

### Issue 2: Missing Foundation
```
Undefined symbols for architecture arm64:
  "_NSStringFromClass", referenced from:
```
**Solution:** Add `-framework Foundation`

### Issue 3: Objective-C Runtime Missing
```
Undefined symbols for architecture arm64:
  "_objc_msgSend", referenced from:
```
**Solution:** Add `CONFIG += objective_c`

### Issue 4: iOS Version Compatibility
```
'UNUserNotificationCenter' is only available on iOS 10.0 or newer
```
**Solution:** Set `QMAKE_IOS_DEPLOYMENT_TARGET = 10.0`

## Verification Steps

1. **Clean Build**
   ```bash
   # In Qt Creator
   Build → Clean All
   Build → Rebuild All
   ```

2. **Check Build Output**
   - Look for framework linking: `-framework UserNotifications`
   - Verify deployment target: `-mios-version-min=10.0`
   - Confirm Objective-C++ compilation: `.mm` files processed

3. **Common Build Errors Fixed**
   - ✅ Missing UserNotifications framework
   - ✅ Missing Foundation framework  
   - ✅ Missing UIKit framework
   - ✅ Objective-C++ compilation issues
   - ✅ iOS deployment target compatibility

## Files Modified
- `NotificationApp.pro` - Added iOS frameworks, deployment target, and compilation flags

The iOS linker error should now be resolved!