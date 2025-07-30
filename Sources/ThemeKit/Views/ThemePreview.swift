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

// MARK: - Previews

#Preview("Theme Previews - Light") {
    VStack(spacing: 16) {
        Text("Available Themes")
            .font(.headline)
            .padding(.bottom)
        
        HStack(spacing: 12) {
            ThemePreview(theme: .default, colorScheme: .light, isSelected: true)
            ThemePreview(theme: .ocean, colorScheme: .light)
            ThemePreview(theme: .forest, colorScheme: .light)
        }
    }
    .padding()
    .background(Color.primary.colorInvert())
}

#Preview("Theme Previews - Dark") {
    VStack(spacing: 16) {
        Text("Available Themes")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.bottom)
        
        HStack(spacing: 12) {
            ThemePreview(theme: .default, colorScheme: .dark, isSelected: true)
            ThemePreview(theme: .ocean, colorScheme: .dark)
            ThemePreview(theme: .forest, colorScheme: .dark)
        }
    }
    .padding()
    .background(Color.primary.colorInvert())
    .preferredColorScheme(.dark)
}

#Preview("Single Theme Preview") {
    VStack(spacing: 20) {
        ThemePreview(theme: .ocean, colorScheme: .light, isSelected: false)
            .scaleEffect(1.5)
        
        Text("Ocean Theme Preview")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}

#Preview("Theme Selection Interface") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            ForEach([Theme.default, .ocean, .forest], id: \.id) { theme in
                VStack(spacing: 8) {
                    ThemePreview(theme: theme, colorScheme: .light, isSelected: theme.name == "Ocean")
                    ThemePreview(theme: theme, colorScheme: .dark, isSelected: theme.name == "Ocean")
                        .overlay(
                            Text("Dark")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(2)
                                .background(.black.opacity(0.7))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .offset(x: 30, y: -30)
                        )
                }
            }
        }
        .padding()
    }
    .background(Color.secondary.opacity(0.1))
}
