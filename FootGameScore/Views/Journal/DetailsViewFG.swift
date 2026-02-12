import SwiftUI

struct DetailsViewFG: View {
    let article: ArticleFG
    @EnvironmentObject var viewModel: ViewModelFG
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ZStack {
            Color.fgBlack.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header Image Area
                    ZStack(alignment: .topLeading) {
                        Image(article.imageName.isEmpty ? "placeholder" : article.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipped()
                            .overlay(Color.black.opacity(0.3))
                        
                        LinearGradient(colors: [.clear, .fgBlack], startPoint: .center, endPoint: .bottom)
                        
                        HStack {
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Spacer()
                            Button(action: { viewModel.toggleFavorite(article: article) }) {
                                Image(systemName: article.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 30))
                                    .foregroundColor(article.isFavorite ? .fgRed : .white)
                                    .padding()
                            }
                        }
                        .padding(.top, 40)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(article.category.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.fgNeon)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.fgNeon.opacity(0.2))
                            .cornerRadius(5)
                        
                        Text(article.title)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Text(article.subtitle)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Divider()
                            .background(Color.gray)
                        
                        // Paragraphs with visual border
                        VStack(spacing: 20) {
                            ForEach(article.content.components(separatedBy: "\n").filter { !$0.isEmpty }, id: \.self) { paragraph in
                                Text(paragraph)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                                    .padding()
                                    .background(Color.fgBlack.opacity(0.5))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.fgNeon.opacity(0.3), lineWidth: 1) // Visual border in accent color
                                    )
                            }
                        }
                        
                        Spacer(minLength: 30)
                        
                        // Make as Read Button
                        Button(action: {
                            viewModel.markArticleRead(article: article)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Make as Read")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.fgNeon)
                                .cornerRadius(15)
                                .shadow(color: .fgNeon.opacity(0.5), radius: 10)
                        }
                        .padding(.top, 20)
                    }
                    .padding(20)
                    .background(Color.fgBlack)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.showTabBar = false
        }
        .onDisappear {
            viewModel.showTabBar = true
        }
    }
}
