# Notification App - QML Cross-Platform

A Qt 6.8.2 QML application that handles notifications and can be opened from terminated state by tapping on notifications.

## Features

- Cross-platform QML application (iOS and Android)
- Notification handling with content reading
- App launch from terminated state via notification tap
- Shared codebase between platforms with platform-specific implementations

## Requirements

- Qt 6.8.2 or later
- CMake 3.16 or later
- For Android: Android SDK, NDK
- For iOS: Xcode, iOS SDK

## Project Structure

```
NotificationApp/
├── CMakeLists.txt          # Main CMake configuration
├── main.cpp                # Application entry point
├── Main.qml                # Main QML interface
├── android/                # Android-specific files
│   └── AndroidManifest.xml # Android manifest with permissions
├── ios/                    # iOS-specific files
│   └── Info.plist          # iOS app configuration
└── src/                    # C++ source files (notification handling)
```

## Building

### Desktop (for testing)
```bash
mkdir build
cd build
cmake ..
cmake --build .
```

### Android
```bash
mkdir build-android
cd build-android
cmake .. -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
         -DANDROID_ABI=arm64-v8a \
         -DANDROID_PLATFORM=android-23
cmake --build .
```

### iOS
```bash
mkdir build-ios
cd build-ios
cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS
cmake --build . --config Release
```

## Notification Features

The app implements:

1. **Notification Registration**: Registers for push notifications on app start
2. **Background Handling**: Processes notifications when app is terminated
3. **Content Reading**: Extracts and displays notification content when opened from notification
4. **Cross-Platform**: Shared QML UI with platform-specific notification backends

## Platform-Specific Implementation

### Android
- Uses Android's NotificationManager and BroadcastReceiver
- JNI bridge for C++/Java communication
- Handles notification intents and extras

### iOS
- Uses UserNotifications framework
- Objective-C++ bridge for C++/Objective-C communication
- Handles notification payloads and app delegate methods

## Usage

1. Build and install the app on your device using `./build.sh [platform]`
2. Launch the app and grant notification permissions when prompted
3. Test the basic functionality using the "Simulate Test Notification" button
4. Send a real notification to the device (see TESTING.md for methods)
5. Terminate the app completely
6. Tap the notification to reopen the app
7. The app will display the notification content that triggered the launch

## Testing

See `TESTING.md` for comprehensive testing instructions and `test_notifications.py` for sending test notifications.

## Key Features Implemented

- ✅ Cross-platform QML application (Qt 6.8.2)
- ✅ Notification permission handling
- ✅ App launch from terminated state via notification tap
- ✅ Notification content parsing and display
- ✅ Platform-specific implementations (Android JNI, iOS Objective-C++)
- ✅ Shared QML UI with native backend integration
- ✅ Development testing tools and comprehensive documentation