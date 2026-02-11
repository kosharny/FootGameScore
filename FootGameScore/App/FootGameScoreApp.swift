import SwiftUI

@main
struct FootGameScoreApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            SplashViewFG()
                .environmentObject(ViewModelFG())
                .environmentObject(StoreManagerFG.shared)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    TrackingManagerFG.shared.requestTrackingAuthorization()
                }
            }
        }
    }
}
