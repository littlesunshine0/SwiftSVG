# SwiftSVG

A lightweight and performant macOS application for browsing, viewing, and managing SVG (Scalable Vector Graphics) files, built with modern SwiftUI.

## Features

- **High-Fidelity SVG Rendering:** Renders SVGs accurately into native SwiftUI views.
- **Multiple View Layouts:** Browse your SVG library in a familiar **List**, a compact **Grid**, or a beautiful **Gallery** view.
- **Robust File Management:** Easily import individual SVG files or scan entire folders to build your collection.
- **Performant Thumbnails:** Asynchronous thumbnail generation ensures a smooth and responsive user experience, even with large libraries.
- **Error Handling:** Gracefully handles invalid or malformed SVG files, displaying a fallback error image instead of crashing.
- **Debug Mode:** A built-in debug mode to inspect rendering and parsing behavior.

## How to Use

1. Launch the application.
2. Use the `...` menu in the toolbar to **Import Files** or **Scan Folder**.
3. Use the layout switcher in the toolbar to change between List, Grid, and Gallery views.
4. Select an SVG from the library to see it rendered in the main preview pane.

## Building and Running

### Requirements
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Option 1: Using Swift Package Manager
```bash
swift build
swift run SwiftSVG
```

### Option 2: Using Xcode
1. Open the project in Xcode by double-clicking `Package.swift`
2. Set the target to your Mac
3. Press `Cmd+R` to build and run

## Project Structure

```
SwiftSVG/
├── Sources/SwiftSVG/
│   ├── SwiftSVGApp.swift          # App entry point
│   ├── Models/
│   │   ├── SVGItem.swift          # Data models and enums
│   │   ├── SVGColor.swift         # Safe color handling
│   │   ├── AppCoordinator.swift   # State management
│   │   └── FileManager.swift      # File operations
│   ├── Parsers/
│   │   ├── SVGParser.swift        # SVG parsing with safety
│   │   └── SVGRenderer.swift      # SVG rendering engine
│   └── Views/
│       ├── ContentView.swift      # Main app view
│       ├── SVGPreview.swift       # SVG preview component
│       ├── SVGThumbnail.swift     # Thumbnail component
│       └── SVGLayoutViews.swift   # List/Grid/Gallery layouts
├── Package.swift                  # Swift Package configuration
└── README.md                      # This file
```

## Key Features Implementation

### Bug Fixes & Stability
- **Safe gradient parsing** in `SVGParser.swift` - eliminates crashes from nil SVGColor initialization
- **Robust thumbnail generation** in `SVGThumbnail.swift` - no force-unwraps, comprehensive error handling
- **Empty data validation** in `SVGPreview.swift` and `SVGRenderer.swift` - prevents XML parser errors
- **State management** via `AppCoordinator.swift` - prevents SwiftUI state update warnings
- **Sandbox compatibility** - proper file access with security scoped resources

### UI/UX Enhancements
- **Multiple view layouts** - List, Grid, and Gallery views with toolbar picker
- **Centralized toolbar menu** - All actions accessible via "..." menu:
  - Import Files (⌘I)
  - Scan Folder (⌘O)  
  - Load Samples
  - Toggle Debug Mode (⌘D)
  - Delete Selected (Delete)
  - Clear All
- **Background thumbnail rendering** - Smooth performance even with large libraries
- **Comprehensive error handling** - Graceful fallbacks for invalid SVGs

## Technology Stack

- **UI Framework:** SwiftUI
- **Language:** Swift
- **Platform:** macOS
- **Architecture:** MVVM with Coordinator pattern
- **File Access:** Security-scoped resources for sandbox compatibility

## License

This project is intended to be licensed under the MIT License. You can add a `LICENSE` file to the repository to make this official.
