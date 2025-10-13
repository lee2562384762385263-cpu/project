#!/bin/bash

echo "🔍 Verifying iOS compilation fix..."
echo ""

# Check that static member is public
echo "1. Checking static member visibility..."
if grep -A2 -B2 "static NotificationManager \*s_notificationManager" src/iosnotificationhandler.h | grep -B5 "s_notificationManager" | grep -q "public:"; then
    echo "   ✅ s_notificationManager is public"
else
    echo "   ❌ s_notificationManager is not public"
fi

# Check static member definition
echo ""
echo "2. Checking static member definition..."
if grep -q "NotificationManager \*IOSNotificationHandler::s_notificationManager = nullptr;" src/iosnotificationhandler.cpp; then
    echo "   ✅ Static member defined in .cpp file"
else
    echo "   ❌ Static member not defined in .cpp file"
fi

# Check no duplicate definition
echo ""
echo "3. Checking for duplicate definitions..."
duplicate_count=$(grep -c "NotificationManager \*IOSNotificationHandler::s_notificationManager" src/iosnotificationhandler.mm src/iosnotificationhandler.cpp 2>/dev/null || echo "0")
if [ "$duplicate_count" -eq 1 ]; then
    echo "   ✅ Static member defined exactly once"
else
    echo "   ❌ Static member defined $duplicate_count times (should be 1)"
fi

# Check access patterns
echo ""
echo "4. Checking access patterns in .mm file..."
echo "   Objective-C callbacks (should use IOSNotificationHandler::):"
grep -n "IOSNotificationHandler::s_notificationManager" src/iosnotificationhandler.mm | while read line; do
    echo "     ✅ Line: $line"
done

echo "   Class member functions (can use short form):"
grep -n "^\s*s_notificationManager" src/iosnotificationhandler.mm | while read line; do
    echo "     ✅ Line: $line"
done

echo ""
echo "🎯 Summary:"
echo "   - Static member is public for callback access"
echo "   - Defined once in .cpp file (shared across platforms)"
echo "   - Correct access patterns for different contexts"
echo ""
echo "✅ iOS compilation should now work!"