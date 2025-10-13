# Qt 6.8.2 Notification App Setup Instructions

## Prerequisites

### Windows
1. **Install Qt 6.8.2**:
   - Download Qt Online Installer from https://www.qt.io/download-qt-installer
   - Install Qt 6.8.2 with the following components:
     - Qt 6.8.2 Desktop (MinGW or MSVC)
     - Qt Creator
     - CMake
     - Ninja

2. **Set Environment Variables**:
   ```cmd
   set Qt6_DIR=C:\Qt\6.8.2\mingw_64\lib\cmake\Qt6
   set PATH=%PATH%;C:\Qt\6.8.2\mingw_64\bin
   ```

### macOS
1. **Install Qt 6.8.2**:
   ```bash
   # Using Homebrew
   brew install qt@6
   
   # Or download from Qt website
   ```

2. **Set Environment Variables**:
   ```bash
   export Qt6_DIR=/opt/homebrew/lib/cmake/Qt6  # Homebrew path
   # or
   export Qt6_DIR=/Users/$(whoami)/Qt/6.8.2/macos/lib/cmake/Qt6  # Qt installer path
   ```

### Linux (Ubuntu/Debian)
1. **Install Qt 6.8.2**:
   ```bash
   sudo apt update
   sudo apt install qt6-base-dev qt6-declarative-dev cmake build-essential
   ```

## Build Methods

### Method 1: Qt Creator (Easiest)
1. Open Qt Creator
2. File → Open File or Project
3. Select `NotificationApp.pro` (not CMakeLists.txt)
4. Configure project with Qt 6.8.2 kit
5. Build → Build Project
6. Run → Run

### Method 2: Command Line with qmake
```bash
# Navigate to project directory
cd /path/to/NotificationApp

# Generate Makefile
qmake NotificationApp.pro

# Build
make  # Linux/macOS
# or
mingw32-make  # Windows with MinGW
```

### Method 3: CMake (if Qt6_DIR is set correctly)
```bash
mkdir build
cd build
cmake -DQt6_DIR="$Qt6_DIR" ..
cmake --build .
```

## Troubleshooting

### Common Issues

1. **"Qt6 not found" Error**:
   - Ensure Qt6_DIR points to the correct cmake directory
   - Example: `/path/to/Qt/6.8.2/gcc_64/lib/cmake/Qt6`

2. **"Syntaxfehler beim unerwarteten Wort" (German locale)**:
   - This suggests a shell parsing issue
   - Try using Qt Creator instead of command line
   - Or set English locale: `export LANG=en_US.UTF-8`

3. **Missing QML modules**:
   - Ensure qt6-declarative-dev is installed (Linux)
   - Or Qt Quick module is selected in Qt installer

4. **Build fails with MOC errors**:
   - Clean build directory: `rm -rf build`
   - Try qmake method instead of CMake

### Platform-Specific Notes

**Windows**:
- Use Qt Creator for best experience
- Ensure correct compiler (MinGW vs MSVC) matches Qt installation

**macOS**:
- May need to install Xcode command line tools: `xcode-select --install`

**Linux**:
- Install development packages: `sudo apt install build-essential`

## Minimal Test

If you're still having issues, try this minimal version first:

1. Create a new Qt Quick Application in Qt Creator
2. Replace the generated files with our notification app files
3. Build and run to verify Qt setup works
4. Then add notification functionality step by step

## Docker Alternative (if allowed)

If Docker is available:
```bash
# Build and run in Docker
./docker-build.sh
```

This eliminates all local Qt setup issues.