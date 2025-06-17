//
//  ContentView.swift
//  ThemeKitDemo
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
import ThemeKit

/// Main content view that adapts to different platforms
struct ContentView: View {
    @Environment(\.themeColors) private var themeColors
    @Environment(ThemeManager.self) private var themeManager

#if os(iOS) || os(visionOS)
    @State private var selectedTab = 0
#endif

    var body: some View {
        ThemedView {
#if os(iOS) || os(visionOS)
            TabView(selection: $selectedTab) {
                DemoHomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)

                ThemeSelectorView()
                    .tabItem {
                        Image(systemName: "paintpalette.fill")
                        Text("Themes")
                    }
                    .tag(1)

                ComponentDemoView()
                    .tabItem {
                        Image(systemName: "rectangle.3.group.fill")
                        Text("Components")
                    }
                    .tag(2)

                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .accentColor(themeColors.accent)
#elseif os(macOS)
            NavigationSplitView {
                SidebarView()
                    .navigationSplitViewColumnWidth(min: 200, ideal: 250)
            } detail: {
                DemoHomeView()
            }
#elseif os(tvOS)
            TabView {
                DemoHomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                ThemeSelectorView()
                    .tabItem {
                        Image(systemName: "paintpalette.fill")
                        Text("Themes")
                    }

                ComponentDemoView()
                    .tabItem {
                        Image(systemName: "rectangle.3.group.fill")
                        Text("Components")
                    }
            }
#elseif os(watchOS)
            TabView {
                DemoHomeView()
                ThemeSelectorView()
                ComponentDemoView()
            }
            .tabViewStyle(.page)
#endif
        }
    }
}
