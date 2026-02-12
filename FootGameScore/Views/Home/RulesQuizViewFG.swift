import SwiftUI

struct RulesQuizViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showResult = false
    @State private var selectedOption: Int? = nil
    @State private var isAnswered = false
    
    let questions: [RulesQuizQuestionFG] = [
        RulesQuizQuestionFG(question: "How many players are on a team on the field?", options: ["9", "10", "11", "12"], correctAnswerIndex: 2),
        RulesQuizQuestionFG(question: "What is the duration of a standard football match (without extra time)?", options: ["60 min", "80 min", "90 min", "100 min"], correctAnswerIndex: 2),
        RulesQuizQuestionFG(question: "Which part of the body can a field player NOT use?", options: ["Chest", "Head", "Hands", "Feet"], correctAnswerIndex: 2),
        RulesQuizQuestionFG(question: "What happens when a player receives a second yellow card?", options: ["Warning", "Substitution", "Red card", "Penalty"], correctAnswerIndex: 2),
        RulesQuizQuestionFG(question: "From where is a corner kick taken?", options: ["Penalty spot", "Goal line", "Corner arc", "Center circle"], correctAnswerIndex: 2),
        RulesQuizQuestionFG(question: "How far is the penalty spot from the goal line?", options: ["9 meters", "11 meters", "13 meters", "15 meters"], correctAnswerIndex: 1),
        RulesQuizQuestionFG(question: "Can a goal be scored directly from a throw-in?", options: ["Yes", "No", "Only by the captain", "Only in extra time"], correctAnswerIndex: 1)
    ]
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack {
                HeaderFG(title: "Rules Quiz", showSettings: false, centerTitle: true)
                
                if showResult {
                    resultView
                } else {
                    quizView
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
    
    private var quizView: some View {
        VStack(spacing: 30) {
            // Progress
            VStack(spacing: 10) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
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
                        if !isAnswered {
                            selectedOption = index
                            isAnswered = true
                            if index == questions[currentQuestionIndex].correctAnswerIndex {
                                score += 1
                            }
                        }
                    }) {
                        HStack {
                            Text(questions[currentQuestionIndex].options[index])
                                .fontWeight(.medium)
                            Spacer()
                            if isAnswered {
                                if index == questions[currentQuestionIndex].correctAnswerIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.fgNeon)
                                } else if index == selectedOption {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.fgRed)
                                }
                            }
                        }
                        .padding()
                        .background(optionBackground(for: index))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(optionStroke(for: index), lineWidth: 1)
                        )
                    }
                    .disabled(isAnswered)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            if isAnswered {
                PrimaryButtonFG(title: currentQuestionIndex < questions.count - 1 ? "Next Question" : "See Results") {
                    if currentQuestionIndex < questions.count - 1 {
                        currentQuestionIndex += 1
                        selectedOption = nil
                        isAnswered = false
                    } else {
                        showResult = true
                    }
                }
                .padding()
            }
        }
        .padding(.top)
    }
    
    private var resultView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: score >= 5 ? "trophy.fill" : "hand.thumbsup.fill")
                .font(.system(size: 100))
                .foregroundColor(.fgNeon)
            
            VStack(spacing: 10) {
                Text(score >= 5 ? "Excellent!" : "Good Effort!")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Text("You scored \(score) out of \(questions.count)")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            PrimaryButtonFG(title: "Finish") {
                viewModel.finishRulesQuiz(score: score)
                dismiss()
            }
            .padding()
        }
    }
    
    private func optionBackground(for index: Int) -> Color {
        if isAnswered {
            if index == questions[currentQuestionIndex].correctAnswerIndex {
                return Color.fgNeon.opacity(0.2)
            } else if index == selectedOption {
                return Color.fgRed.opacity(0.2)
            }
        }
        return Color.white.opacity(0.05)
    }
    
    private func optionStroke(for index: Int) -> Color {
        if isAnswered {
            if index == questions[currentQuestionIndex].correctAnswerIndex {
                return Color.fgNeon
            } else if index == selectedOption {
                return Color.fgRed
            }
        }
        return Color.white.opacity(0.1)
    }
}
