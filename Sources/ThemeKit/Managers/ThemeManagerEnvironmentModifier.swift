//
//  ThemeManagerEnvironmentModifier.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI

// MARK: - SwiftUI Integration

/// A SwiftUI view modifier that automatically updates the ThemeManager with the environment color scheme.
/// This provides an alternative approach for apps that prefer to use SwiftUI's environment-based detection.
@MainActor
public struct ThemeManagerEnvironmentModifier: ViewModifier {
    @Environment(\.colorScheme) private var environmentColorScheme

    private let themeManager: ThemeManager

    public init(themeManager: ThemeManager) {
        self.themeManager = themeManager
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: environmentColorScheme) { _, newColorScheme in
                if themeManager.automaticColorSchemeDetection {
                    themeManager.setColorScheme(
                        newColorScheme,
                        animated: true,
                        disableAutoDetection: false
                    )
                }
            }
            .onAppear {
                if themeManager.automaticColorSchemeDetection &&
                    themeManager.currentColorScheme != environmentColorScheme {
                    themeManager.setColorScheme(
                        environmentColorScheme,
                        animated: false,
                        disableAutoDetection: false
                    )
                }
            }
    }
}

public extension View {
    /// Applies automatic theme management based on the SwiftUI environment color scheme.
    /// - Parameter themeManager: The ThemeManager instance to update
    /// - Returns: A view that automatically updates the theme manager with environment changes
    func themeManagerEnvironment(_ themeManager: ThemeManager) -> some View {
        self.modifier(ThemeManagerEnvironmentModifier(themeManager: themeManager))
    }
}