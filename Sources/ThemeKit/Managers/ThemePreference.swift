//
//  ThemePreference.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftData
import Foundation

/// SwiftData model for persisting theme preferences
@Model
public final class ThemePreference {
    public var themeName: String
    public var colorScheme: String
    public var automaticDetection: Bool
    public var createdAt: Date
    
    public init(themeName: String, colorScheme: String, automaticDetection: Bool) {
        self.themeName = themeName
        self.colorScheme = colorScheme
        self.automaticDetection = automaticDetection
        self.createdAt = Date()
    }
}

/// Theme Manager Errors
public enum ThemeManagerError: Error {
    case encodingFailed
    case decodingFailed
}

/// Theme Data for Persistence
internal struct ThemeData: Codable, Sendable {
    let name: String
}