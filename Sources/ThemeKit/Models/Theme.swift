//
//  Theme.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import ColorKit

/// A complete theme containing both light and dark color schemes.
///
/// A theme provides a cohesive visual identity by pairing complementary
/// light and dark color schemes that automatically adapt to the user's
/// system appearance preferences.
public struct Theme: Identifiable, Hashable, Sendable, Codable {
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

    public init(name: String, light: ThemeColorScheme, dark: ThemeColorScheme, id: UUID) {
        self.name = name
        self.light = light
        self.dark = dark
        self.id = id
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        light = try container.decode(ThemeColorScheme.self, forKey: .light)
        dark = try container.decode(ThemeColorScheme.self, forKey: .dark)
        id = try container.decode(UUID.self, forKey: .id)
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
            primary: NamedColor("Ocean Deep Blue", hexString: "#006994"),
            secondary: NamedColor("Ocean Mist", hexString: "#E8F4F8"),
            background: NamedColor("Ocean Foam", hexString: "#F0F9FF"),
            accent: NamedColor("Ocean Teal", hexString: "#0891B2"),
            highlight: NamedColor("Ocean Sunlight", hexString: "#FEF3C7"),
            contrast: NamedColor("Ocean Depth", hexString: "#1E293B")
        ),
        dark: ThemeColorScheme(
            name: "Ocean Dark",
            primary: NamedColor("Ocean Sky Blue", hexString: "#38BDF8"),
            secondary: NamedColor("Ocean Night", hexString: "#1E293B"),
            background: NamedColor("Ocean Abyss", hexString: "#0F172A"),
            accent: NamedColor("Ocean Cyan", hexString: "#22D3EE"),
            highlight: NamedColor("Ocean Lightning", hexString: "#FDE047"),
            contrast: NamedColor("Ocean Surface", hexString: "#F8FAFC")
        )
    )

    /// A forest-inspired theme with green and earth tones
    static let forest = Theme(
        name: "Forest",
        light: ThemeColorScheme(
            name: "Forest Light",
            primary: NamedColor("Forest Pine", hexString: "#16A34A"),
            secondary: NamedColor("Forest Mint", hexString: "#F0FDF4"),
            background: NamedColor("Forest Snow", hexString: "#FEFFFE"),
            accent: NamedColor("Forest Autumn", hexString: "#EA580C"),
            highlight: NamedColor("Forest Sunbeam", hexString: "#FDE047"),
            contrast: NamedColor("Forest Bark", hexString: "#1C1917")
        ),
        dark: ThemeColorScheme(
            name: "Forest Dark",
            primary: NamedColor("Forest Lime", hexString: "#4ADE80"),
            secondary: NamedColor("Forest Shadow", hexString: "#1C1917"),
            background: NamedColor("Forest Earth", hexString: "#0C0A09"),
            accent: NamedColor("Forest Ember", hexString: "#FB923C"),
            highlight: NamedColor("Forest Glow", hexString: "#FACC15"),
            contrast: NamedColor("Forest Moonlight", hexString: "#FAFAF9")
        )
    )
}
