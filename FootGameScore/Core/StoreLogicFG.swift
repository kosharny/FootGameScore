import Foundation

struct ThemeModelFG: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let primaryColorHex: String
    let accentColorHex: String
    let isPremium: Bool
    let productID: String?
}

class StorageServiceFG {
    static let shared = StorageServiceFG()
    private let defaults = UserDefaults.standard
    
    private let premiumKey = "isPremiumFG"
    private let selectedThemeKey = "selectedThemeIDFG"
    
    func setPremium(_ value: Bool) {
        defaults.set(value, forKey: premiumKey)
    }
    
    func isPremium() -> Bool {
        defaults.bool(forKey: premiumKey)
    }
    
    func setSelectedTheme(id: String) {
        defaults.set(id, forKey: selectedThemeKey)
    }
    
    func getSelectedThemeID() -> String? {
        defaults.string(forKey: selectedThemeKey)
    }
}
