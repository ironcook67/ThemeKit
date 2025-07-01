//
//  ThemeManager.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import Combine

/// Manages the current theme and provides smooth animated transitions between themes.
/// Access the current theme colors through the ThemeManager to take advantage of
/// automatic detection of light and dark mode.
///
/// ThemeManager is an observable object that handles theme switching with animation
/// and automatically responds to system appearance changes. It provides both
/// programmatic theme control and automatic light/dark mode adaptation.
@Observable
@MainActor
public final class ThemeManager {
    // MARK: - Properties

    /// The currently active theme
    public private(set) var currentTheme: Theme

    /// The current color scheme (light/dark)
    public private(set) var currentColorScheme: ColorScheme = .light

    /// The active color scheme based on current theme and system appearance
    public var activeColorScheme: ThemeColorScheme {
        currentColorScheme == .dark ? currentTheme.dark : currentTheme.light
    }

    /// Available themes that can be selected
    public private(set) var availableThemes: [Theme]

    /// The duration of theme transition animations
    public var animationDuration: Double = 0.5

    /// The animation curve used for theme transitions
    public var animationCurve: Animation = .easeInOut(duration: 0.5)

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard
    private let themeKey = "ThemeKit.SelectedTheme"

    // MARK: - Initialization

    /// Creates a new theme manager with the specified themes.
    /// - Parameters:
    ///   - themes: Available themes (defaults to built-in themes)
    ///   - defaultTheme: The default theme to use (defaults to Theme.default)
    public init(themes: [Theme] = [.default, .ocean, .forest], defaultTheme: Theme = .default) {
        self.availableThemes = themes

        // Load saved theme or use default
        if let savedThemeData = userDefaults.data(forKey: themeKey),
           let savedTheme = try? JSONDecoder().decode(ThemeData.self, from: savedThemeData),
           let theme = themes.first(where: { $0.name == savedTheme.name }) {
            self.currentTheme = theme
        } else {
            self.currentTheme = defaultTheme
        }
    }

    // MARK: - Public Methods

    /// Sets the current theme with optional animation.
    /// - Parameters:
    ///   - theme: The theme to activate
    ///   - animated: Whether to animate the transition (default: true)
    public func setTheme(_ theme: Theme, animated: Bool = true) {
        guard theme.id != currentTheme.id else { return }

        if animated {
            withAnimation(animationCurve) {
                currentTheme = theme
            }
        } else {
            currentTheme = theme
        }

        saveCurrentTheme()
    }

    /// Updates the current color scheme (light/dark mode).
    /// - Parameters:
    ///   - colorScheme: The color scheme to use
    ///   - animated: Whether to animate the transition (default: true)
    public func setColorScheme(_ colorScheme: ColorScheme, animated: Bool = true) {
        guard colorScheme != currentColorScheme else { return }

        if animated {
            withAnimation(animationCurve) {
                currentColorScheme = colorScheme
            }
        } else {
            currentColorScheme = colorScheme
        }
    }

    /// Adds a new theme to the available themes list.
    /// - Parameter theme: The theme to add
    public func addTheme(_ theme: Theme) {
        guard !availableThemes.contains(where: { $0.id == theme.id }) else { return }
        availableThemes.append(theme)
    }

    /// Removes a theme from the available themes list.
    /// - Parameter theme: The theme to remove
    public func removeTheme(_ theme: Theme) {
        availableThemes.removeAll { $0.id == theme.id }

        // Switch to default theme if current theme was removed
        if currentTheme.id == theme.id {
            setTheme(.default)
        }
    }

    /// Updates the animation settings for theme transitions.
    /// - Parameters:
    ///   - duration: Animation duration in seconds
    ///   - curve: Animation curve type
    public func setAnimationSettings(duration: Double, curve: Animation? = nil) {
        animationDuration = duration
        animationCurve = curve ?? .easeInOut(duration: duration)
    }

    // MARK: - Private Methods

    private func saveCurrentTheme() {
        let themeData = ThemeData(name: currentTheme.name)
        if let encoded = try? JSONEncoder().encode(themeData) {
            userDefaults.set(encoded, forKey: themeKey)
        }
    }
}

// MARK: - Theme Data for Persistence

private struct ThemeData: Codable, Sendable {
    let name: String
}
