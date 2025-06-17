//
//  Theme.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI

/// A complete theme containing both light and dark color schemes.
///
/// A theme provides a cohesive visual identity by pairing complementary
/// light and dark color schemes that automatically adapt to the user's
/// system appearance preferences.
public struct Theme: Identifiable, Hashable, Sendable {
    /// The display name of the theme
    public let name: String

    /// The color scheme used in light mode
    public let light: ThemeColorScheme

    /// The color scheme used in dark mode
    public let dark: ThemeColorScheme

    /// Unique identifier for the theme
    public let id: UUID

    /// Creates a new theme with light and dark color schemes.
    /// - Parameters:
    ///   - name: The display name of the theme
    ///   - light: The color scheme for light mode
    ///   - dark: The color scheme for dark mode
    public init(name: String, light: ThemeColorScheme, dark: ThemeColorScheme) {
        self.name = name
        self.light = light
        self.dark = dark
        self.id = UUID()
    }

    /// Returns the appropriate color scheme for the given color scheme environment.
    /// - Parameter colorScheme: The current color scheme environment
    /// - Returns: The corresponding ThemeColorScheme
    public func colorScheme(for colorScheme: ColorScheme) -> ThemeColorScheme {
        switch colorScheme {
        case .light:
            return light
        case .dark:
            return dark
        @unknown default:
            return light
        }
    }
}

// MARK: - Default Themes

public extension Theme {
    /// The default theme with balanced light and dark schemes
    static let `default` = Theme(
        name: "Default",
        light: .light,
        dark: .dark
    )

    /// An ocean-inspired theme with blue and teal tones
    static let ocean = Theme(
        name: "Ocean",
        light: ThemeColorScheme(
            name: "Ocean Light",
            primary: Color(hexString: "#006994") ?? .blue,
            secondary: Color(hexString: "#E8F4F8") ?? .cyan,
            background: Color(hexString: "#F0F9FF") ?? .white,
            accent: Color(hexString: "#0891B2") ?? .teal,
            highlight: Color(hexString: "#FEF3C7") ?? .yellow,
            contrast: Color(hexString: "#1E293B") ?? .black
        ),
        dark: ThemeColorScheme(
            name: "Ocean Dark",
            primary: Color(hexString: "#38BDF8") ?? .blue,
            secondary: Color(hexString: "#1E293B") ?? .gray,
            background: Color(hexString: "#0F172A") ?? .black,
            accent: Color(hexString: "#22D3EE") ?? .cyan,
            highlight: Color(hexString: "#FDE047") ?? .yellow,
            contrast: Color(hexString: "#F8FAFC") ?? .white
        )
    )

    /// A forest-inspired theme with green and earth tones
    static let forest = Theme(
        name: "Forest",
        light: ThemeColorScheme(
            name: "Forest Light",
            primary: Color(hexString: "#16A34A") ?? .green,
            secondary: Color(hexString: "#F0FDF4") ?? .mint,
            background: Color(hexString: "#FEFFFE") ?? .white,
            accent: Color(hexString: "#EA580C") ?? .orange,
            highlight: Color(hexString: "#FDE047") ?? .yellow,
            contrast: Color(hexString: "#1C1917") ?? .black
        ),
        dark: ThemeColorScheme(
            name: "Forest Dark",
            primary: Color(hexString: "#4ADE80") ?? .green,
            secondary: Color(hexString: "#1C1917") ?? .gray,
            background: Color(hexString: "#0C0A09") ?? .black,
            accent: Color(hexString: "#FB923C") ?? .orange,
            highlight: Color(hexString: "#FACC15") ?? .yellow,
            contrast: Color(hexString: "#FAFAF9") ?? .white
        )
    )
}

