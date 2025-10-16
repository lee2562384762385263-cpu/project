    # 🔍 iOS Linker Error Diagnosis Guide

## Primary Fix Applied ✅
Added missing static member definition:
```cpp
NotificationManager *IOSNotificationHandler::s_notificationManager = nullptr;
```

## If Error Persists - Alternative Causes & Fixes:

### 1. 🔧 **File Extension Issue**
**Problem**: `.mm` file treated as `.cpp`
**Check**: Verify your `.pro` file has:
```qmake
ios {
    SOURCES += src/iosnotificationhandler.mm  # Must be .mm not .cpp!
}
```

### 2. 🔧 **Conditional Compilation Issue**
**Problem**: `#ifdef Q_OS_IOS` not defined
**Fix**: Add to your `.pro` file:
```qmake
ios {
    DEFINES += Q_OS_IOS
}
```

### 3. 🔧 **Build System Not Finding File**
**Check**: Verify file is actually being compiled:
```bash
# Look for the .mm file in build output
make clean
make 2>&1 | grep iosnotificationhandler
```

### 4. 🔧 **Wrong iOS SDK/Deployment Target**
**Fix**: Ensure consistent iOS version:
```qmake
ios {
    QMAKE_IOS_DEPLOYMENT_TARGET = 14.0
    # Remove any conflicting iOS version settings
}
```

### 5. 🔧 **Missing NotificationManager Link**
**Problem**: NotificationManager class not properly linked
**Check**: Verify in your `.pro`:
```qmake
SOURCES += src/notificationmanager.cpp
HEADERS += src/notificationmanager.h
```

### 6. 🔧 **Multiple Definition Conflict**
**Problem**: Static member defined multiple times
**Check**: Search for duplicate definitions:
```bash
grep -r "s_notificationManager.*=" . --include="*.cpp" --include="*.mm"
```

### 7. 🔧 **Preprocessor Debug**
**Add temporary debug** to `iosnotificationhandler.mm`:
```cpp
#ifdef Q_OS_IOS
#pragma message "Q_OS_IOS is defined - compiling iOS code"
#else
#pragma message "Q_OS_IOS NOT defined - skipping iOS code"
#endif

// Static member definitions
NotificationManager *IOSNotificationHandler::s_notificationManager = nullptr;
```

### 8. 🔧 **Force Objective-C++ Compilation**
**Add to `.pro` file:**
```qmake
ios {
    # Force Objective-C++ compilation
    QMAKE_CXXFLAGS += -x objective-c++
}
```

### 9. 🔧 **Linker Order Issue**
**Fix**: Ensure proper linking order in `.pro`:
```qmake
ios {
    # Put notification files first
    SOURCES += src/notificationmanager.cpp
    SOURCES += src/iosnotificationhandler.mm
    # Then other sources...
}
```

### 10. 🔧 **Clean Everything**
**Nuclear option:**
```bash
rm -rf build/
rm -rf .qmake.stash
rm Makefile*
qmake
make clean
make
```

## 🚨 Emergency Workaround
If all else fails, move the static member definition to the header:

**In `iosnotificationhandler.h`:**
```cpp
class IOSNotificationHandler : public QObject
{
    // ...
public:
    // Change from declaration to definition
    static NotificationManager *s_notificationManager;  // Remove this line
    inline static NotificationManager *s_notificationManager = nullptr;  // Add this
};
```

## 🔍 Diagnostic Commands
```bash
# Check if .mm file is being compiled
make clean && make 2>&1 | grep -i "iosnotification"

# Check for symbol in object file
nm build/iosnotificationhandler.o | grep s_notificationManager

# Check preprocessor defines
echo | qmake -query QT_INSTALL_BINS/moc -DQ_OS_IOS -E - | grep Q_OS_IOS
```