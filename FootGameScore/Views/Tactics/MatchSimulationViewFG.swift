import SwiftUI
import Combine

struct MatchSimulationViewFG: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var homeScore = 0
    @State private var awayScore = 0
    @State private var timer = 0
    @State private var isRunning = false
    
    let timerTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            
            VStack(spacing: 40) {
                HeaderFG(title: "Match Sim")
                
                HStack(spacing: 50) {
                    VStack {
                        Text("HOME")
                            .font(.headline)
                            .foregroundColor(.fgNeon)
                        Text("\(homeScore)")
                            .font(.system(size: 80, weight: .black))
                            .foregroundColor(.white)
                    }
                    
                    VStack {
                        Text("AWAY")
                            .font(.headline)
                            .foregroundColor(.fgRed)
                        Text("\(awayScore)")
                            .font(.system(size: 80, weight: .black))
                            .foregroundColor(.white)
                    }
                }
                
                Text(String(format: "%.1f'", Double(timer) / 10.0))
                    .font(.system(size: 40, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                
                Button(action: {
                    isRunning.toggle()
                }) {
                    Text(isRunning ? "PAUSE" : "KICK OFF")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .background(isRunning ? Color.fgRed : Color.fgNeon)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }
                
                Spacer()
            }
        }
        .onReceive(timerTimer) { _ in
            if isRunning {
                timer += 1
                if timer % 50 == 0 { // Random score logic
                    if Bool.random() {
                        homeScore += 1
                    } else {
                        awayScore += 1
                    }
                }
            }
        }
    }
}
