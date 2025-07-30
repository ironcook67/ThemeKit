//
//  ColorSchemeMonitor.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/16/25.
//

import SwiftUI
@preconcurrency import Combine
import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Monitors system color scheme changes and provides cross-platform compatibility
@MainActor
internal class ColorSchemeMonitor: @unchecked Sendable {
    
    // MARK: - Properties
    
    /// Cancellable for monitoring color scheme changes
    @ObservationIgnored
    private var colorSchemeUpdateCancellable: AnyCancellable?
    
    /// Callback when color scheme changes
    var onColorSchemeChange: ((ColorScheme) -> Void)?
    
    // MARK: - Cross-Platform Properties
    
    #if canImport(UIKit)
    private var systemDidBecomeActiveNotification: Notification.Name {
        UIApplication.didBecomeActiveNotification
    }
    
    private var currentSystemUserInterfaceStyle: UIUserInterfaceStyle {
        UITraitCollection.current.userInterfaceStyle
    }
    
    var systemColorScheme: ColorScheme {
        UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }
    #elseif canImport(AppKit)
    private var systemDidBecomeActiveNotification: Notification.Name {
        NSApplication.didBecomeActiveNotification
    }
    
    private var currentSystemUserInterfaceStyle: NSAppearance.Name {
        NSApp.effectiveAppearance.name
    }
    
    var systemColorScheme: ColorScheme {
        NSApp.effectiveAppearance.name == .darkAqua ? .dark : .light
    }
    #endif
    
    // MARK: - Publisher
    
    /// Publisher that emits when the system color scheme changes
    private var systemColorSchemePublisher: AnyPublisher<ColorScheme, Never> {
        NotificationCenter.default
            .publisher(for: systemDidBecomeActiveNotification)
            .map { [weak self] _ in self?.systemColorScheme ?? .light }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Public Methods
    
    /// Starts monitoring system color scheme changes
    /// - Parameter animationCurve: Animation to use when color scheme changes
    func startMonitoring(animationCurve: Animation) {
        // Cancel any existing monitoring
        stopMonitoring()
        
        // Monitor system color scheme changes
        colorSchemeUpdateCancellable = systemColorSchemePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newColorScheme in
                withAnimation(animationCurve) {
                    self?.onColorSchemeChange?(newColorScheme)
                }
            }
        
        // Also monitor trait collection changes for immediate responsiveness
        NotificationCenter.default.addObserver(
            forName: systemDidBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.syncWithSystemColorScheme(animated: true, animationCurve: animationCurve)
            }
        }
    }
    
    /// Stops monitoring system color scheme changes
    func stopMonitoring() {
        colorSchemeUpdateCancellable?.cancel()
        colorSchemeUpdateCancellable = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Manually syncs with the current system color scheme
    /// - Parameters:
    ///   - animated: Whether to animate the transition
    ///   - animationCurve: Animation curve to use
    func syncWithSystemColorScheme(animated: Bool, animationCurve: Animation) {
        let currentSystemColorScheme = systemColorScheme
        
        if animated {
            withAnimation(animationCurve) {
                onColorSchemeChange?(currentSystemColorScheme)
            }
        } else {
            onColorSchemeChange?(currentSystemColorScheme)
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        colorSchemeUpdateCancellable?.cancel()
        NotificationCenter.default.removeObserver(self)
    }
}