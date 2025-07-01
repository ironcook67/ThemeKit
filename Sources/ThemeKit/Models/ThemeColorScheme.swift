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
public struct ThemeColorScheme: Identifiable, Hashable, Sendable, Codable {
    /// A tuple containing all six colors in the scheme
    public typealias SchemeColors = (
        primary: Color,
        secondary: Color,
        background: Color,
        accent: Color,
        highlight: Color,
        contrast: Color
    )

    // MARK: - Properties

    /// The name of this color scheme
    public let name: String

    /// Primary color for main brand elements and actions
    public let primary: Color

    /// Secondary color for subtle UI components
    public let secondary: Color

    /// Background color for the app's base UI
    public let background: Color

    /// Accent color for interactive elements
    public let accent: Color

    /// Highlight color for emphasis elements
    public let highlight: Color

    /// Contrast color for text and icons
    public let contrast: Color

    public var id: String { name }

    // MARK: - Initializers

    /// Creates a new theme color scheme with individual color parameters.
    /// - Parameters:
    ///   - name: The name of the color scheme
    ///   - primary: Primary color for main brand elements
    ///   - secondary: Secondary color for subtle UI components
    ///   - background: Background color for the app's base UI
    ///   - accent: Accent color for interactive elements
    ///   - highlight: Highlight color for emphasis elements
    ///   - contrast: Contrast color for text and icons
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
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.accent = accent
        self.highlight = highlight
        self.contrast = contrast
    }

    /// Creates a new theme color scheme using a tuple of colors.
    /// - Parameters:
    ///   - name: The name of the color scheme
    ///   - colors: A tuple containing all six colors
    public init(name: String, colors: SchemeColors) {
        self.name = name
        self.primary = colors.primary
        self.secondary = colors.secondary
        self.background = colors.background
        self.accent = colors.accent
        self.highlight = colors.highlight
        self.contrast = colors.contrast
    }

    // MARK: - Public Methods

    /// Returns all colors as a tuple for easy destructuring.
    /// - Returns: A tuple containing all six scheme colors
    public func schemeColors() -> SchemeColors {
        (primary, secondary, background, accent, highlight, contrast)
    }

    /// Returns an array of named colors for display purposes.
    /// - Parameter prefix: Optional prefix to prepend to color names
    /// - Returns: Array of NamedColor objects from ColorKit
    public func namedColors(_ prefix: String = "") -> [NamedColor] {
        let prependedString = prefix.isEmpty ? "" : "\(prefix) "
        return [
            NamedColor("\(prependedString)Primary", color: primary),
            NamedColor("\(prependedString)Secondary", color: secondary),
            NamedColor("\(prependedString)Background", color: background),
            NamedColor("\(prependedString)Accent", color: accent),
            NamedColor("\(prependedString)Highlight", color: highlight),
            NamedColor("\(prependedString)Contrast", color: contrast)
        ]
    }
}

// MARK: - Default Color Schemes

public extension ThemeColorScheme {
    /// A light color scheme with carefully chosen colors for optimal readability
    static let light = ThemeColorScheme(
        name: "Light",
        primary: Color(hexString: "#4A90E2") ?? .blue,     // Soft Blue
        secondary: Color(hexString: "#D9E2EC") ?? .gray,   // Sky Gray
        background: Color(hexString: "#FFFFFF") ?? .white, // White
        accent: Color(hexString: "#FF6B6B") ?? .red,       // Coral
        highlight: Color(hexString: "#FFE066") ?? .yellow, // Lemon Yellow
        contrast: Color(hexString: "#2E2E2E") ?? .black    // Charcoal
    )

    /// A dark color scheme optimized for low-light environments
    static let dark = ThemeColorScheme(
        name: "Dark",
        primary: Color(hexString: "#7BB3F0") ?? .blue,     // Lighter Blue
        secondary: Color(hexString: "#3A3A3C") ?? .gray,   // Dark Gray
        background: Color(hexString: "#1C1C1E") ?? .black, // Near Black
        accent: Color(hexString: "#FF8A80") ?? .red,       // Soft Coral
        highlight: Color(hexString: "#FFD54F") ?? .yellow, // Warm Yellow
        contrast: Color(hexString: "#FFFFFF") ?? .white    // White
    )
}
