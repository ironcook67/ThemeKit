//
//  ThemePreview.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI

/// A view that displays a preview of a theme's color scheme.
///
/// This view is useful for theme selection interfaces, showing users
/// what a theme looks like before they apply it.
public struct ThemePreview: View {
    let theme: Theme
    let colorScheme: ColorScheme
    let isSelected: Bool

    /// Creates a theme preview.
    /// - Parameters:
    ///   - theme: The theme to preview
    ///   - colorScheme: The color scheme to show (light or dark)
    ///   - isSelected: Whether this theme is currently selected
    public init(theme: Theme, colorScheme: ColorScheme = .light, isSelected: Bool = false) {
        self.theme = theme
        self.colorScheme = colorScheme
        self.isSelected = isSelected
    }

    public var body: some View {
        let themeColors = theme.colorScheme(for: colorScheme)

        VStack(spacing: 8) {
            // Color swatches
            HStack(spacing: 4) {
                ForEach(themeColors.namedColors(), id: \.self) { namedColor in
                    Circle()
                        .fill(namedColor.color)
                        .frame(width: 12, height: 12)
                }
            }

            // Theme name
            Text(theme.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeColors.contrast.color)  // TODO: Clean up NamedColor usage
        }
        .padding(12)
        .background(themeColors.background.color)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSelected ? themeColors.accent.color : themeColors.secondary.color,   // TODO: Look into NamedColor and ShapeStyle
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
