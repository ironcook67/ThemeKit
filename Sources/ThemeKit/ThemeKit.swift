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
    public static let version = "0.0.1"
}

// MARK: - Previews

#Preview("ThemeKit Demo App") {
    ThemeKitDemoApp()
}

#Preview("Theme Switching") {
    ThemeSwitchingDemo()
}

private struct ThemeKitDemoApp: View {
    @State private var themeManager = ThemeManager()
    
    var body: some View {
        NavigationView {
            ThemedView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("ThemeKit")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("v\(ThemeKit.version)")
                            .font(.caption)
                            .opacity(0.6)
                    }
                    
                    // Theme previews
                    VStack(spacing: 16) {
                        Text("Available Themes")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            ForEach([Theme.default, .ocean, .forest], id: \.id) { theme in
                                ThemePreview(
                                    theme: theme,
                                    colorScheme: themeManager.currentColorScheme,
                                    isSelected: theme.id == themeManager.currentTheme.id
                                )
                                .onTapGesture {
                                    themeManager.setTheme(theme)
                                }
                            }
                        }
                    }
                    
                    // Color scheme toggle
                    VStack(spacing: 12) {
                        Toggle("Automatic Color Scheme", isOn: .constant(themeManager.automaticColorSchemeDetection))
                            .disabled(true)
                        
                        HStack {
                            Button("Light") {
                                themeManager.setColorScheme(.light)
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Dark") {
                                themeManager.setColorScheme(.dark)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                    Spacer()
                    
                    // Sample content
                    VStack(spacing: 12) {
                        Button("Primary Action") {}
                            .buttonStyle(.borderedProminent)
                        
                        Button("Secondary Action") {}
                            .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .navigationTitle("ThemeKit Demo")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        .themeEnvironment(themeManager)
    }
}

private struct ThemeSwitchingDemo: View {
    @State private var themeManager = ThemeManager()
    @State private var selectedThemeIndex = 0
    
    private let themes: [Theme] = [.default, .ocean, .forest]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Theme Switching Demo")
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Theme", selection: $selectedThemeIndex) {
                ForEach(Array(themes.enumerated()), id: \.offset) { index, theme in
                    Text(theme.name).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedThemeIndex) { _, newIndex in
                themeManager.setTheme(themes[newIndex])
            }
            
            ThemedView {
                VStack(spacing: 16) {
                    Text("Current Theme: \(themeManager.currentTheme.name)")
                        .font(.headline)
                    
                    Text("This content automatically adapts to the selected theme.")
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        Button("Action") {}
                            .buttonStyle(.borderedProminent)
                        
                        Button("Cancel") {}
                            .buttonStyle(.bordered)
                    }
                }
                .padding(20)
            }
        }
        .padding()
        .themeEnvironment(themeManager)
    }
}
