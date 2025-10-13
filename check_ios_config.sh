#!/bin/bash

echo "🔍 Checking iOS Build Configuration..."
echo ""

# Check .pro file for iOS frameworks
echo "1. iOS Frameworks:"
if grep -q "framework Foundation" NotificationApp.pro; then
    echo "   ✅ Foundation framework"
else
    echo "   ❌ Missing Foundation framework"
fi

if grep -q "framework UIKit" NotificationApp.pro; then
    echo "   ✅ UIKit framework"
else
    echo "   ❌ Missing UIKit framework"
fi

if grep -q "framework UserNotifications" NotificationApp.pro; then
    echo "   ✅ UserNotifications framework"
else
    echo "   ❌ Missing UserNotifications framework"
fi

# Check deployment target
echo ""
echo "2. iOS Deployment Target:"
if grep -q "QMAKE_IOS_DEPLOYMENT_TARGET" NotificationApp.pro; then
    target=$(grep "QMAKE_IOS_DEPLOYMENT_TARGET" NotificationApp.pro | cut -d'=' -f2 | tr -d ' ')
    echo "   ✅ Set to iOS $target"
else
    echo "   ❌ No deployment target set"
fi

# Check Objective-C++ config
echo ""
echo "3. Objective-C++ Configuration:"
if grep -q "CONFIG += objective_c" NotificationApp.pro; then
    echo "   ✅ Objective-C++ enabled"
else
    echo "   ❌ Objective-C++ not enabled"
fi

# Check iOS define
echo ""
echo "4. iOS Preprocessor Define:"
if grep -q "DEFINES += Q_OS_IOS" NotificationApp.pro; then
    echo "   ✅ Q_OS_IOS defined"
else
    echo "   ❌ Q_OS_IOS not defined"
fi

# Check .mm file
echo ""
echo "5. Objective-C++ Source:"
if grep -q "iosnotificationhandler.mm" NotificationApp.pro; then
    echo "   ✅ .mm file included in build"
else
    echo "   ❌ .mm file not included"
fi

if [ -f "src/iosnotificationhandler.mm" ]; then
    echo "   ✅ .mm file exists"
else
    echo "   ❌ .mm file missing"
fi

echo ""
echo "🎯 Summary:"
echo "   The iOS linker error should be fixed with these configurations."
echo "   Try building in Qt Creator with iOS kit selected."