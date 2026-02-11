import SwiftUI

struct HomeViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @EnvironmentObject var storeManager: StoreManagerFG
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            VStack {
                HeaderFG(title: "Drill Center")
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        
                        // Daily Tip
                        ZStack(alignment: .leading) {
                            Image(OnboardingImageFG.tipBgImg)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 140)
                                .cornerRadius(20)
                                .clipped()
                                .overlay(
                                    Color.black.opacity(0.6)
                                        .cornerRadius(20)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.yellow)
                                        .font(.headline)
                                    Text("Tip of the Day")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                
                                if let tip = viewModel.articles.randomElement()?.content.prefix(120) {
                                    Text(tip + "...")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineLimit(3)
                                        .lineSpacing(2)
                                } else {
                                    Text("Consistency is the bridge between goals and accomplishment. Keep training.")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                            .padding(20)
                        }
                        .padding(.horizontal)
                        
                        if let drill = viewModel.drills.first {
                            SectionHeaderFG(title: "Featured Drill")
                                .padding(.horizontal)
                            NavigationLink(destination: TasksViewFG(drill: drill)) {
                                DrillCardFG(drill: drill)
                                    .padding(.horizontal)
                            }
                        } else {
                            // Fallback UI or empty check
                            Text("Loading Drills...")
                                .foregroundColor(.gray)
                                .onAppear {
                                    print("Drills count: \(viewModel.drills.count)")
                                }
                        }
                        
                        
                        
                        // 1. Training Program Card (Before Latest Intel)
                        SectionHeaderFG(title: "Special Programs")
                            .padding(.horizontal)
                        NavigationLink(destination: TrainingProgramViewFG()) {
                            GlassCardFG {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("STRIKER TRAINING")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Elite drills for forwards")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "target")
                                        .font(.title)
                                        .foregroundColor(.fgRed)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Recent Articles (Latest Intel)
                        if !viewModel.articles.isEmpty {
                            SectionHeaderFG(title: "Latest Intel")
                                .padding(.horizontal)
                            ForEach(viewModel.articles.prefix(3)) { article in
                                NavigationLink(destination: DetailsViewFG(article: article)) {
                                    ArticleCardFG(article: article)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        // 2. Nutrition Card (Below Latest Intel)
                        SectionHeaderFG(title: "Peak Performance")
                            .padding(.horizontal)
                        NavigationLink(destination: NutritionViewFG()) {
                            GlassCardFG {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("PRO NUTRITION")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Fuel your body correctly")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "leaf.fill")
                                        .font(.title)
                                        .foregroundColor(.fgGreen)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 80) // Space for TabBar
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SectionHeaderFG: View {
    let title: String
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DrillCardFG: View {
    let drill: DrillFG
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        GlassCardFG {
            HStack(spacing: 15) {
                // Discovery: Use first step image if main is empty
                let imgName = drill.imageName.isEmpty ? (drill.steps.first?.imageName ?? "placeholder") : drill.imageName
                
                Image(imgName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(drill.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                        if drill.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.fgNeon)
                        }
                    }
                    
                    HStack {
                        Label(drill.difficulty, systemImage: "speedometer")
                            .font(.caption2)
                            .foregroundColor(.fgNeon)
                        
                        Label(drill.duration, systemImage: "clock")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Text(drill.category)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.fgNeon.opacity(0.1))
                        .foregroundColor(.fgNeon)
                        .cornerRadius(5)
                }
            }
        }
    }
}

struct ArticleCardFG: View {
    let article: ArticleFG
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        GlassCardFG {
            HStack(spacing: 15) {
                Image(article.imageName.isEmpty ? "placeholder" : article.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(article.category.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.fgNeon)
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(article.readTime)
                            .font(.caption2)
                    }
                    .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
    }
}
