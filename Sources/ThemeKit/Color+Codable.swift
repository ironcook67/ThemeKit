//
//  Color+Codable.swift
//  ThemeKit
//
//  Created by Chon Torres on 6/24/25.
//

import SwiftUI

// MARK: - Color + Codable

extension Color: Codable {
    private struct ColorComponents: Codable {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let components = try container.decode(ColorComponents.self)
        
        self.init(
            red: components.red,
            green: components.green,
            blue: components.blue,
            opacity: components.alpha
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        // Extract color components
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let components = ColorComponents(
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            alpha: Double(alpha)
        )
        
        try container.encode(components)
    }
}