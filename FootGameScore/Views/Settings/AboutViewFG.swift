import SwiftUI

struct AboutViewFG: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Custom Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("About")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible spacer for balance
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding(10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 15)
                .background(
                    Color.fgBlack.opacity(0.95)
                        .ignoresSafeArea(edges: .top)
                )
                
                Text("FootGame Score")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Version 1.0.0")
                    .foregroundColor(.gray)
                
                Text("The ultimate training companion for strikers. Improve your finishing, positioning, and mental game with elite drills and expert insights.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                
                Spacer()
                
                 Text("© 2024 FootGame Score")
                     .font(.caption)
                     .foregroundColor(.gray)
                     .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
}
