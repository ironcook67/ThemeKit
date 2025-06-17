# ThemeKit

A comprehensive theming system for SwiftUI applications built on top of [ColorKit](https://github.com/ironcook67/ColorKit).

[![Swift 6.1](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20tvOS%2017%2B%20%7C%20watchOS%2010%2B%20%7C%20visionOS%201%2B-lightgrey.svg)](https://developer.apple.com/swift/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Compatible-brightgreen.svg)](https://developer.apple.com/swiftui/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Features

✨ **Six-Color Theme System** - Semantic color roles for consistent design  
🎨 **Animated Transitions** - Smooth animations when switching themes or modes  
🌓 **Automatic Light/Dark Mode** - Responds to system appearance changes  
💾 **Persistent Theme Selection** - Saves user preferences between app launches  
🎯 **Built-in Themes** - Default, Ocean, and Forest themes included  
🔧 **Extensible** - Easy to add custom themes  
🌍 **Environment Integration** - Colors available throughout your app via SwiftUI environment  
🚀 **Swift 6.1 Ready** - Full concurrency support with strict concurrency checking

## Installation

### Swift Package Manager

Add ThemeKit to your project using Xcode:

1. **File** → **Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/yourusername/ThemeKit.git`
3. Select the version rule and add the package

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ThemeKit.git", from: "2.0.0")
]
```

## Quick Start

### 1. Set up ThemeManager in your App

```swift
import SwiftUI
import ThemeKit

@main
struct MyApp: App {
    @State private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeEnvironment(themeManager)
                .automaticColorScheme(themeManager)
        }
    }
}
```

### 2. Use Theme Colors in Your Views

```swift
import SwiftUI
import ThemeKit

struct ContentView: View {
    @Environment(\.themeColors) var themeColors
    @Environment(ThemeManager.self) var themeManager
    
    var body: some View {
        ThemedView {
            VStack(spacing: 20) {
                Text("Welcome to ThemeKit!")
                    .font(.title)
                    .foregroundColor(themeColors.contrast)
                
                Button("Switch to Ocean Theme") {
                    themeManager.setTheme(.ocean)
                }
                .padding()
                .background(themeColors.primary)
                .foregroundColor(themeColors.background)
                .cornerRadius(8)
                
                ThemeSelector()
            }
            .padding()
        }
    }
}
```

### 3. Create a Theme Selector

```swift
struct ThemeSelector: View {
    @Environment(\.themeColors) var themeColors
    @Environment(ThemeManager.self) var themeManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("Choose Theme")
                .font(.headline)
                .foregroundColor(themeColors.contrast)
            
            HStack {
                ForEach(themeManager.availableThemes) { theme in
                    ThemePreview(
                        theme: theme,
                        colorScheme: colorScheme,
                        isSelected: theme.id == themeManager.currentTheme.id
                    )
                    .onTapGesture {
                        themeManager.setTheme(theme)
                    }
                }
            }
        }
    }
}
```

## Color System

ThemeKit uses a six-color system with semantic roles:

| Color | Purpose | Usage Examples |
|-------|---------|----------------|
| **Primary** | Main brand elements and actions | Primary buttons, navigation, brand elements |
| **Secondary** | Subtle UI components | Card borders, dividers, subtle backgrounds |
| **Background** | Base application background | Main view backgrounds, card backgrounds |
| **Accent** | Interactive elements needing attention | Call-to-action buttons, links, highlights |
| **Highlight** | Emphasis and warnings | Tags, badges, warning indicators |
| **Contrast** | Text and icons for maximum legibility | Body text, icons, high-contrast elements |

### Accessing Colors

```swift
@Environment(\.themeColors) var themeColors

// Use semantic colors
Text("Hello").foregroundColor(themeColors.contrast)
Rectangle().fill(themeColors.primary)
Button("Action") { }.accentColor(themeColors.accent)
```

## Built-in Themes

### Default Theme
A balanced theme suitable for most applications with carefully chosen colors for optimal readability.

### Ocean Theme
Blue and teal tones inspired by ocean depths, perfect for productivity or maritime applications.

### Forest Theme
Green and earth tones inspired by nature, ideal for health, environmental, or outdoor applications.

## Creating Custom Themes

```swift
// 1. Create custom color schemes
let customLight = ThemeColorScheme(
    name: "Custom Light",
    primary: Color(hexString: "#6366F1") ?? .blue,
    secondary: Color(hexString: "#E5E7EB") ?? .gray,
    background: Color(hexString: "#FFFFFF") ?? .white,
    accent: Color(hexString: "#F59E0B") ?? .orange,
    highlight: Color(hexString: "#EF4444") ?? .red,
    contrast: Color(hexString: "#111827") ?? .black
)

let customDark = ThemeColorScheme(
    name: "Custom Dark",
    primary: Color(hexString: "#818CF8") ?? .blue,
    secondary: Color(hexString: "#374151") ?? .gray,
    background: Color(hexString: "#1F2937") ?? .black,
    accent: Color(hexString: "#FBBF24") ?? .orange,
    highlight: Color(hexString: "#F87171") ?? .red,
    contrast: Color(hexString: "#F9FAFB") ?? .white
)

// 2. Create the theme
let customTheme = Theme(
    name: "Custom",
    light: customLight,
    dark: customDark
)

// 3. Add to ThemeManager
themeManager.addTheme(customTheme)
```

## Advanced Usage

### Custom Animation Settings

```swift
// Customize transition animations
themeManager.setAnimationSettings(
    duration: 0.8,
    curve: .spring(response: 0.6, dampingFraction: 0.8)
)
```

### Manual Color Scheme Control

```swift
// Override automatic light/dark mode detection
themeManager.setColorScheme(.dark, animated: true)
```

### Theme Persistence

ThemeKit automatically saves the user's theme selection and restores it when the app launches. No additional setup required!

## Requirements

- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+ / visionOS 1.0+
- Swift 6.1+
- Xcode 15.0+
- [ColorKit 1.1.1+](https://github.com/ironcook67/ColorKit)

## Architecture

ThemeKit is built with clean architecture principles:

```
ThemeKit/
├── Models/
│   ├── Theme.swift              # Theme structure with light/dark schemes
│   └── ThemeColorScheme.swift   # Six-color scheme definition
├── ThemeManager.swift           # Observable theme state manager
├── Views/
│   ├── ThemeEnvironment.swift   # Environment integration
│   ├── ThemedView.swift         # Automatic themed container
│   └── ThemePreview.swift       # Theme preview component
└── ThemeKit.swift              # Main module interface
```

## Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Build and test using `Cmd+U`

### Guidelines

- Follow Swift API Design Guidelines
- Include comprehensive DocC documentation
- Add unit tests for new features
- Ensure Swift 6.1 concurrency compliance

## License

ThemeKit is available under the MIT license. See the LICENSE file for more info.

## Dependencies

- [ColorKit](https://github.com/ironcook67/ColorKit) - Color utilities and extensions

## Acknowledgments

Built with ❤️ using SwiftUI and modern Swift concurrency features.

---

**Made for developers who care about beautiful, consistent user interfaces.**
