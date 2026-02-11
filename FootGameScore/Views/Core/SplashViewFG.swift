import SwiftUI

struct SplashViewFG: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentViewFG()
        } else {
            ZStack {
                Color.fgBlack.ignoresSafeArea()
                
                VStack {
                    Image(systemName: "soccerball.inverse")
                        .font(.system(size: 80))
                        .foregroundColor(.fgNeon)
                    Text("FOOTGAME SCORE")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct ContentViewFG: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        if hasCompletedOnboarding {
            MainViewFG()
        } else {
            OnboardingViewFG()
        }
    }
}
