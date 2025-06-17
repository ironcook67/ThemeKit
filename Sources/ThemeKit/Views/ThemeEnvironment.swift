//
//  ThemeEnvironment.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI

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
        onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
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

