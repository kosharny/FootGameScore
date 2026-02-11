import SwiftUI

struct JournalViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @State private var filter = 0 // 0: All, 1: Drills, 2: Articles
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                HeaderFG(title: "Journal")
                
                // Filter Segmented Control
                HStack {
                    FilterButtonFG(title: "All", isSelected: filter == 0) { filter = 0 }
                    FilterButtonFG(title: "Drills", isSelected: filter == 1) { filter = 1 }
                    FilterButtonFG(title: "Articles", isSelected: filter == 2) { filter = 2 }
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        if viewModel.userStats.recentActivity.isEmpty {
                            EmptyStateFG(icon: "book.closed", title: "No activity yet. Start training!")
                                .padding(.top, 50)
                        } else {
                            // Logic to show history would go here.
                            // Since we only track counts and arrays of IDs in simplified Stats,
                            // we will show completed items here as a "History".
                            
                            if filter == 0 || filter == 1 {
                                ForEach(viewModel.drills.filter { $0.isCompleted }) { drill in
                                    NavigationLink(destination: TasksViewFG(drill: drill)) {
                                        DrillCardFG(drill: drill)
                                    }
                                }
                            }
                            
                            if filter == 0 || filter == 2 {
                                ForEach(viewModel.articles.filter { $0.isRead }) { article in
                                    NavigationLink(destination: DetailsViewFG(article: article)) {
                                        ArticleCardFG(article: article)
                                    }
                                }
                            }
                        }
                        
                         Spacer(minLength: 80)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct FilterButtonFG: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.fgNeon : Color.white.opacity(0.1))
                .foregroundColor(isSelected ? .black : .white)
                .cornerRadius(20)
        }
    }
}
