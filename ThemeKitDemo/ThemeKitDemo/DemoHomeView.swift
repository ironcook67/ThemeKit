//
//  DemoHomeView.swift
//  ThemeKitDemo
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import ThemeKit

/// Home view showcasing ThemeKit features
struct DemoHomeView: View {
    @Environment(\.themeColors) private var themeColors
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                featuresSection
                quickActionsSection

#if !os(watchOS)
                colorSwatchesSection
#endif
            }
            .padding()
        }
        .navigationTitle("ThemeKit Demo")
#if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.large)
#endif
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 60))
                .foregroundColor(themeColors.primary)

            Text("ThemeKit Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(themeColors.contrast)

            Text("Experience beautiful, animated theming for SwiftUI")
                .font(.subheadline)
                .foregroundColor(themeColors.contrast.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Features")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridColumns), spacing: 16) {
                FeatureCard(
                    icon: "paintbrush.fill",
                    title: "Six-Color System",
                    description: "Semantic color roles for consistent design"
                )

                FeatureCard(
                    icon: "sparkles",
                    title: "Animated Transitions",
                    description: "Smooth theme switching with beautiful animations"
                )

                FeatureCard(
                    icon: "moon.stars.fill",
                    title: "Auto Light/Dark",
                    description: "Automatic adaptation to system appearance"
                )

                FeatureCard(
                    icon: "square.and.arrow.down.fill",
                    title: "Persistent Themes",
                    description: "Saves user preferences between launches"
                )
            }
        }
    }

    private var quickActionsSection: some View {
        VStack(spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            VStack(spacing: 12) {
                ForEach(themeManager.availableThemes.prefix(3), id: \.id) { theme in
                    Button(action: {
                        themeManager.setTheme(theme)
                    }) {
                        HStack {
                            Text("Switch to \(theme.name)")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .background(themeColors.secondary)
                        .foregroundColor(themeColors.contrast)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

#if !os(watchOS)
    private var colorSwatchesSection: some View {
        VStack(spacing: 16) {
            Text("Current Theme Colors")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(themeColors.namedColors(), id: \.self) { namedColor in
                    ColorSwatch(namedColor: namedColor)
                }
            }
        }
    }
#endif

    private var gridColumns: Int {
#if os(watchOS)
        return 1
#elseif os(tvOS)
        return 4
#else
        return 2
#endif
    }
}

// MARK: - Sources/ThemeKitDemo/Views/ThemeSelectorView.swift

import SwiftUI
import ThemeKit

/// View for selecting and previewing themes
struct ThemeSelectorView: View {
    @Environment(\.themeColors) private var themeColors
    @Environment(ThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                themesSection
                animationSettingsSection
            }
            .padding()
        }
        .navigationTitle("Theme Selector")
#if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.large)
#endif
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 40))
                .foregroundColor(themeColors.primary)

            Text("Choose Your Theme")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(themeColors.contrast)

            Text("Current: \(themeManager.currentTheme.name)")
                .font(.subheadline)
                .foregroundColor(themeColors.contrast.opacity(0.8))
        }
    }

    private var themesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Themes")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridColumns), spacing: 16) {
                ForEach(themeManager.availableThemes, id: \.id) { theme in
                    ThemePreview(
                        theme: theme,
                        colorScheme: colorScheme,
                        isSelected: theme.id == themeManager.currentTheme.id
                    )
                    .onTapGesture {
                        themeManager.setTheme(theme)
                    }
#if !os(watchOS)
                    .scaleEffect(theme.id == themeManager.currentTheme.id ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3), value: themeManager.currentTheme.id)
#endif
                }
            }
        }
    }

    private var animationSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Animation Settings")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            VStack(spacing: 12) {
                Button("Fast Transitions (0.3s)") {
                    themeManager.setAnimationSettings(duration: 0.3)
                }
                .buttonStyle(DemoButtonStyle())

                Button("Default Transitions (0.5s)") {
                    themeManager.setAnimationSettings(duration: 0.5)
                }
                .buttonStyle(DemoButtonStyle())

                Button("Slow Transitions (1.0s)") {
                    themeManager.setAnimationSettings(duration: 1.0)
                }
                .buttonStyle(DemoButtonStyle())
            }
        }
    }

    private var gridColumns: Int {
#if os(watchOS)
        return 1
#elseif os(tvOS)
        return 3
#else
        return 2
#endif
    }
}

// MARK: - Sources/ThemeKitDemo/Views/ComponentDemoView.swift

import SwiftUI
import ThemeKit

/// View showcasing ThemeKit with various UI components
struct ComponentDemoView: View {
    @Environment(\.themeColors) private var themeColors
    @State private var sliderValue: Double = 50
    @State private var toggleValue: Bool = false
    @State private var segmentedSelection = 0
    @State private var textFieldValue = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                buttonsSection

#if !os(watchOS)
                controlsSection
                cardsSection
#endif
            }
            .padding()
        }
        .navigationTitle("Components")
#if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.large)
#endif
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.3.group.fill")
                .font(.system(size: 40))
                .foregroundColor(themeColors.primary)

            Text("Component Showcase")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(themeColors.contrast)

            Text("See how ThemeKit works with various UI components")
                .font(.subheadline)
                .foregroundColor(themeColors.contrast.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }

    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buttons")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            VStack(spacing: 12) {
                Button("Primary Button") { }
                    .buttonStyle(PrimaryButtonStyle())

                Button("Secondary Button") { }
                    .buttonStyle(SecondaryButtonStyle())

                Button("Accent Button") { }
                    .buttonStyle(AccentButtonStyle())

                Button("Destructive Button") { }
                    .buttonStyle(HighlightButtonStyle())
            }
        }
    }

#if !os(watchOS)
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Controls")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Slider (\(Int(sliderValue)))")
                        .foregroundColor(themeColors.contrast)
                    Slider(value: $sliderValue, in: 0...100)
                        .accentColor(themeColors.accent)
                }

                HStack {
                    Text("Toggle")
                        .foregroundColor(themeColors.contrast)
                    Spacer()
                    Toggle("", isOn: $toggleValue)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: themeColors.accent))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Segmented Control")
                        .foregroundColor(themeColors.contrast)
                    Picker("Options", selection: $segmentedSelection) {
                        Text("First").tag(0)
                        Text("Second").tag(1)
                        Text("Third").tag(2)
                    }
                    .pickerStyle(.segmented)
                }

#if os(iOS) || os(visionOS)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Field")
                        .foregroundColor(themeColors.contrast)
                    TextField("Enter text...", text: $textFieldValue)
                        .textFieldStyle(.roundedBorder)
                }
#endif
            }
        }
    }

    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cards & Lists")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            VStack(spacing: 12) {
                DemoCard(
                    title: "Primary Card",
                    description: "This card uses the primary color scheme",
                    backgroundColor: themeColors.primary,
                    foregroundColor: themeColors.background
                )

                DemoCard(
                    title: "Secondary Card",
                    description: "This card uses the secondary color scheme",
                    backgroundColor: themeColors.secondary,
                    foregroundColor: themeColors.contrast
                )

                DemoCard(
                    title: "Accent Card",
                    description: "This card uses the accent color scheme",
                    backgroundColor: themeColors.accent,
                    foregroundColor: themeColors.background
                )
            }
        }
    }
#endif
}

// MARK: - Sources/ThemeKitDemo/Views/SettingsView.swift

import SwiftUI
import ThemeKit

/// Settings view for the demo app
struct SettingsView: View {
    @Environment(\.themeColors) private var themeColors
    @Environment(ThemeManager.self) private var themeManager
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                themeInfoSection
                actionsSection
            }
            .padding()
        }
        .navigationTitle("Settings")
#if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.large)
#endif
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "gear")
                .font(.system(size: 40))
                .foregroundColor(themeColors.primary)

            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(themeColors.contrast)
        }
    }

    private var themeInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Theme Information")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            InfoRow(label: "Current Theme", value: themeManager.currentTheme.name)
            InfoRow(label: "Color Scheme", value: systemColorScheme == .dark ? "Dark" : "Light")
//            InfoRow(label: "Animation Duration", value: "\(themeManager.animationDuration, : "%.1f")s")
            InfoRow(label: "Animation Duration", value: "\(themeManager.animationDuration)s")
            InfoRow(label: "Available Themes", value: "\(themeManager.availableThemes.count)")
        }
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actions")
                .font(.headline)
                .foregroundColor(themeColors.contrast)

            VStack(spacing: 12) {
                Button("Reset to Default Theme") {
                    themeManager.setTheme(.default)
                }
                .buttonStyle(DemoButtonStyle())

                Button("Test Animation") {
                    let themes = themeManager.availableThemes
                    let currentIndex = themes.firstIndex(where: { $0.id == themeManager.currentTheme.id }) ?? 0
                    let nextIndex = (currentIndex + 1) % themes.count
                    themeManager.setTheme(themes[nextIndex])
                }
                .buttonStyle(DemoButtonStyle())
            }
        }
    }
}

// MARK: - Sources/ThemeKitDemo/Views/Components/FeatureCard.swift

import SwiftUI
import ThemeKit

/// A card showing a feature of ThemeKit
struct FeatureCard: View {
    @Environment(\.themeColors) private var themeColors

    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(themeColors.accent)

            Text(title)
                .font(.headline)
                .foregroundColor(themeColors.contrast)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.caption)
                .foregroundColor(themeColors.contrast.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(themeColors.secondary)
        .cornerRadius(12)
    }
}

// MARK: - Sources/ThemeKitDemo/Views/Components/ColorSwatch.swift

import SwiftUI
import ThemeKit
import ColorKit

/// A swatch showing a named color
struct ColorSwatch: View {
    @Environment(\.themeColors) private var themeColors
    let namedColor: NamedColor

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(namedColor.color)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(themeColors.contrast.opacity(0.2), lineWidth: 1)
                )

            Text(namedColor.name)
                .font(.subheadline)
                .foregroundColor(themeColors.contrast)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(themeColors.secondary.opacity(0.5))
        .cornerRadius(8)
    }
}

// MARK: - Sources/ThemeKitDemo/Views/Components/DemoCard.swift

import SwiftUI

/// A demo card component
struct DemoCard: View {
    let title: String
    let description: String
    let backgroundColor: Color
    let foregroundColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(foregroundColor)

            Text(description)
                .font(.subheadline)
                .foregroundColor(foregroundColor.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

// MARK: - Sources/ThemeKitDemo/Views/Components/InfoRow.swift

import SwiftUI
import ThemeKit

/// An information row for settings
struct InfoRow: View {
    @Environment(\.themeColors) private var themeColors

    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(themeColors.contrast)
            Spacer()
            Text(value)
                .foregroundColor(themeColors.contrast.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(themeColors.secondary.opacity(0.5))
        .cornerRadius(8)
    }
}

// MARK: - Sources/ThemeKitDemo/Views/SidebarView.swift (macOS)

#if os(macOS)
import SwiftUI
import ThemeKit

/// Sidebar for macOS navigation
struct SidebarView: View {
    @Environment(\.themeColors) private var themeColors
    @State private var selectedSection: SidebarSection? = .home

    enum SidebarSection: String, CaseIterable {
        case home = "Home"
        case themes = "Themes"
        case components = "Components"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .themes: return "paintpalette.fill"
            case .components: return "rectangle.3.group.fill"
            case .settings: return "gear"
            }
        }
    }

    var body: some View {
        List(SidebarSection.allCases, id: \.self, selection: $selectedSection) { section in
            NavigationLink(value: section) {
                Label(section.rawValue, systemImage: section.icon)
            }
        }
        .navigationTitle("ThemeKit Demo")
        .navigationDestination(for: SidebarSection.self) { section in
            destinationView(for: section)
        }
    }

    @ViewBuilder
    private func destinationView(for section: SidebarSection) -> some View {
        switch section {
        case .home:
            DemoHomeView()
        case .themes:
            ThemeSelectorView()
        case .components:
            ComponentDemoView()
        case .settings:
            SettingsView()
        }
    }
}
#endif

// MARK: - Sources/ThemeKitDemo/Styles/ButtonStyles.swift

import SwiftUI
import ThemeKit

/// Button style using primary color
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.themeColors) private var themeColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(themeColors.background)
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeColors.primary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Button style using secondary color
struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.themeColors) private var themeColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(themeColors.contrast)
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeColors.secondary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Button style using accent color
struct AccentButtonStyle: ButtonStyle {
    @Environment(\.themeColors) private var themeColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(themeColors.background)
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeColors.accent)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Button style using highlight color
struct HighlightButtonStyle: ButtonStyle {
    @Environment(\.themeColors) private var themeColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .foregroundColor(themeColors.background)
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeColors.highlight)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// General demo button style
struct DemoButtonStyle: ButtonStyle {
    @Environment(\.themeColors) private var themeColors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(themeColors.contrast)
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeColors.secondary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview Providers

#Preview("ContentView") {
    ContentView()
        .themeEnvironment(ThemeManager())
}

#Preview("DemoHomeView") {
    DemoHomeView()
        .themeEnvironment(ThemeManager())
}

#Preview("ThemeSelectorView") {
    ThemeSelectorView()
        .themeEnvironment(ThemeManager())
}

#Preview("ComponentDemoView") {
    ComponentDemoView()
        .themeEnvironment(ThemeManager())
}

#Preview("SettingsView") {
    SettingsView()
        .themeEnvironment(ThemeManager())
}
