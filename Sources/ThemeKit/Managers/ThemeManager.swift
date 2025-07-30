//
//  ThemeManager.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import ColorKit
import SwiftData

/// Manages the current theme and provides smooth animated transitions between themes.
/// Access the current theme colors through the ThemeManager to take advantage of
/// automatic detection of light and dark mode.
///
/// ThemeManager is an observable object that handles theme switching with animation
/// and automatically responds to system appearance changes. It provides both
/// programmatic theme control and automatic light/dark mode adaptation.
@Observable
@MainActor
public final class ThemeManager: @unchecked Sendable {
    // MARK: - Properties

    /// The currently active theme
    public private(set) var currentTheme: Theme

    /// The current color scheme (light/dark) - automatically updated by system
    public private(set) var currentColorScheme: ColorScheme = .light

    /// The active color scheme based on current theme and system appearance
    public var activeColorScheme: ThemeColorScheme {
        currentColorScheme == .dark ? currentTheme.dark : currentTheme.light
    }

    /// Available themes that can be selected
    public private(set) var availableThemes: [Theme]
    
    /// Optional SwiftData model context for persistence
    public private(set) var modelContext: ModelContext?

    /// The duration of theme transition animations
    public var animationDuration: Double = 0.5

    /// The animation curve used for theme transitions
    public var animationCurve: Animation = .easeInOut(duration: 0.5)

    /// Whether to automatically respond to system color scheme changes
    public var automaticColorSchemeDetection: Bool = true {
        didSet {
            if automaticColorSchemeDetection && !oldValue {
                // Re-enable automatic detection
                setupColorSchemeMonitoring()
            } else if !automaticColorSchemeDetection && oldValue {
                // Disable automatic detection
                colorSchemeMonitor.stopMonitoring()
            }
        }
    }

    // MARK: - Private Properties

    /// Handles persistence operations
    private let persistence = ThemePersistence()
    
    /// Monitors color scheme changes
    private let colorSchemeMonitor = ColorSchemeMonitor()

    // MARK: - Initialization

    /// Creates a new theme manager with the specified themes.
    /// - Parameters:
    ///   - themes: Available themes (defaults to built-in themes)
    ///   - defaultTheme: The default theme to use (defaults to Theme.default)
    ///   - automaticDetection: Whether to automatically detect system color scheme changes (default: true)
    ///   - modelContext: Optional SwiftData model context for persistence
    public init(
        themes: [Theme] = [.default, .ocean, .forest],
        defaultTheme: Theme = .default,
        automaticDetection: Bool = true,
        modelContext: ModelContext? = nil
    ) {
        self.availableThemes = themes
        self.automaticColorSchemeDetection = automaticDetection
        self.modelContext = modelContext
        
        // Initialize with default theme first
        self.currentTheme = defaultTheme

        // Load saved theme preferences
        loadSavedPreferences(themes: themes, defaultTheme: defaultTheme)
        
        // Setup color scheme monitoring callback
        colorSchemeMonitor.onColorSchemeChange = { [weak self] newColorScheme in
            guard let self = self, self.automaticColorSchemeDetection else { return }
            if newColorScheme != self.currentColorScheme {
                self.currentColorScheme = newColorScheme
                self.persistence.saveColorScheme(newColorScheme)
            }
        }

        // Setup automatic color scheme monitoring if enabled
        if automaticColorSchemeDetection {
            setupColorSchemeMonitoring()
        }
    }

    // MARK: - Public Methods

    /// Sets the current theme with optional animation.
    /// - Parameters:
    ///   - theme: The theme to activate
    ///   - animated: Whether to animate the transition (default: true)
    public func setTheme(_ theme: Theme, animated: Bool = true) {
        guard theme.id != currentTheme.id else { return }

        if animated {
            withAnimation(animationCurve) {
                currentTheme = theme
            }
        } else {
            currentTheme = theme
        }

        saveCurrentTheme()
    }

    /// Updates the current color scheme (light/dark mode).
    /// - Parameters:
    ///   - colorScheme: The color scheme to use
    ///   - animated: Whether to animate the transition (default: true)
    ///   - disableAutoDetection: Whether to disable automatic detection when manually setting (default: true)
    public func setColorScheme(
        _ colorScheme: ColorScheme,
        animated: Bool = true,
        disableAutoDetection: Bool = true
    ) {
        guard colorScheme != currentColorScheme else { return }

        // Disable automatic detection if user manually sets color scheme
        if disableAutoDetection {
            automaticColorSchemeDetection = false
            persistence.saveAutomaticDetection(false)
        }

        if animated {
            withAnimation(animationCurve) {
                currentColorScheme = colorScheme
            }
        } else {
            currentColorScheme = colorScheme
        }

        persistence.saveColorScheme(colorScheme)
    }

    /// Enables automatic system color scheme detection and immediately syncs with system.
    /// - Parameter animated: Whether to animate the transition to current system scheme
    public func enableAutomaticColorSchemeDetection(animated: Bool = true) {
        automaticColorSchemeDetection = true
        persistence.saveAutomaticDetection(true)

        // Immediately sync with current system color scheme
        let currentSystemColorScheme = colorSchemeMonitor.systemColorScheme

        if currentSystemColorScheme != currentColorScheme {
            if animated {
                withAnimation(animationCurve) {
                    currentColorScheme = currentSystemColorScheme
                }
            } else {
                currentColorScheme = currentSystemColorScheme
            }
            persistence.saveColorScheme(currentSystemColorScheme)
        }

        setupColorSchemeMonitoring()
    }

    /// Disables automatic system color scheme detection.
    public func disableAutomaticColorSchemeDetection() {
        automaticColorSchemeDetection = false
        persistence.saveAutomaticDetection(false)
        colorSchemeMonitor.stopMonitoring()
    }

    /// Manually syncs the current color scheme with the system color scheme.
    /// - Parameter animated: Whether to animate the transition (default: true)
    public func syncWithSystemColorScheme(animated: Bool = true) {
        colorSchemeMonitor.syncWithSystemColorScheme(animated: animated, animationCurve: animationCurve)
    }

    /// Adds a new theme to the available themes list.
    /// - Parameter theme: The theme to add
    public func addTheme(_ theme: Theme) {
        guard !availableThemes.contains(where: { $0.id == theme.id }) else { return }
        availableThemes.append(theme)
    }

    /// Removes a theme from the available themes list.
    /// - Parameter theme: The theme to remove
    public func removeTheme(_ theme: Theme) {
        availableThemes.removeAll { $0.id == theme.id }

        // Switch to default theme if current theme was removed
        if currentTheme.id == theme.id {
            setTheme(.default)
        }
    }

    /// Updates the animation settings for theme transitions.
    /// - Parameters:
    ///   - duration: Animation duration in seconds
    ///   - curve: Animation curve type
    public func setAnimationSettings(duration: Double, curve: Animation? = nil) {
        animationDuration = duration
        animationCurve = curve ?? .easeInOut(duration: duration)
    }
    
    // MARK: - JSON Import/Export Methods
    
    /// Exports themes to JSON data
    /// - Parameter themes: Array of themes to export (defaults to available themes)
    /// - Returns: JSON data representation of the themes
    public func exportThemesToJSON(themes: [Theme]? = nil) -> Data? {
        let themesToExport = themes ?? availableThemes
        return persistence.exportThemesToJSON(themesToExport)
    }
    
    /// Imports themes from JSON data
    /// - Parameter data: JSON data containing theme definitions
    /// - Returns: Array of imported themes
    public func importThemesFromJSON(_ data: Data) -> [Theme]? {
        return persistence.importThemesFromJSON(data)
    }
    
    /// Saves themes to a JSON file
    /// - Parameters:
    ///   - url: File URL to save to
    ///   - themes: Array of themes to save (defaults to available themes)
    public func saveThemesToFile(at url: URL, themes: [Theme]? = nil) throws {
        let themesToSave = themes ?? availableThemes
        try persistence.saveThemesToFile(at: url, themes: themesToSave)
    }
    
    /// Loads themes from a JSON file
    /// - Parameter url: File URL to load from
    /// - Returns: Array of loaded themes
    public func loadThemesFromFile(at url: URL) throws -> [Theme] {
        return try persistence.loadThemesFromFile(at: url)
    }

    // MARK: - Private Methods
    
    /// Loads saved preferences from SwiftData or UserDefaults
    private func loadSavedPreferences(themes: [Theme], defaultTheme: Theme) {
        // First try SwiftData, then fall back to UserDefaults
        if let modelContext = modelContext,
           let preference = persistence.loadFromSwiftData(modelContext),
           let theme = themes.first(where: { $0.name == preference.themeName }) {
            self.currentTheme = theme
            self.currentColorScheme = preference.colorScheme == "dark" ? .dark : .light
            self.automaticColorSchemeDetection = preference.automaticDetection
        } else {
            // Load from UserDefaults
            if let themeName = persistence.loadThemeFromUserDefaults(),
               let theme = themes.first(where: { $0.name == themeName }) {
                self.currentTheme = theme
            }
            
            if let savedColorScheme = persistence.loadColorScheme() {
                self.currentColorScheme = savedColorScheme
            } else {
                // Initialize with current system color scheme
                self.currentColorScheme = colorSchemeMonitor.systemColorScheme
            }

            // Load automatic detection preference
            if let automaticDetection = persistence.loadAutomaticDetection() {
                self.automaticColorSchemeDetection = automaticDetection
            }
        }
    }

    /// Sets up monitoring for system color scheme changes
    private func setupColorSchemeMonitoring() {
        colorSchemeMonitor.startMonitoring(animationCurve: animationCurve)
    }

    private func saveCurrentTheme() {
        // Save to SwiftData if available
        if let modelContext = modelContext {
            persistence.saveToSwiftData(
                modelContext,
                themeName: currentTheme.name,
                colorScheme: currentColorScheme,
                automaticDetection: automaticColorSchemeDetection
            )
        }
        
        // Also save to UserDefaults as backup
        persistence.saveThemeToUserDefaults(themeName: currentTheme.name)
    }
}
