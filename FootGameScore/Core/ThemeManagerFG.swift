import SwiftUI
import Combine

class ThemeManagerFG: ObservableObject {
    static let shared = ThemeManagerFG()
    
    @Published var currentTheme: ThemeModelFG = ThemeModelFG(
        id: "green",
        name: "Eco Green",
        primaryColorHex: "0E3B2E",
        accentColorHex: "19FF7A",
        isPremium: false,
        productID: nil
    )
    
    var accentColor: Color {
        Color(hex: currentTheme.accentColorHex)
    }
    
    var primaryColor: Color {
        Color(hex: currentTheme.primaryColorHex)
    }
}
