import SwiftUI

struct TrainingProgramViewFG: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ZStack {
            Color.fgBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("FORWARD TRAINING")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.fgNeon)
                    
                    Spacer()
                    
                    // Invisible spacer for balance
                    Circle().fill(Color.clear).frame(width: 44, height: 44).padding()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        // Title Infographic - Enhanced
                        ZStack {
                            Image("drills_main") // Mocking a background image if available or just using a name
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .overlay(Color.black.opacity(0.5))
                            
                            VStack(spacing: 10) {
                                Image(systemName: "target")
                                    .font(.system(size: 50))
                                    .foregroundColor(.fgNeon)
                                    .shadow(color: .fgNeon.opacity(0.8), radius: 15)
                                
                                Text("STRIKER ELITE")
                                    .font(.system(size: 32, weight: .black))
                                    .foregroundColor(.white)
                                
                                Text("8-WEEK PERFORMANCE PROGRAM")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.fgNeon)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(20)
                            }
                        }
                        .cornerRadius(25)
                        .padding(.horizontal)
                        
                        // Intro Card
                        GlassCardFG {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Become a clinical finisher. This program focuses on explosive movement, precision, and the champion's mindset.")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(4)
                                
                                HStack(spacing: 20) {
                                    Label("High Intensity", systemImage: "flame.fill").font(.caption).foregroundColor(.orange)
                                    Label("Intermediate", systemImage: "star.fill").font(.caption).foregroundColor(.yellow)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Phase 1: Warmup
                        InfographicSectionFG(title: "01. EXPLOSIVE WARMUP", icon: "bolt.fill", color: .fgNeon) {
                            InfographicRowFG(text: "Dynamic stretching (10 min)")
                            InfographicRowFG(text: "High knees & butt kicks (3 sets)")
                            InfographicRowFG(text: "Short 10m acceleration bursts (5 reps)")
                            InfographicRowFG(text: "Ankle mobility exercises")
                        }
                        
                        // Phase 2: Technical
                        InfographicSectionFG(title: "02. FINISHING CLINIC", icon: "scope", color: .fgRed) {
                            InfographicRowFG(text: "One-touch finishing from crosses (20 reps)")
                            InfographicRowFG(text: "Weak foot accuracy drills (15 reps)")
                            InfographicRowFG(text: "Volley technique focus (10 reps)")
                            InfographicRowFG(text: "Curling shots from edge of box")
                        }
                        
                        // Phase 3: Tactical
                        InfographicSectionFG(title: "03. MOVEMENT & POSITIONING", icon: "person.3.fill", color: .blue) {
                            InfographicRowFG(text: "Blind-side runs visualization")
                            InfographicRowFG(text: "Hold-up play: shielding the ball")
                            InfographicRowFG(text: "Penalty box awareness & timing")
                            InfographicRowFG(text: "Attacking the near post")
                        }
                        
                        // Phase 4: Mental Focus
                        InfographicSectionFG(title: "04. THE KILLER INSTINCT", icon: "brain.head.profile", color: .purple) {
                            InfographicRowFG(text: "Match scenario visualization (5 min)")
                            InfographicRowFG(text: "Breathing techniques for composure")
                            InfographicRowFG(text: "Analyzing elite strikers' footage")
                            InfographicRowFG(text: "Goal setting & tracking")
                        }
                        
                        // Phase 5: Recovery
                        InfographicSectionFG(title: "05. RECOVERY & PREP", icon: "leaf.fill", color: .green) {
                            InfographicRowFG(text: "Foam rolling (Calves, Quads, GIutes)")
                            InfographicRowFG(text: "Static stretching for flexibility")
                            InfographicRowFG(text: "Ice baths or contrast showers")
                            InfographicRowFG(text: "Nutritional timing focus")
                        }
                        
                        // Program Goals
                        VStack(alignment: .leading, spacing: 15) {
                            Text("WEEKLY PROGRESS GOALS")
                                .font(.headline)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            GlassCardFG {
                                VStack(spacing: 15) {
                                    GoalRowFG(goal: "Score 50+ focused reps per week")
                                    GoalRowFG(goal: "Decrease 20m sprint time by 0.1s")
                                    GoalRowFG(goal: "Master weak foot volley technique")
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct GoalRowFG: View {
    let goal: String
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.fgNeon)
            Text(goal)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct InfographicSectionFG<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            GlassCardFG {
                VStack(alignment: .leading, spacing: 12) {
                    content
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
}

struct InfographicRowFG: View {
    let text: String
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.fgNeon)
                .frame(width: 6, height: 6)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct TrainingProgramViewFG_Previews: PreviewProvider {
    static var previews: some View {
        TrainingProgramViewFG()
    }
}
