//
//  ThemeKitDemoApp.swift
//  ThemeKitDemo
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import ThemeKit

/// The main app entry point for ThemeKit Demo across all platforms
@main
struct ThemeKitDemoApp: App {
    @State private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeEnvironment(themeManager)
                .automaticColorScheme(themeManager)
        }
#if os(macOS)
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
#endif

#if os(macOS)
        Settings {
            SettingsView()
                .themeEnvironment(themeManager)
        }
#endif
    }
}

