import SwiftUI

struct MainViewFG: View {
    @State private var selectedTab = 0
    @EnvironmentObject var viewModel: ViewModelFG
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.fgBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                switch selectedTab {
                case 0:
                    NavigationView {
                        HomeViewFG()
                    }
                case 1:
                    NavigationView {
                        JournalViewFG()
                    }
                case 2:
                    NavigationView {
                        SearchViewFG()
                    }
                case 3:
                    NavigationView {
                        FavoritesViewFG()
                    }
                case 4:
                    NavigationView {
                        StatViewFG()
                    }
                default:
                    NavigationView {
                        HomeViewFG()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if viewModel.showTabBar {
                CustomTabBarFG(selectedTab: $selectedTab)
            }
        }
    }
}
