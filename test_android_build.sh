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

if [ -f "src/iosnotificationhandler.mm" ]; then
    echo "✓ iosnotificationhandler.mm exists"
else
    echo "✗ iosnotificationhandler.mm missing"
    exit 1
fi

# Check if stub implementations exist
echo "Checking for stub implementations..."
if grep -q "stub implementation" src/androidnotificationhandler.cpp; then
    echo "✓ Android stub implementations found"
else
    echo "✗ Android stub implementations missing"
fi

if grep -q "stub implementation" src/iosnotificationhandler.mm; then
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

if grep -q "src/iosnotificationhandler.mm" NotificationApp.pro; then
    echo "✓ iOS handler in .pro file"
else
    echo "✗ iOS handler missing from .pro file"
fi

echo "Test complete. Try building for Android now!"