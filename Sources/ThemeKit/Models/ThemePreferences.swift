//
//  File.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/24/25.
//

import Foundation

/// Represents the different theme modes available to the user
public enum ThemeMode: String, CaseIterable, Codable {
    /// Always use light theme regardless of system settings
    case alwaysLight = "always_light"
    /// Always use dark theme regardless of system settings
    case alwaysDark = "always_dark"
    /// Follow the system's appearance settings (light/dark mode)
    case system = "system"

    /// Human-readable description of the theme mode
    public var description: String {
        switch self {
        case .alwaysLight:
            return "Always Light"
        case .alwaysDark:
            return "Always Dark"
        case .system:
            return "Follow System"
        }
    }
}

/// Holds theme preferences and current state for the ThemeManager
public struct ThemePreferences: Codable, Equatable {
    // MARK: - Properties

    /// The user's preferred theme mode (always light, always dark, or system)
    public let mode: ThemeMode

    /// The currently active theme based on the mode and system state
    public let currentTheme: Theme

    // MARK: - Initialization

    /// Creates theme preferences with the specified mode and current theme
    /// - Parameters:
    ///   - mode: The theme mode preference
    ///   - currentTheme: The currently active theme
    public init(mode: ThemeMode, currentTheme: Theme) {
        self.mode = mode
        self.currentTheme = currentTheme
    }

    /// Creates theme preferences with a default system mode
    /// - Parameter currentTheme: The currently active theme
    public init(currentTheme: Theme) {
        self.mode = .system
        self.currentTheme = currentTheme
    }

    // MARK: - Convenience Methods

    /// Determines if the theme should follow system appearance
    public var followsSystem: Bool {
        mode == .system
    }

    /// Determines if the theme is forced to a specific appearance
    public var isForced: Bool {
        mode != .system
    }

    /// Creates new preferences with an updated theme mode
    /// - Parameter newMode: The new theme mode to apply
    /// - Returns: Updated theme preferences
    public func updatingMode(_ newMode: ThemeMode) -> ThemePreferences {
        ThemePreferences(mode: newMode, currentTheme: currentTheme)
    }

    /// Creates new preferences with an updated current theme
    /// - Parameter newTheme: The new current theme
    /// - Returns: Updated theme preferences
    public func updatingCurrentTheme(_ newTheme: Theme) -> ThemePreferences {
        ThemePreferences(mode: mode, currentTheme: newTheme)
    }

    /// Resolves what the current theme should be based on mode and system state
    /// - Parameter systemIsInDarkMode: Whether the system is currently in dark mode
    /// - Returns: The theme that should be active
    public func resolvedThemeColorScheme(systemIsInDarkMode: Bool) -> ThemeColorScheme {
        switch mode {
        case .alwaysLight:
            return .light
        case .alwaysDark:
            return .dark
        case .system:
            return systemIsInDarkMode ? .dark : .light
        }
    }
}

// MARK: - Default Values

public extension ThemePreferences {
    /// Default theme preferences following system appearance with light theme
    @MainActor
    static let `default` = ThemePreferences(mode: .system, currentTheme: Theme(name: "default", light: .light, dark: .dark))
}
