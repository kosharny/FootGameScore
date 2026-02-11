import SwiftUI

struct SplashViewFG: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @State private var circleRotation: Double = 0.0
    @State private var shimmerOffset: CGFloat = -1.0
    
    var body: some View {
        if isActive {
            ContentViewFG()
        } else {
            ZStack {
                Color.fgBlack.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                Color.fgGreen,
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 230, height: 230)
                            .rotationEffect(Angle(degrees: circleRotation))
                        
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    
                    Text("FOOTGAME SCORE")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        .overlay(
                            GeometryReader { geo in
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .white, .clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: geo.size.width)
                                .offset(x: geo.size.width * shimmerOffset)
                            }
                                .mask(Text("FOOTGAME SCORE").font(.system(size: 26, weight: .bold, design: .rounded)))
                        )
                        .padding(.top, 10)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        circleRotation = 360
                    }
                    
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        shimmerOffset = 1.0
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
