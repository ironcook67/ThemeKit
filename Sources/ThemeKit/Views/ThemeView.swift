//
//  ThemeView.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI

/// A container view that automatically applies the current theme's background color.
///
/// Use this view as a base container to ensure consistent theming throughout your app.
/// It automatically uses the current theme's background color and responds to theme changes.
public struct ThemedView<Content: View>: View {
    @Environment(\.themeColors) private var themeColors

    private let content: Content

    /// Creates a themed view with the provided content.
    /// - Parameter content: The content to display within the themed container
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .background(themeColors.background)
            .foregroundStyle(themeColors.contrast)
    }
}
