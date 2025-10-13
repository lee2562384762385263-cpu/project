#!/bin/bash

echo "🔨 Building iOS project with verbose output..."
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script requires macOS for iOS builds"
    exit 1
fi

# Clean previous build
echo "1. Cleaning previous build..."
rm -rf build-ios
mkdir -p build-ios
cd build-ios

# Generate Makefile with verbose output
echo ""
echo "2. Generating iOS Makefile..."
qmake -spec macx-ios-clang CONFIG+=debug CONFIG+=verbose ../NotificationApp.pro

if [ $? -ne 0 ]; then
    echo "❌ qmake failed"
    exit 1
fi

# Build with maximum verbosity
echo ""
echo "3. Building with verbose output..."
echo "   (This will show the full clang++ command with -v flag)"
make VERBOSE=1 V=1

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build succeeded!"
    echo "   Executable: build-ios/NotificationApp.app"
else
    echo ""
    echo "❌ Build failed - check output above for linker errors"
    echo ""
    echo "💡 Common fixes:"
    echo "   - Check iOS deployment target (currently 14.0)"
    echo "   - Verify all frameworks are available"
    echo "   - Look for deprecated API usage"
fi