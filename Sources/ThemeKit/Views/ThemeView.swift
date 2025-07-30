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
            .background(themeColors.background.color)       // TODO: Clean up NamedColor usage
            .foregroundStyle(themeColors.contrast.color)
    }
}

// MARK: - Previews

#Preview("Light Theme") {
    let themeManager = ThemeManager()
    
    ThemedView {
        VStack(spacing: 20) {
            Text("Welcome to ThemeKit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is a themed view that automatically adapts to the current theme's colors.")
                .multilineTextAlignment(.center)
                .padding()
            
            HStack(spacing: 16) {
                Button("Primary") {}
                    .buttonStyle(.borderedProminent)
                
                Button("Secondary") {}
                    .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    .themeEnvironment(themeManager)
    .preferredColorScheme(.light)
}

#Preview("Dark Theme") {
    let themeManager = ThemeManager()
    
    ThemedView {
        VStack(spacing: 20) {
            Text("Welcome to ThemeKit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is a themed view that automatically adapts to the current theme's colors.")
                .multilineTextAlignment(.center)
                .padding()
            
            HStack(spacing: 16) {
                Button("Primary") {}
                    .buttonStyle(.borderedProminent)
                
                Button("Secondary") {}
                    .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    .themeEnvironment(themeManager)
    .preferredColorScheme(.dark)
}

#Preview("Ocean Theme") {
    let themeManager = ThemeManager(themes: [.ocean], defaultTheme: .ocean)
    
    ThemedView {
        VStack(spacing: 20) {
            Text("Ocean Theme")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Deep blue colors inspired by the ocean.")
                .multilineTextAlignment(.center)
                .padding()
            
            HStack(spacing: 16) {
                Button("Dive In") {}
                    .buttonStyle(.borderedProminent)
                
                Button("Explore") {}
                    .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    .themeEnvironment(themeManager)
}
