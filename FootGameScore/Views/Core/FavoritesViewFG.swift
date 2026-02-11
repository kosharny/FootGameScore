import SwiftUI

struct FavoritesViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    
    var favoriteDrills: [DrillFG] {
        viewModel.drills.filter { $0.isFavorite }
    }
    
    var favoriteArticles: [ArticleFG] {
        viewModel.articles.filter { $0.isFavorite }
    }
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                HeaderFG(title: "Favorites")
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        if favoriteDrills.isEmpty && favoriteArticles.isEmpty {
                            EmptyStateFG(icon: "star.slash", title: "No favorites yet.")
                                .padding(.top, 50)
                        } else {
                            if !favoriteDrills.isEmpty {
                                SectionHeaderFG(title: "Drills")
                                    .padding(.horizontal)
                                ForEach(favoriteDrills) { drill in
                                    NavigationLink(destination: TasksViewFG(drill: drill)) {
                                        DrillCardFG(drill: drill)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            
                            if !favoriteArticles.isEmpty {
                                SectionHeaderFG(title: "Articles")
                                    .padding(.horizontal)
                                ForEach(favoriteArticles) { article in
                                    NavigationLink(destination: DetailsViewFG(article: article)) {
                                        ArticleCardFG(article: article)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 80)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
