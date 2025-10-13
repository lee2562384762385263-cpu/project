#!/bin/bash

echo "Testing Android build fixes..."

# Check if we have the right files
echo "Checking source files..."
if [ -f "src/androidnotificationhandler.cpp" ]; then
    echo "✓ androidnotificationhandler.cpp exists"
else
    echo "✗ androidnotificationhandler.cpp missing"
    exit 1
fi

if [ -f "src/iosnotificationhandler.cpp" ]; then
    echo "✓ iosnotificationhandler.cpp exists"
else
    echo "✗ iosnotificationhandler.cpp missing"
    exit 1
fi

if [ -f "src/iosnotificationhandler.mm" ]; then
    echo "✓ iosnotificationhandler.mm exists (iOS-only)"
else
    echo "✗ iosnotificationhandler.mm missing"
fi

# Check if stub implementations exist
echo "Checking for stub implementations..."
if grep -q "stub implementation" src/androidnotificationhandler.cpp; then
    echo "✓ Android stub implementations found"
else
    echo "✗ Android stub implementations missing"
fi

if grep -q "stub implementation" src/iosnotificationhandler.cpp; then
    echo "✓ iOS stub implementations found"
else
    echo "✗ iOS stub implementations missing"
fi

# Check .pro file
echo "Checking .pro file..."
if grep -q "src/androidnotificationhandler.cpp" NotificationApp.pro; then
    echo "✓ Android handler in .pro file"
else
    echo "✗ Android handler missing from .pro file"
fi

if grep -q "src/iosnotificationhandler.cpp" NotificationApp.pro; then
    echo "✓ iOS handler (.cpp) in .pro file"
else
    echo "✗ iOS handler (.cpp) missing from .pro file"
fi

# Check that .mm file is only included for iOS
if grep -A5 "ios {" NotificationApp.pro | grep -q "iosnotificationhandler.mm"; then
    echo "✓ iOS .mm file conditionally included"
else
    echo "✗ iOS .mm file not conditionally included"
fi

echo "Test complete. Try building for Android now!"