//
//  ThemePersistence.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import SwiftData
import Foundation

/// Handles theme persistence using both SwiftData and JSON
@MainActor
internal class ThemePersistence {
    private let userDefaults = UserDefaults.standard
    private let themeKey = "ThemeKit.SelectedTheme"
    private let colorSchemeKey = "ThemeKit.ColorScheme"
    private let autoDetectionKey = "ThemeKit.AutomaticColorSchemeDetection"
    
    // MARK: - SwiftData Persistence
    
    func saveToSwiftData(
        _ context: ModelContext,
        themeName: String,
        colorScheme: ColorScheme,
        automaticDetection: Bool
    ) {
        // Clear existing theme preferences
        let descriptor = FetchDescriptor<ThemePreference>()
        if let existing = try? context.fetch(descriptor).first {
            context.delete(existing)
        }
        
        // Insert new preference
        let preference = ThemePreference(
            themeName: themeName,
            colorScheme: colorScheme == .dark ? "dark" : "light",
            automaticDetection: automaticDetection
        )
        context.insert(preference)
        
        try? context.save()
    }
    
    func loadFromSwiftData(_ context: ModelContext) -> ThemePreference? {
        let descriptor = FetchDescriptor<ThemePreference>()
        return try? context.fetch(descriptor).first
    }
    
    // MARK: - UserDefaults Persistence
    
    func saveThemeToUserDefaults(themeName: String) {
        let themeData = ThemeData(name: themeName)
        if let encoded = try? JSONEncoder().encode(themeData) {
            userDefaults.set(encoded, forKey: themeKey)
        }
    }
    
    func loadThemeFromUserDefaults() -> String? {
        guard let savedThemeData = userDefaults.data(forKey: themeKey),
              let savedTheme = try? JSONDecoder().decode(ThemeData.self, from: savedThemeData) else {
            return nil
        }
        return savedTheme.name
    }
    
    func saveColorScheme(_ colorScheme: ColorScheme) {
        userDefaults.set(colorScheme == .dark ? "dark" : "light", forKey: colorSchemeKey)
    }
    
    func loadColorScheme() -> ColorScheme? {
        guard let savedColorScheme = userDefaults.object(forKey: colorSchemeKey) as? String else {
            return nil
        }
        return savedColorScheme == "dark" ? .dark : .light
    }
    
    func saveAutomaticDetection(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: autoDetectionKey)
    }
    
    func loadAutomaticDetection() -> Bool? {
        guard userDefaults.object(forKey: autoDetectionKey) != nil else {
            return nil
        }
        return userDefaults.bool(forKey: autoDetectionKey)
    }
    
    // MARK: - JSON Import/Export
    
    func exportThemesToJSON(_ themes: [Theme]) -> Data? {
        return try? JSONEncoder().encode(themes)
    }
    
    func importThemesFromJSON(_ data: Data) -> [Theme]? {
        return try? JSONDecoder().decode([Theme].self, from: data)
    }
    
    func saveThemesToFile(at url: URL, themes: [Theme]) throws {
        guard let data = exportThemesToJSON(themes) else {
            throw ThemeManagerError.encodingFailed
        }
        try data.write(to: url)
    }
    
    func loadThemesFromFile(at url: URL) throws -> [Theme] {
        let data = try Data(contentsOf: url)
        guard let themes = importThemesFromJSON(data) else {
            throw ThemeManagerError.decodingFailed
        }
        return themes
    }
}