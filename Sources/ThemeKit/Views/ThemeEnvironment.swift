//
//  ThemeEnvironment.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A view modifier that injects theme environment values into the view hierarchy.
///
/// This modifier provides access to the current theme's colors through environment
/// values, making it easy to use themed colors throughout your app.
public struct ThemeEnvironment: ViewModifier {
    let themeManager: ThemeManager

    public func body(content: Content) -> some View {
        content
            .environment(\.themeColors, themeManager.activeColorScheme)
            .environment(\.currentTheme, themeManager.currentTheme)
            .environment(themeManager)
    }
}

// MARK: - Environment Keys

private struct ThemeColorsKey: EnvironmentKey {
    static let defaultValue: ThemeColorScheme = .light
}

private struct CurrentThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .default
}

public extension EnvironmentValues {
    /// The current theme's color scheme
    var themeColors: ThemeColorScheme {
        get { self[ThemeColorsKey.self] }
        set { self[ThemeColorsKey.self] = newValue }
    }

    /// The current theme
    var currentTheme: Theme {
        get { self[CurrentThemeKey.self] }
        set { self[CurrentThemeKey.self] = newValue }
    }
}

// MARK: - View Extensions

public extension View {
    /// Applies theme environment to the view hierarchy.
    /// - Parameter themeManager: The theme manager to use
    /// - Returns: A view with theme environment applied
    func themeEnvironment(_ themeManager: ThemeManager) -> some View {
        modifier(ThemeEnvironment(themeManager: themeManager))
    }

    /// Automatically updates the theme manager's color scheme based on the system appearance.
    /// - Parameter themeManager: The theme manager to update
    /// - Returns: A view that responds to color scheme changes
    func automaticColorScheme(_ themeManager: ThemeManager) -> some View {
        #if canImport(UIKit)
        let notificationName = UIApplication.didBecomeActiveNotification
        #elseif canImport(AppKit)
        let notificationName = NSApplication.didBecomeActiveNotification
        #endif
        
        return onReceive(NotificationCenter.default.publisher(for: notificationName)) { _ in
            Task { @MainActor in
                updateColorScheme(themeManager)
            }
        }
        .onAppear {
            updateColorScheme(themeManager)
        }
    }

    @MainActor
    private func updateColorScheme(_ themeManager: ThemeManager) {
#if os(iOS) || os(tvOS) || os(visionOS)
        let colorScheme: ColorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
#elseif os(macOS)
        let colorScheme: ColorScheme = NSApp.effectiveAppearance.name == .darkAqua ? .dark : .light
#else
        let colorScheme: ColorScheme = .light
#endif
        themeManager.setColorScheme(colorScheme)
    }
}

// MARK: - Previews

#Preview("Theme Environment Demo") {
    let themeManager = ThemeManager()
    
    NavigationView {
        VStack(spacing: 20) {
            Text("Theme Environment")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Primary:")
                    Spacer()
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 40, height: 20)
                        .border(.gray, width: 1)
                }
                
                HStack {
                    Text("Secondary:")
                    Spacer()
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 40, height: 20)
                        .border(.gray, width: 1)
                }
                
                HStack {
                    Text("Accent:")
                    Spacer()
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: 40, height: 20)
                        .border(.gray, width: 1)
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button("Sample Button") {
                // Action
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Environment Demo")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    .themeEnvironment(themeManager)
}

#Preview("Environment with Different Themes") {
    TabView {
        // Default Theme
        VStack {
            Text("Default Theme")
                .font(.title2)
                .fontWeight(.semibold)
            
            ColorSwatchGrid()
        }
        .tabItem {
            Label("Default", systemImage: "paintbrush")
        }
        .themeEnvironment(ThemeManager(defaultTheme: .default))
        
        // Ocean Theme
        VStack {
            Text("Ocean Theme")
                .font(.title2)
                .fontWeight(.semibold)
            
            ColorSwatchGrid()
        }
        .tabItem {
            Label("Ocean", systemImage: "drop")
        }
        .themeEnvironment(ThemeManager(defaultTheme: .ocean))
        
        // Forest Theme
        VStack {
            Text("Forest Theme")
                .font(.title2)
                .fontWeight(.semibold)
            
            ColorSwatchGrid()
        }
        .tabItem {
            Label("Forest", systemImage: "leaf")
        }
        .themeEnvironment(ThemeManager(defaultTheme: .forest))
    }
}

private struct ColorSwatchGrid: View {
    @Environment(\.themeColors) var themeColors
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
            ColorSwatch(name: "Primary", color: themeColors.primary.color)
            ColorSwatch(name: "Secondary", color: themeColors.secondary.color)
            ColorSwatch(name: "Background", color: themeColors.background.color)
            ColorSwatch(name: "Accent", color: themeColors.accent.color)
            ColorSwatch(name: "Highlight", color: themeColors.highlight.color)
            ColorSwatch(name: "Contrast", color: themeColors.contrast.color)
        }
        .padding()
    }
}

private struct ColorSwatch: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                )
            
            Text(name)
                .font(.caption2)
                .fontWeight(.medium)
        }
    }
}

