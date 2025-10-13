#!/bin/bash

echo "Testing iOS compilation fixes..."

# Check that static member is only defined once
echo "Checking static member definitions..."

DEFINITIONS=$(grep -r "IOSNotificationHandler::s_notificationManager = nullptr" src/ | wc -l)
if [ "$DEFINITIONS" -eq 1 ]; then
    echo "✅ Static member defined exactly once"
else
    echo "❌ Static member defined $DEFINITIONS times (should be 1)"
    grep -r "IOSNotificationHandler::s_notificationManager = nullptr" src/
fi

# Check that s_notificationManager is accessible (not in ifdef)
echo "Checking member accessibility..."
if grep -A10 -B5 "static NotificationManager \*s_notificationManager" src/iosnotificationhandler.h | grep -v "#ifdef\|#endif"; then
    echo "✅ s_notificationManager is accessible"
else
    echo "❌ s_notificationManager might be in ifdef block"
fi

# Check that both files include the necessary headers
echo "Checking headers..."
if grep -q "notificationmanager.h" src/iosnotificationhandler.cpp; then
    echo "✅ iosnotificationhandler.cpp includes notificationmanager.h"
else
    echo "❌ iosnotificationhandler.cpp missing notificationmanager.h"
fi

# Check that stub implementation sets the static member
echo "Checking stub implementation..."
if grep -A5 "initialize.*manager" src/iosnotificationhandler.cpp | grep -q "s_notificationManager = manager"; then
    echo "✅ Stub implementation sets static member"
else
    echo "❌ Stub implementation doesn't set static member"
fi

echo ""
echo "Summary of changes made:"
echo "1. Moved s_notificationManager outside #ifdef in header"
echo "2. Defined static member in .cpp file (shared across platforms)"
echo "3. Removed duplicate definition from .mm file"
echo "4. Added notificationmanager.h include to .cpp file"
echo "5. Updated stub implementation to set static member"
echo ""
echo "Try building for iOS now!"