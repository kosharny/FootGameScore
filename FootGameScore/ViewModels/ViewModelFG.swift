import SwiftUI
import Combine

class ViewModelFG: ObservableObject {
    @Published var articles: [ArticleFG] = []
    @Published var drills: [DrillFG] = []
    @Published var userStats: UserStatsFG
    @Published var showTabBar: Bool = true
    
    // Premium & Theme
    @Published var premiumEnabled: Bool = false
    @Published var currentTheme: ThemeModelFG
    private var cancellables = Set<AnyCancellable>()
    
    // Theme Definitions
    static let defaultTheme = ThemeModelFG(
        id: "green",
        name: "Eco Green",
        primaryColorHex: "0E3B2E",
        accentColorHex: "19FF7A",
        isPremium: false,
        productID: nil
    )
    
    static let premiumTheme = ThemeModelFG(
        id: "dark",
        name: "Tactical Dark",
        primaryColorHex: "0B0B0F",
        accentColorHex: "808080",
        isPremium: true,
        productID: "premium_theme_battle_crimson" // Using IDs from checklist
    )
    
    static let crimsonTheme = ThemeModelFG(
        id: "crimson",
        name: "Battle Crimson",
        primaryColorHex: "4A0404",
        accentColorHex: "FF3B3B",
        isPremium: true,
        productID: "premium_theme_tactical_dark"
    )
    
    // Persistence Keys
    private let statsKey = "userStatsFG"
    
    init() {
        // Initialize with default theme first
        self.currentTheme = Self.defaultTheme
        
        // Initialize default stats
        self.userStats = UserStatsFG(
            completedDrills: 0,
            readArticles: 0,
            completedDrillIDs: [],
            readArticleIDs: [],
            favoriteDrills: [],
            favoriteArticles: [],
            recentActivity: [
                Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                Date(),
                Date()
            ],
            currentStreak: 4
        )
        
        loadData()
        setupStoreSubscription()
        loadPersistence()
    }
    
    private func setupStoreSubscription() {
        StoreManagerFG.shared.$purchasedProductIDs
            .sink { [weak self] purchasedIDs in
                let isPremium = !purchasedIDs.isEmpty
                self?.premiumEnabled = isPremium
                StorageServiceFG.shared.setPremium(isPremium)
                
                let savedThemeID = StorageServiceFG.shared.getSelectedThemeID()
                let resolvedTheme = Self.resolveTheme(
                    id: savedThemeID,
                    isPremium: isPremium
                )
                
                if self?.currentTheme.id != resolvedTheme.id {
                    self?.currentTheme = resolvedTheme
                    ThemeManagerFG.shared.currentTheme = resolvedTheme
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        if let url = Bundle.main.url(forResource: "articlesFG", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let loadedArticles = try? decoder.decode([ArticleFG].self, from: data) {
                self.articles = loadedArticles
            }
        }
        
        if let url = Bundle.main.url(forResource: "drillsFG", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let loadedDrills = try? decoder.decode([DrillFG].self, from: data) {
                self.drills = loadedDrills
            }
        }
    }
    
    private func loadPersistence() {
        // Load Premium status
        self.premiumEnabled = StorageServiceFG.shared.isPremium()
        
        let savedThemeID = StorageServiceFG.shared.getSelectedThemeID()
        let resolvedTheme = Self.resolveTheme(
            id: savedThemeID,
            isPremium: premiumEnabled
        )
        self.currentTheme = resolvedTheme
        ThemeManagerFG.shared.currentTheme = resolvedTheme
        
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(UserStatsFG.self, from: data) {
            self.userStats = decoded
            
            // Sync flags
            for i in 0..<articles.count {
                if userStats.favoriteArticles.contains(articles[i].id) {
                    articles[i].isFavorite = true
                }
                if userStats.readArticleIDs.contains(articles[i].id) {
                    articles[i].isRead = true
                }
            }
            
            for i in 0..<drills.count {
                if userStats.favoriteDrills.contains(drills[i].id) {
                    drills[i].isFavorite = true
                }
                if userStats.completedDrillIDs.contains(drills[i].id) {
                    drills[i].isCompleted = true
                }
            }
        }
    }
    
    func savePersistence() {
        if let encoded = try? JSONEncoder().encode(userStats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    func selectTheme(_ theme: ThemeModelFG) {
        if theme.isPremium {
            if !StoreManagerFG.shared.hasAccess(to: theme) {
                return
            }
        }
        
        self.currentTheme = theme
        ThemeManagerFG.shared.currentTheme = theme
        StorageServiceFG.shared.setSelectedTheme(id: theme.id)
    }
    
    static func resolveTheme(id: String?, isPremium: Bool) -> ThemeModelFG {
        guard let id = id else { return defaultTheme }
        
        if id == premiumTheme.id && isPremium {
            return premiumTheme
        } else if id == crimsonTheme.id && isPremium {
            return crimsonTheme
        } else if id == defaultTheme.id {
            return defaultTheme
        }
        
        return defaultTheme
    }
    
    func toggleFavorite(article: ArticleFG) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isFavorite.toggle()
            if articles[index].isFavorite {
                userStats.favoriteArticles.append(article.id)
            } else {
                userStats.favoriteArticles.removeAll(where: { $0 == article.id })
            }
            savePersistence()
        }
    }
    
    func toggleFavorite(drill: DrillFG) {
        if let index = drills.firstIndex(where: { $0.id == drill.id }) {
            drills[index].isFavorite.toggle()
            if drills[index].isFavorite {
                userStats.favoriteDrills.append(drill.id)
            } else {
                userStats.favoriteDrills.removeAll(where: { $0 == drill.id })
            }
            savePersistence()
        }
    }
    
    func markDrillComplete(drill: DrillFG) {
        if let index = drills.firstIndex(where: { $0.id == drill.id }) {
            if !drills[index].isCompleted {
                drills[index].isCompleted = true
                userStats.completedDrills += 1
                userStats.completedDrillIDs.append(drill.id)
                updateStreak()
                savePersistence()
            }
        }
    }
    
    func markArticleRead(article: ArticleFG) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            if !articles[index].isRead {
                articles[index].isRead = true
                userStats.readArticles += 1
                userStats.readArticleIDs.append(article.id)
                savePersistence()
            }
        }
    }
    
    private func updateStreak() {
        // Simple streak logic: check if last activity was yesterday
        let calendar = Calendar.current
        if let lastDate = userStats.recentActivity.last {
            if calendar.isDateInYesterday(lastDate) {
                userStats.currentStreak += 1
            } else if !calendar.isDateInToday(lastDate) {
                userStats.currentStreak = 1
            }
        } else {
            userStats.currentStreak = 1
        }
        userStats.recentActivity.append(Date())
    }
}

