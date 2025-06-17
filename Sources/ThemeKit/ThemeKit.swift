// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// ThemeKit provides a comprehensive theming system for SwiftUI applications.
///
/// Key features:
/// - Six-color theme system with semantic color roles
/// - Automatic light/dark mode support
/// - Smooth animated transitions between themes
/// - Persistent theme selection
/// - Built-in theme collection with extensibility
/// - Environment-based color access throughout your app
/// - Swift 6.1 concurrency support with strict concurrency checking
///
/// ## Getting Started
///
/// 1. Create a ThemeManager in your app:
/// ```swift
/// @State private var themeManager = ThemeManager()
/// ```
///
/// 2. Apply theme environment to your root view:
/// ```swift
/// ContentView()
///     .themeEnvironment(themeManager)
///     .automaticColorScheme(themeManager)
/// ```
///
/// 3. Use theme colors in your views:
/// ```swift
/// @Environment(\.themeColors) var themeColors
///
/// Text("Hello, World!")
///     .foregroundColor(themeColors.contrast)
///     .background(themeColors.primary)
/// ```
public enum ThemeKit {
    /// The current version of ThemeKit
    public static let version = "1.0.0"
}
