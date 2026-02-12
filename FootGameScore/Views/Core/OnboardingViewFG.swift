import SwiftUI

struct OnboardingViewFG: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPageFG(image: OnboardingImageFG.trainingImg, title: "Master Your Skills", description: "Learn elite finishing and tactical positioning."),
        OnboardingPageFG(image: OnboardingImageFG.statsImg, title: "Track Progress", description: "Visualize your growth with detailed stats."),
        OnboardingPageFG(image: OnboardingImageFG.proImg, title: "Become a Pro", description: "Unlock premium content and elevate your game.")
    ]
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                    .foregroundColor(.gray)
                    .padding()
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white.opacity(0.05))
                                    .frame(height: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.fgNeon.opacity(0.3), lineWidth: 1)
                                    )
                                
                                Image(pages[index].image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .cornerRadius(30)
                                    .clipped()
                            }
                            .padding(.horizontal, 30)
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            VStack(spacing: 15) {
                                Text(pages[index].title.uppercased())
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text(pages[index].description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 40)
                                    .lineSpacing(4)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.fgNeon : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding()
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.fgNeon)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .transition(.opacity)
    }
}

struct OnboardingPageFG {
    let image: String
    let title: String
    let description: String
}
