# Android Build Fix

## Problem
When building for Android, you got these linker errors:
```
ld.lld: error: undefined symbol: AndroidNotificationHandler::initialize(NotificationManager*)
ld.lld: error: undefined symbol: AndroidNotificationHandler::requestPermission()
```

## Root Cause
The issue was with conditional compilation. The original code had:

1. **Header files wrapped in `#ifdef Q_OS_ANDROID`** - This meant the function declarations weren't visible to the linker on non-Android platforms
2. **Source files only compiled conditionally** - The .pro file only included Android sources when building for Android
3. **Missing stub implementations** - No fallback implementations for other platforms

## Solution Applied

### 1. Fixed Header Files
- Moved platform-specific `#ifdef` inside the class, not around the entire class
- Made basic function declarations always available
- Only platform-specific methods are conditionally compiled

### 2. Always Compile All Platform Handlers
- Both `androidnotificationhandler.cpp` and `iosnotificationhandler.mm` are now always compiled
- Each file contains stub implementations for non-target platforms

### 3. Added Stub Implementations
```cpp
#else // !Q_OS_ANDROID
// Stub implementations for non-Android platforms
void AndroidNotificationHandler::initialize(NotificationManager *manager)
{
    Q_UNUSED(manager)
    qDebug() << "AndroidNotificationHandler::initialize() - stub implementation (not on Android)";
}
```

### 4. Updated .pro File
- Always include both platform handlers in SOURCES
- Keep platform-specific configuration (DEFINES, OTHER_FILES) conditional

## Result
- **Desktop builds**: Use stub implementations, no linker errors
- **Android builds**: Use real Android implementations
- **iOS builds**: Use real iOS implementations + Android stubs

## Files Changed
- `src/androidnotificationhandler.h` - Restructured conditional compilation
- `src/androidnotificationhandler.cpp` - Added stub implementations
- `src/iosnotificationhandler.h` - Restructured conditional compilation  
- `src/iosnotificationhandler.mm` - Added stub implementations
- `NotificationApp.pro` - Always compile both handlers

## Test Your Build
Run `./test_android_build.sh` to verify all fixes are in place, then try building for Android again.

The undefined symbol errors should now be resolved!