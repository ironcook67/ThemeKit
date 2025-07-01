//
//  ThemeColorScheme.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import ColorKit
import SwiftUI

/// A color scheme that defines the six core colors used throughout a theme.
///
/// This structure provides a consistent color palette with clearly defined roles:
/// - **Primary**: Main brand elements and primary actions (buttons, links)
/// - **Secondary**: Subtle UI components (card borders, backgrounds)
/// - **Background**: Base color for the app's background
/// - **Accent**: Interactive elements requiring attention (call-to-actions)
/// - **Highlight**: Sparingly used for emphasis (tags, warnings)
/// - **Contrast**: Text and icons requiring maximum legibility
///
/// Each color is represented as a `NamedColor` from ColorKit, providing enhanced debugging
/// capabilities, intelligent JSON serialization, and metadata preservation.
public struct ThemeColorScheme: Identifiable, Hashable, Sendable, Codable {
    /// A tuple containing all six named colors in the scheme
    public typealias SchemeColors = (
        primary: NamedColor,
        secondary: NamedColor,
        background: NamedColor,
        accent: NamedColor,
        highlight: NamedColor,
        contrast: NamedColor
    )

    // MARK: - Properties

    /// The name of this color scheme
    public let name: String

    /// Primary color for main brand elements and actions
    public let primary: NamedColor

    /// Secondary color for subtle UI components
    public let secondary: NamedColor

    /// Background color for the app's base UI
    public let background: NamedColor

    /// Accent color for interactive elements
    public let accent: NamedColor

    /// Highlight color for emphasis elements
    public let highlight: NamedColor

    /// Contrast color for text and icons
    public let contrast: NamedColor

    public var id: String { name }

    // MARK: - Initializers

    /// Creates a new theme color scheme with individual NamedColor parameters.
    /// - Parameters:
    ///   - name: The name of the color scheme
    ///   - primary: Primary NamedColor for main brand elements
    ///   - secondary: Secondary NamedColor for subtle UI components
    ///   - background: Background NamedColor for the app's base UI
    ///   - accent: Accent NamedColor for interactive elements
    ///   - highlight: Highlight NamedColor for emphasis elements
    ///   - contrast: Contrast NamedColor for text and icons
    public init(
        name: String,
        primary: NamedColor,
        secondary: NamedColor,
        background: NamedColor,
        accent: NamedColor,
        highlight: NamedColor,
        contrast: NamedColor
    ) {
        self.name = name
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.accent = accent
        self.highlight = highlight
        self.contrast = contrast
    }

    /// Creates a new theme color scheme using a tuple of NamedColors.
    /// - Parameters:
    ///   - name: The name of the color scheme
    ///   - colors: A tuple containing all six NamedColors
    public init(name: String, colors: SchemeColors) {
        self.name = name
        self.primary = colors.primary
        self.secondary = colors.secondary
        self.background = colors.background
        self.accent = colors.accent
        self.highlight = colors.highlight
        self.contrast = colors.contrast
    }

    /// Creates a new theme color scheme from Color values, automatically converting them to NamedColors.
    /// - Parameters:
    ///   - name: The name of the color scheme
    ///   - primary: Primary Color for main brand elements
    ///   - secondary: Secondary Color for subtle UI components
    ///   - background: Background Color for the app's base UI
    ///   - accent: Accent Color for interactive elements
    ///   - highlight: Highlight Color for emphasis elements
    ///   - contrast: Contrast Color for text and icons
    public init(
        name: String,
        primary: Color,
        secondary: Color,
        background: Color,
        accent: Color,
        highlight: Color,
        contrast: Color
    ) {
        self.name = name
        self.primary = NamedColor("\(name) Primary", color: primary)
        self.secondary = NamedColor("\(name) Secondary", color: secondary)
        self.background = NamedColor("\(name) Background", color: background)
        self.accent = NamedColor("\(name) Accent", color: accent)
        self.highlight = NamedColor("\(name) Highlight", color: highlight)
        self.contrast = NamedColor("\(name) Contrast", color: contrast)
    }

    // MARK: - Public Methods

    /// Returns all NamedColors as a tuple for easy destructuring.
    /// - Returns: A tuple containing all six scheme NamedColors
    public func schemeColors() -> SchemeColors {
        (primary, secondary, background, accent, highlight, contrast)
    }

    /// Returns an array of all NamedColors in the scheme.
    /// - Returns: Array of NamedColor objects from the scheme
    public func namedColors() -> [NamedColor] {
        [primary, secondary, background, accent, highlight, contrast]
    }

    /// Returns an array of SwiftUI Colors for backwards compatibility.
    /// - Returns: Array of Color objects extracted from the NamedColors
    public func colors() -> [Color] {
        [primary.color, secondary.color, background.color, accent.color, highlight.color, contrast.color]
    }

    /// Creates a new theme color scheme with modified intensity for all colors.
    /// - Parameter intensity: The intensity level to apply to all colors
    /// - Returns: A new ThemeColorScheme with adjusted color intensities
    public func withIntensity(_ intensity: ColorIntensity) -> ThemeColorScheme {
        ThemeColorScheme(
            name: "\(name) (\(intensity.rawValue.capitalized))",
            primary: NamedColor.colorWithIntensity("\(primary.name) \(intensity.rawValue.capitalized)",
                                                   baseColor: primary.color,
                                                   intensity: intensity),
            secondary: NamedColor.colorWithIntensity("\(secondary.name) \(intensity.rawValue.capitalized)",
                                                     baseColor: secondary.color,
                                                     intensity: intensity),
            background: background, // Keep background at full intensity
            accent: NamedColor.colorWithIntensity("\(accent.name) \(intensity.rawValue.capitalized)",
                                                  baseColor: accent.color,
                                                  intensity: intensity),
            highlight: NamedColor.colorWithIntensity("\(highlight.name) \(intensity.rawValue.capitalized)",
                                                     baseColor: highlight.color,
                                                     intensity: intensity),
            contrast: contrast // Keep contrast at full intensity for readability
        )
    }
}

// MARK: - Default Color Schemes

public extension ThemeColorScheme {
    /// A light color scheme with carefully chosen colors for optimal readability
    static let light = ThemeColorScheme(
        name: "Light",
        primary: NamedColor("Soft Blue", hexString: "#4A90E2"),
        secondary: NamedColor("Sky Gray", hexString: "#D9E2EC"),
        background: NamedColor("White", hexString: "#FFFFFF"),
        accent: NamedColor("Coral", hexString: "#FF6B6B"),
        highlight: NamedColor("Lemon Yellow", hexString: "#FFE066"),
        contrast: NamedColor("Charcoal", hexString: "#2E2E2E")
    )

    /// A dark color scheme optimized for low-light environments
    static let dark = ThemeColorScheme(
        name: "Dark",
        primary: NamedColor("Lighter Blue", hexString: "#7BB3F0"),
        secondary: NamedColor("Dark Gray", hexString: "#3A3A3C"),
        background: NamedColor("Near Black", hexString: "#1C1C1E"),
        accent: NamedColor("Soft Coral", hexString: "#FF8A80"),
        highlight: NamedColor("Warm Yellow", hexString: "#FFD54F"),
        contrast: NamedColor("White", hexString: "#FFFFFF")
    )

    /// A color scheme using system colors for dynamic appearance
    static let system = ThemeColorScheme(
        name: "System",
        primary: NamedColor("System Primary", color: .accentColor),
        secondary: NamedColor("System Secondary", color: .secondary),
        background: NamedColor("System Background", color: .primary),
        accent: NamedColor("System Accent", color: .blue),
        highlight: NamedColor("System Highlight", color: .yellow),
        contrast: NamedColor("System Contrast", color: .primary)
    )
}

// MARK: - Convenience Extensions

public extension ThemeColorScheme {
    /// Creates a subtle variant of the color scheme with reduced intensity
    var subtle: ThemeColorScheme {
        withIntensity(.tertiary)
    }

    /// Creates a muted variant of the color scheme with low intensity
    var muted: ThemeColorScheme {
        withIntensity(.quaternary)
    }

    /// Creates a very subtle variant of the color scheme with minimal intensity
    var whisper: ThemeColorScheme {
        withIntensity(.quinary)
    }
}
