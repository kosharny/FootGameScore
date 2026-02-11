import Foundation

struct ArticleFG: Codable, Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let content: String
    let imageName: String
    let category: String
    let readTime: String
    var isFavorite: Bool
    var isRead: Bool
}

struct DrillStepFG: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let imageName: String
}

struct DrillFG: Codable, Identifiable {
    let id: UUID
    let title: String
    let difficulty: String
    let duration: String
    let category: String
    let description: String
    let tacticsNote: String
    let mentalNote: String
    let steps: [DrillStepFG]
    let imageName: String
    var isCompleted: Bool
    var isFavorite: Bool
}

struct UserStatsFG: Codable {
    var completedDrills: Int
    var readArticles: Int
    var completedDrillIDs: [UUID]
    var readArticleIDs: [UUID]
    var favoriteDrills: [UUID]
    var favoriteArticles: [UUID]
    var recentActivity: [Date]
    var currentStreak: Int
}
