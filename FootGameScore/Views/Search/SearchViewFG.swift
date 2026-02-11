import SwiftUI

struct SearchViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    
    let categories = ["Technique", "Tactics", "Fitness", "Mental", "Health", "Finishing"]
    
    var filteredDrills: [DrillFG] {
        viewModel.drills.filter { drill in
            (searchText.isEmpty || drill.title.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategory == nil || drill.category == selectedCategory)
        }
    }
    
    var filteredArticles: [ArticleFG] {
        viewModel.articles.filter { article in
            (searchText.isEmpty || article.title.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategory == nil || article.category == selectedCategory)
        }
    }
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                HeaderFG(title: "Search")
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search drills, articles...", text: $searchText)
                        .foregroundColor(.white)
                        .disableAutocorrection(true)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            FilterButtonFG(title: category, isSelected: selectedCategory == category) {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Results
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        if !filteredDrills.isEmpty {
                            SectionHeaderFG(title: "Drills")
                                .padding(.horizontal)
                            ForEach(filteredDrills) { drill in
                                NavigationLink(destination: TasksViewFG(drill: drill)) {
                                    DrillCardFG(drill: drill)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        if !filteredArticles.isEmpty {
                            SectionHeaderFG(title: "Articles")
                                .padding(.horizontal)
                            ForEach(filteredArticles) { article in
                                NavigationLink(destination: DetailsViewFG(article: article)) {
                                    ArticleCardFG(article: article)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        if filteredDrills.isEmpty && filteredArticles.isEmpty {
                            EmptyStateFG(icon: "magnifyingglass", title: "No results found.")
                                .padding(.top, 50)
                        }
                        
                        Spacer(minLength: 80)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
