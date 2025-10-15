# 🚨 Critical iOS Build Fix

## Problem: Undefined symbols for s_notificationManager

## Root Cause: Missing static member definition

## Fix: Add this line to iosnotificationhandler.mm

**Location: Right after the @end block, around line 72**

```cpp
@end

// Static member definitions - ADD BOTH LINES:
void *IOSNotificationHandler::s_delegate = nullptr;
NotificationManager *IOSNotificationHandler::s_notificationManager = nullptr;  // ← ADD THIS!

void IOSNotificationHandler::initialize(NotificationManager *manager)
{
    s_notificationManager = manager;
    // ... rest of code
}
```

## Complete Section Should Look Like:

```cpp
@end

// Static member definitions
void *IOSNotificationHandler::s_delegate = nullptr;
NotificationManager *IOSNotificationHandler::s_notificationManager = nullptr;

void IOSNotificationHandler::initialize(NotificationManager *manager)
{
    s_notificationManager = manager;
    setupNotificationDelegate();
    
    // Check if app was launched from notification
    NSDictionary *launchOptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"LaunchOptions"];
    if (launchOptions) {
        handleLaunchOptions((__bridge void*)launchOptions);
    }
}
```

## SwiftUICore Warning Fix:

Add to your .pro file:
```qmake
ios {
    # Suppress SwiftUI warnings
    QMAKE_LFLAGS += -Wl,-weak_framework,SwiftUICore
    QMAKE_LFLAGS += -Wl,-weak_framework,CoreAudioTypes
    
    # Set proper deployment target
    QMAKE_IOS_DEPLOYMENT_TARGET = 14.0
}
```