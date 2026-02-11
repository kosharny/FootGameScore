import SwiftUI

@main
struct FootGameScoreApp: App {
    var body: some Scene {
        WindowGroup {
            SplashViewFG()
                .environmentObject(ViewModelFG())
                .environmentObject(StoreManagerFG.shared)
        }
    }
}
