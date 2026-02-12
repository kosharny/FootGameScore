import SwiftUI

struct StrikerTestViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var showResult = false
    @State private var selectedOptions: [StrikerAttributeFG: Int] = [:]
    
    let questions: [StrikerQuestionFG] = [
        StrikerQuestionFG(question: "What is your height?", options: ["Small", "Average", "Tall"], attribute: .height),
        StrikerQuestionFG(question: "What is your body type?", options: ["Skinny", "Muscular", "Overweight"], attribute: .bodyType),
        StrikerQuestionFG(question: "What is your dominant foot?", options: ["Left", "Right", "Both"], attribute: .foot),
        StrikerQuestionFG(question: "What is your main strength?", options: ["Speed", "Strength", "Agility", "Heading"], attribute: .strength)
    ]
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                HeaderFG(title: "Striker Test", showSettings: false, centerTitle: true)
                
                if showResult {
                    resultView
                } else {
                    testView
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
    
    private var testView: some View {
        VStack(spacing: 30) {
            // Progress
            VStack(spacing: 10) {
                HStack {
                    Text("Step \(currentQuestionIndex + 1) of \(questions.count)")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                    Text("\(Int(Double(currentQuestionIndex) / Double(questions.count) * 100))%")
                        .foregroundColor(.fgNeon)
                        .font(.caption)
                }
                CustomProgressBarFG(progress: CGFloat(currentQuestionIndex) / CGFloat(questions.count))
            }
            .padding(.horizontal)
            
            // Question
            GlassCardFG {
                Text(questions[currentQuestionIndex].question)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
            .padding(.horizontal)
            
            // Options
            VStack(spacing: 15) {
                ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                    Button(action: {
                        selectedOptions[questions[currentQuestionIndex].attribute] = index
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                        } else {
                            showResult = true
                        }
                    }) {
                        Text(questions[currentQuestionIndex].options[index])
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            if currentQuestionIndex > 0 {
                Button(action: {
                    currentQuestionIndex -= 1
                }) {
                    Text("Back")
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
            }
        }
        .padding(.top)
    }
    
    private var resultView: some View {
        let result = calculateResult()
        return VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.fill.viewfinder")
                .font(.system(size: 100))
                .foregroundColor(.fgNeon)
            
            VStack(spacing: 15) {
                Text("Your Optimal Position:")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Text(result.uppercased())
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
            GlassCardFG {
                Text(getDescription(for: result))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(.horizontal)
            
            Spacer()
            
            PrimaryButtonFG(title: "Complete") {
                viewModel.finishStrikerTest(result: result)
                dismiss()
            }
            .padding()
        }
    }
    
    private func calculateResult() -> String {
        let heightIdx = selectedOptions[.height] ?? 0
        let strengthIdx = selectedOptions[.strength] ?? 0
        
        // Logic:
        // Strength Index: 0: Speed, 1: Strength, 2: Agility, 3: Heading
        // Height Index: 0: Small, 1: Average, 2: Tall
        
        if strengthIdx == 0 || strengthIdx == 2 { // Speed or Agility
            if heightIdx == 0 || heightIdx == 1 {
                return "Flank Striker (Winger)"
            }
        }
        
        if heightIdx == 2 || strengthIdx == 1 || strengthIdx == 3 { // Tall, Strength or Heading
            return "Central Striker (Target Man)"
        }
        
        return "Complete Striker"
    }
    
    private func getDescription(for result: String) -> String {
        if result.contains("Flank") {
            return "You rely on speed and agility to beat defenders from the wide areas. Your movement is key to creating space."
        } else if result.contains("Central") {
            return "You are a powerhouse in the box. Excellent at holding up the ball and winning aerial duels."
        } else {
            return "A versatile attacker who can adapt to any situation. You have a balanced set of physical and technical skills."
        }
    }
}
