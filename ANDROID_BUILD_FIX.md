# Android Build Fix

## Problems Encountered

### 1. First Issue: Undefined Symbols
```
ld.lld: error: undefined symbol: AndroidNotificationHandler::initialize(NotificationManager*)
ld.lld: error: undefined symbol: AndroidNotificationHandler::requestPermission()
```

### 2. Second Issue: Objective-C on Android
```
ld.lld: error: undefined symbol: __gnu_objc_personality_v0
>>> referenced by iosnotificationhandler.mm
```

## Root Causes

### Issue 1: Conditional Compilation Problems
1. **Header files wrapped in `#ifdef Q_OS_ANDROID`** - Function declarations weren't visible to the linker
2. **Source files only compiled conditionally** - Missing implementations for cross-compilation
3. **Missing stub implementations** - No fallback implementations for other platforms

### Issue 2: Objective-C++ on Android
1. **`.mm` files contain Objective-C code** - Only works on Apple platforms
2. **Android linker tried to link Objective-C runtime** - `__gnu_objc_personality_v0` is iOS/macOS only
3. **Wrong file type for Android** - `.mm` files should not be compiled on Android

## Solution Applied

### 1. Fixed Header Files
- Moved platform-specific `#ifdef` inside the class, not around the entire class
- Made basic function declarations always available
- Only platform-specific methods are conditionally compiled

### 2. Separated Platform Implementations
- **Android**: `androidnotificationhandler.cpp` - Always compiled, contains stubs for non-Android
- **iOS**: Split into two files:
  - `iosnotificationhandler.cpp` - Always compiled, contains stubs for non-iOS
  - `iosnotificationhandler.mm` - Only compiled on iOS, contains Objective-C++ code

### 3. Added Stub Implementations
```cpp
#ifndef Q_OS_IOS
// Stub implementations for non-iOS platforms
void IOSNotificationHandler::initialize(NotificationManager *manager)
{
    Q_UNUSED(manager)
    qDebug() << "IOSNotificationHandler::initialize() - stub implementation (not on iOS)";
}
#endif
```

### 4. Updated .pro File Structure
```qmake
# Always compiled
SOURCES += src/androidnotificationhandler.cpp src/iosnotificationhandler.cpp

# Platform-specific
ios {
    SOURCES += src/iosnotificationhandler.mm  # Objective-C++ only on iOS
}
```

## Result
- **Desktop builds**: Use stub implementations, no linker errors
- **Android builds**: Use real Android implementations
- **iOS builds**: Use real iOS implementations + Android stubs

## Files Changed
- `src/androidnotificationhandler.h` - Restructured conditional compilation
- `src/androidnotificationhandler.cpp` - Added stub implementations for non-Android
- `src/iosnotificationhandler.h` - Restructured conditional compilation  
- `src/iosnotificationhandler.cpp` - **NEW**: Stub implementations for non-iOS
- `src/iosnotificationhandler.mm` - Removed stubs, iOS-only compilation
- `NotificationApp.pro` - Smart platform-specific compilation

## Test Your Build
Run `./test_android_build.sh` to verify all fixes are in place, then try building for Android again.

The undefined symbol errors should now be resolved!