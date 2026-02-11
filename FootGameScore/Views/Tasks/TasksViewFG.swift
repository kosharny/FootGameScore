import SwiftUI

struct TasksViewFG: View {
    let drill: DrillFG
    @EnvironmentObject var viewModel: ViewModelFG
    @Environment(\.presentationMode) var presentationMode
    @State private var currentStepIndex = -1 // -1 is Overview
    @State private var showFinishScreen = false
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ZStack {
            Color.fgBlack.ignoresSafeArea()
            
            if showFinishScreen {
                DrillFinishViewFG(drill: drill) {
                    presentationMode.wrappedValue.dismiss()
                }
            } else if currentStepIndex == -1 {
                // Overview
                DrillOverviewFG(drill: drill, onStart: {
                    withAnimation {
                        currentStepIndex = 0
                    }
                }, onBack: {
                    presentationMode.wrappedValue.dismiss()
                })
            } else {
                // Steps
                if currentStepIndex < drill.steps.count {
                    DrillStepViewFG(
                        step: drill.steps[currentStepIndex],
                        stepNumber: currentStepIndex + 1,
                        totalSteps: drill.steps.count,
                        onNext: {
                            if currentStepIndex < drill.steps.count - 1 {
                                withAnimation {
                                    currentStepIndex += 1
                                }
                            } else {
                                viewModel.markDrillComplete(drill: drill)
                                withAnimation {
                                    showFinishScreen = true
                                }
                            }
                        },
                        onBack: {
                            withAnimation {
                                if currentStepIndex > 0 {
                                    currentStepIndex -= 1
                                } else {
                                    currentStepIndex = -1
                                }
                            }
                        }
                    )
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

struct DrillOverviewFG: View {
    let drill: DrillFG
    let onStart: () -> Void
    let onBack: () -> Void
    @EnvironmentObject var viewModel: ViewModelFG
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Image(drill.imageName.isEmpty ? "placeholder" : drill.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                        .overlay(Color.black.opacity(0.3))
                    
                    LinearGradient(colors: [.clear, .fgBlack], startPoint: .center, endPoint: .bottom)
                    
                    HStack {
                        Button(action: onBack) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                        Button(action: { viewModel.toggleFavorite(drill: drill) }) {
                            Image(systemName: drill.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 30))
                                .foregroundColor(drill.isFavorite ? .fgRed : .white)
                                .padding()
                        }
                    }
                    .padding(.top, 40)
                    
                    VStack {
                        Spacer()
                        Text(drill.title)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Label(drill.difficulty, systemImage: "speedometer")
                        Spacer()
                        Label(drill.duration, systemImage: "clock")
                        Spacer()
                        Label(drill.category, systemImage: "tag")
                    }
                    .font(.subheadline)
                    .foregroundColor(.fgNeon)
                    .padding(.bottom, 10)
                    
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(drill.description)
                        .foregroundColor(.gray)
                    
                    if !drill.tacticsNote.isEmpty {
                        GlassCardFG {
                            VStack(alignment: .leading) {
                                Text("TACTICAL NOTE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.fgNeon)
                                Text(drill.tacticsNote)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if !drill.mentalNote.isEmpty {
                        GlassCardFG {
                            VStack(alignment: .leading) {
                                Text("MENTAL NOTE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.fgRed)
                                Text(drill.mentalNote)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    PrimaryButtonFG(title: "START DRILL", action: onStart, icon: "play.fill")
                        .padding(.bottom, 30)
                }
                .padding(20)
            }
        }
    }
}

struct DrillStepViewFG: View {
    let step: DrillStepFG
    let stepNumber: Int
    let totalSteps: Int
    let onNext: () -> Void
    let onBack: () -> Void
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        VStack {
            HeaderFG(title: "Step \(stepNumber)/\(totalSteps)", showSettings: false)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Image Card
                    GlassCardFG {
                        Image(step.imageName.isEmpty ? "placeholder" : step.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .frame(maxHeight: 250)
                            .shadow(radius: 5)
                            .padding(5)
                    }
                    .padding(.horizontal)
                    
                    // Instructions Card
                    GlassCardFG {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(step.title.uppercased())
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.fgNeon)
                            
                            Divider().background(Color.white.opacity(0.3))
                            
                            Text(step.description)
                                .font(.body)
                                .foregroundColor(.white)
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                    
                    // Navigation
                    HStack(spacing: 20) {
                        Button(action: onBack) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        PrimaryButtonFG(title: stepNumber == totalSteps ? "FINISH WORKOUT" : "NEXT STEP", action: onNext)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct DrillFinishViewFG: View {
    let drill: DrillFG
    let onClose: () -> Void
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ZStack {
            Color.fgBlack.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                GlassCardFG {
                    VStack(spacing: 30) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow.opacity(0.5), radius: 20, x: 0, y: 0)
                            .padding(.top, 20)
                        
                        Text("DRILL COMPLETE!")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 10) {
                            Text("You nailed it!")
                                .font(.title3)
                                .foregroundColor(.fgNeon)
                            Text(drill.title)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        PrimaryButtonFG(title: "Collect Rewards", action: onClose)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}
