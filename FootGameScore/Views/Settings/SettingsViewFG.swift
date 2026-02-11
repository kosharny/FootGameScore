import SwiftUI

struct SettingsViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @EnvironmentObject var storeManager: StoreManagerFG
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                // Custom Header for Settings
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
                    
                    Text("Settings")
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
                

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Theme Selector
                        SectionHeaderFG(title: "Appearance")
                        GlassCardFG {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Choose your style")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                                HStack(spacing: 20) {
                                    // Default Theme
                                    ThemeButtonFG(theme: ViewModelFG.defaultTheme, isSelected: viewModel.currentTheme.id == ViewModelFG.defaultTheme.id) {
                                        viewModel.selectTheme(ViewModelFG.defaultTheme)
                                    }
                                    
                                    // Dark Theme (Premium)
                                    ThemeButtonFG(theme: ViewModelFG.premiumTheme, isSelected: viewModel.currentTheme.id == ViewModelFG.premiumTheme.id) {
                                        if StoreManagerFG.shared.hasAccess(to: ViewModelFG.premiumTheme) {
                                            viewModel.selectTheme(ViewModelFG.premiumTheme)
                                        } else {
                                            selectedThemeForPaywall = ViewModelFG.premiumTheme
                                        }
                                    }
                                    
                                    // Crimson Theme (Premium)
                                    ThemeButtonFG(theme: ViewModelFG.crimsonTheme, isSelected: viewModel.currentTheme.id == ViewModelFG.crimsonTheme.id) {
                                        if StoreManagerFG.shared.hasAccess(to: ViewModelFG.crimsonTheme) {
                                            viewModel.selectTheme(ViewModelFG.crimsonTheme)
                                        } else {
                                            selectedThemeForPaywall = ViewModelFG.crimsonTheme
                                        }
                                    }
                                }
                                .padding(.vertical, 10)
                            }
                        }
                        
                        // Premium Banner
                        if !viewModel.premiumEnabled {
                            Button(action: {
                                selectedThemeForPaywall = ViewModelFG.crimsonTheme
                            }) {
                                GlassCardFG {
                                    VStack(alignment: .leading, spacing: 15) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("GO PRO")
                                                    .font(.headline)
                                                    .fontWeight(.black)
                                                    .foregroundColor(.fgNeon)
                                                Text("Unlock your full potential")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "crown.fill")
                                                .foregroundColor(.yellow)
                                                .font(.largeTitle)
                                                .shadow(color: .yellow.opacity(0.5), radius: 10)
                                        }
                                    }
                                }
                            }
                        }
                        
                        SectionHeaderFG(title: "Support")
                        
                        Button(action: {
                            Task {
                                await storeManager.restorePurchases()
                            }
                        }) {
                            SettingsRowFG(icon: "arrow.clockwise", title: "Restore Purchases")
                        }
                        
                        NavigationLink(destination: AboutViewFG()) {
                            SettingsRowFG(icon: "info.circle", title: "About App")
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedThemeForPaywall) { theme in
            PaywallViewFG(theme: theme)
        }
    }
    
    @State private var selectedThemeForPaywall: ThemeModelFG?
}

struct ThemeButtonFG: View {
    let theme: ThemeModelFG
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                let color = Color(hex: theme.accentColorHex)
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [color.opacity(1.0), color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: isSelected ? 4 : 0)
                                .shadow(color: isSelected ? color : .clear, radius: 10)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else if theme.isPremium && !StoreManagerFG.shared.purchasedProductIDs.contains(theme.productID ?? "") {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .shadow(color: isSelected ? color.opacity(0.8) : .black.opacity(0.3), radius: 10)
                
                Text(theme.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .white : .gray)
                    .padding(.top, 5)
            }
        }
    }
}

struct SettingsRowFG: View {
    let icon: String
    let title: String
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        GlassCardFG {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.fgNeon)
                    .frame(width: 30)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}
