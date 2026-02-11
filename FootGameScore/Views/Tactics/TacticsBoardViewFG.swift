import SwiftUI

struct TacticsBoardViewFG: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var players: [CGPoint] = [
        CGPoint(x: 100, y: 100),
        CGPoint(x: 200, y: 300),
        CGPoint(x: 150, y: 200)
    ]
    
    var body: some View {
        ZStack {
            Color.fgGreen.ignoresSafeArea()
            
            // Field Lines (Simplified)
            VStack {
                 Rectangle()
                     .stroke(Color.white.opacity(0.3), lineWidth: 2)
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .padding(20)
                     .overlay(
                         Circle()
                             .stroke(Color.white.opacity(0.3), lineWidth: 2)
                             .frame(width: 100, height: 100)
                     )
                     .overlay(
                         Rectangle()
                             .stroke(Color.white.opacity(0.3), lineWidth: 2)
                             .frame(width: 200, height: 100)
                             .offset(y: -250) // Goal area top (approx)
                     )
                     .overlay(
                         Rectangle()
                             .stroke(Color.white.opacity(0.3), lineWidth: 2)
                             .frame(width: 200, height: 100)
                             .offset(y: 250) // Goal area bottom (approx)
                     )
            }
            
            // Draggable Players
            ForEach(0..<players.count, id: \.self) { index in
                Circle()
                    .fill(index == 0 ? Color.fgRed : Color.fgNeon)
                    .frame(width: 30, height: 30)
                    .overlay(Text("\(index + 9)").font(.caption).bold())
                    .position(players[index])
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.players[index] = value.location
                            }
                    )
            }
            
            VStack {
                HeaderFG(title: "Tactics Board")
                Spacer()
                Text("Drag players to simulate positions")
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
            }
        }
    }
}
