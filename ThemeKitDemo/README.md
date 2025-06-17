# ThemeKit Demo App

A comprehensive demonstration app showcasing ThemeKit's theming capabilities across all Apple platforms.

[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20tvOS%2017%2B%20%7C%20watchOS%2010%2B%20%7C%20visionOS%201%2B-lightgrey.svg)](https://developer.apple.com/swift/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Compatible-brightgreen.svg)](https://developer.apple.com/swiftui/)
[![ThemeKit](https://img.shields.io/badge/ThemeKit-2.0.0-blue.svg)](https://github.com/yourusername/ThemeKit)

## Overview

The ThemeKit Demo App is a multi-platform SwiftUI application that demonstrates the power and flexibility of the ThemeKit theming system. Experience smooth animated theme transitions, explore the six-color semantic system, and see how ThemeKit adapts to different platforms and screen sizes.

## Features

🎨 **Live Theme Switching** - Interactive theme selection with real-time previews  
✨ **Animated Transitions** - Smooth, customizable animations between themes  
🌓 **Automatic Light/Dark Mode** - Seamless adaptation to system appearance  
📱 **Multi-Platform** - Optimized interfaces for all Apple platforms  
🧩 **Component Showcase** - Comprehensive UI component demonstrations  
⚙️ **Settings & Controls** - Theme information and animation customization  
🎯 **Educational** - Perfect for learning ThemeKit integration patterns  

## Screenshots

### iOS
<!-- Add iOS screenshots here -->
*Tab-based navigation with theme previews and component demonstrations*

### macOS
<!-- Add macOS screenshots here -->
*Split-view interface with sidebar navigation and dedicated Settings window*

### tvOS
<!-- Add tvOS screenshots here -->
*TV-optimized interface with focus-based navigation*

### watchOS
<!-- Add watchOS screenshots here -->
*Simplified page-based interface designed for small screens*

## Quick Start

### Prerequisites

- Xcode 15.0 or later
- Swift 6.1 or later
- ThemeKit package (included as dependency)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ThemeKitDemo.git
   cd ThemeKitDemo
   ```

2. **Open in Xcode**
   ```bash
   open Package.swift
   ```
   Or generate an Xcode project:
   ```bash
   swift package generate-xcodeproj
   open ThemeKitDemo.xcodeproj
   ```

3. **Build and run**
   - Select your target platform (iOS, macOS, tvOS, watchOS, or visionOS)
   - Press `Cmd + R` to build and run

### Alternative Setup

If you want to use ThemeKit as a remote dependency:

1. **Update Package.swift** to reference ThemeKit remotely:
   ```swift
   dependencies: [
       .package(url: "https://github.com/yourusername/ThemeKit.git", from: "2.0.0")
   ]
   ```

2. **Clean and rebuild** the project

## App Structure

### 🏠 Home Tab
- **Welcome section** with ThemeKit branding
- **Feature highlights** showcasing key capabilities
- **Quick theme switching** with instant visual feedback
- **Color swatches** displaying current theme colors

### 🎨 Themes Tab
- **Interactive theme gallery** with visual previews
- **Theme selection** with animated transitions
- **Animation controls** for customizing transition speed
- **Current theme indicator** with selection feedback

### 🧩 Components Tab
- **Button showcase** using all six theme colors
- **UI controls** (sliders, toggles, pickers, text fields)
- **Card layouts** demonstrating themed components
- **Real-world examples** of ThemeKit integration

### ⚙️ Settings Tab
- **Theme information** display
- **System integration** details
- **Animation testing** functionality
- **Reset and demo** controls

## Platform-Specific Features

### iOS & iPadOS
- **Tab bar navigation** with SF Symbols
- **Large title navigation** bars
- **Adaptive layouts** for different screen sizes
- **Text field demonstrations**
- **Native iOS appearance**

### macOS
- **Split-view interface** with sidebar navigation
- **Separate Settings window** accessible via menu
- **Native macOS appearance** detection
- **Window toolbar** styling
- **Keyboard navigation** support

### tvOS
- **Focus-based navigation** optimized for Apple TV
- **Large, touch-friendly** interface elements
- **TV-optimized color contrast** ratios
- **Remote-friendly interactions**
- **Simplified navigation** hierarchy

### watchOS
- **Page-based navigation** for small screens
- **Digital Crown** scrolling support
- **Minimal information** density
- **Quick interactions** optimized for wrist
- **Essential features** only

### visionOS
- **Spatial interface** considerations
- **Depth and dimension** aware layouts
- **Immersive color** experiences
- **Vision Pro** optimized interactions

## Demo Scenarios

### 🎨 Theme Comparison
1. Open the **Themes** tab
2. Tap different theme previews
3. Watch the **smooth animated transitions**
4. Notice how **all UI elements** update consistently

### ⚡ Animation Testing
1. Go to **Themes** → **Animation Settings**
2. Select different **transition speeds**
3. Switch between themes to **test the timing**
4. See how **animation duration** affects user experience

### 🧩 Component Integration
1. Visit the **Components** tab
2. Interact with **various UI elements**
3. Observe how **each component** respects the theme
4. Test **buttons, sliders, toggles**, and more

### 🌓 Light/Dark Mode
1. Change your **system appearance** (Settings → Display)
2. Watch the app **automatically adapt**
3. See how **theme colors** adjust appropriately
4. Notice **smooth transitions** between modes

### 📱 Multi-Platform
1. Run the app on **different devices**
2. Compare **platform-specific** interfaces
3. Test **responsive layouts** by resizing windows
4. Experience **consistent theming** across platforms

## Educational Value

### For Developers
- **Complete ThemeKit implementation** showing best practices
- **Multi-platform SwiftUI** patterns and techniques
- **Environment-based theming** throughout the app hierarchy
- **Custom component creation** with theme integration
- **Animation implementation** for smooth user experiences
- **Platform-specific adaptations** and considerations

### For Designers
- **Visual impact** of consistent theming systems
- **Color psychology** in the six-color semantic approach
- **Platform conventions** and their adaptations
- **Animation timing** and user experience considerations
- **Accessibility benefits** of semantic color roles

### For Product Teams
- **User experience benefits** of adaptive theming
- **Professional polish** with smooth transitions
- **Cross-platform consistency** with appropriate differences
- **Customization capabilities** for brand alignment
- **Performance characteristics** of theme switching

## Customization Guide

### Adding Custom Themes

1. **Create color schemes**:
   ```swift
   let customLight = ThemeColorScheme(
       name: "Custom Light",
       primary: Color(hexString: "#Your-Color") ?? .blue,
       // ... other colors
   )
   
   let customDark = ThemeColorScheme(
       name: "Custom Dark", 
       // ... dark mode colors
   )
   ```

2. **Combine into theme**:
   ```swift
   let customTheme = Theme(
       name: "Custom",
       light: customLight,
       dark: customDark
   )
   ```

3. **Add to ThemeManager**:
   ```swift
   themeManager.addTheme(customTheme)
   ```

### Adding Demo Sections

1. **Create new view**:
   ```swift
   struct CustomDemoView: View {
       @Environment(\.themeColors) var themeColors
       
       var body: some View {
           // Your custom demo content
       }
   }
   ```

2. **Add to navigation**:
   ```swift
   // In ContentView's TabView or NavigationSplitView
   CustomDemoView()
       .tabItem {
           Image(systemName: "custom.icon")
           Text("Custom")
       }
   ```

### Extending Components

1. **Create themed components**:
   ```swift
   struct CustomThemedComponent: View {
       @Environment(\.themeColors) var themeColors
       
       var body: some View {
           // Component using themeColors
       }
   }
   ```

2. **Add to ComponentDemoView**:
   ```swift
   private var customSection: some View {
       VStack(alignment: .leading, spacing: 16) {
           Text("Custom Components")
               .font(.headline)
               .foregroundColor(themeColors.contrast)
           
           CustomThemedComponent()
       }
   }
   ```

## Performance Notes

- **Efficient theme switching** with minimal view updates
- **Lazy loading** of demo content for better startup time
- **Platform-optimized** layouts and interactions
- **Memory efficient** color management
- **Smooth 60fps** animations on all platforms

## Troubleshooting

### Build Issues
- Ensure **ThemeKit dependency** is properly configured
- Verify **Swift 6.1** toolchain is installed
- Check **platform deployment targets** match requirements

### Runtime Issues
- Confirm **environment setup** in app root
- Verify **theme manager initialization** 
- Check **ColorKit dependency** is available

### Platform-Specific Issues
- **macOS**: Ensure Settings window is properly configured
- **tvOS**: Test with Apple TV Simulator for focus behavior
- **watchOS**: Verify complications and minimal UI work correctly
- **visionOS**: Test spatial interactions and depth perception

## Contributing

We welcome contributions to improve the demo app! Areas for enhancement:

- **Additional demo scenarios** showcasing specific use cases
- **More custom themes** demonstrating different design approaches
- **Performance optimizations** for smoother animations
- **Accessibility improvements** and testing
- **Platform-specific features** that showcase unique capabilities

### Development Setup

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Make your changes** with appropriate tests
4. **Submit a pull request** with detailed description

## License

This demo app is available under the MIT license. See the LICENSE file for more info.

## Related Projects

- [ThemeKit](https://github.com/yourusername/ThemeKit) - The core theming library
- [ColorKit](https://github.com/ironcook67/ColorKit) - Color utilities and extensions

## Feedback

Found a bug or have a feature request? Please [open an issue](https://github.com/yourusername/ThemeKitDemo/issues) or [start a discussion](https://github.com/yourusername/ThemeKitDemo/discussions).

---

**Experience the future of SwiftUI theming. Download, explore, and see what ThemeKit can do for your applications.**
