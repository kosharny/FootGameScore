import SwiftUI

extension Color {
    // Main Brand Colors - Dynamic
    static var fgGreen: Color { ThemeManagerFG.shared.primaryColor }
    static var fgNeon: Color { ThemeManagerFG.shared.accentColor }
    static let fgBlack = Color(hex: "0B0B0F")
    static let fgWhite = Color(hex: "FFFFFF")
    static let fgRed = Color(hex: "FF3B3B")
    
    // Gradients - Dynamic
    static var fgBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.fgBlack, Color.fgGreen.opacity(0.6)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var fgCardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.fgBlack.opacity(0.6), Color.fgGreen.opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var fgNeonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.fgNeon, Color.fgNeon.opacity(0.7)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
