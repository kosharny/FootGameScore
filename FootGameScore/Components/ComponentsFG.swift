import SwiftUI

// MARK: - Custom Tab Bar
struct CustomTabBarFG: View {
    @Binding var selectedTab: Int
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        HStack {
            TabBarItemFG(icon: "house.fill", isSelected: selectedTab == 0) { selectedTab = 0 }
            Spacer()
            TabBarItemFG(icon: "book.fill", isSelected: selectedTab == 1) { selectedTab = 1 }
            Spacer()
            TabBarItemFG(icon: "magnifyingglass", isSelected: selectedTab == 2) { selectedTab = 2 }
            Spacer()
            TabBarItemFG(icon: "chart.bar.fill", isSelected: selectedTab == 3) { selectedTab = 3 }
            Spacer()
            TabBarItemFG(icon: "star.fill", isSelected: selectedTab == 4) { selectedTab = 4 }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(Color.fgBlack.opacity(0.9))
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.fgNeon.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct TabBarItemFG: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isSelected ? .fgNeon : .gray)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(), value: isSelected)
        }
    }
}

// MARK: - Custom Header
struct HeaderFG: View {
    let title: String
    var showSettings: Bool = true
    var centerTitle: Bool = false
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        HStack {
            if centerTitle && showSettings {
                 // To center with settings button, we need a hidden spacer of same size
                 Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.clear)
                    .padding(10)
            }
            
            if !centerTitle {
                Text(title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            } else {
                Spacer()
                Text(title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            
            if showSettings {
                NavigationLink(destination: SettingsViewFG()) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.fgNeon)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            } else if centerTitle && !showSettings {
                 // Empty spacer to balance if needed or just centered
            }
        }
        .padding(.horizontal)
        .padding(.top, 10) // Adjusted top padding as background ignores safe area
        .padding(.bottom, 15)
        .background(
            Color.fgBlack.opacity(0.95) // Increased opacity to hide content behind
                .ignoresSafeArea(edges: .top)
        )
    }
}


// MARK: - Gradient Card
struct GlassCardFG<Content: View>: View {
    let content: Content
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.fgCardGradient)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Primary Button
struct PrimaryButtonFG: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.fgNeonGradient)
            .foregroundColor(.black)
            .cornerRadius(15)
            .shadow(color: .fgNeon.opacity(0.4), radius: 10, x: 0, y: 5)
        }
    }
}

// MARK: - Progress Bar
struct CustomProgressBarFG: View {
    var progress: CGFloat 
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 8)
                    .foregroundColor(.fgNeon)
                    .animation(.linear, value: progress)
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
    }
}

// MARK: - Empty State View
struct EmptyStateFG: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
