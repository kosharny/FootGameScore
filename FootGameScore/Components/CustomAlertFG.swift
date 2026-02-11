import SwiftUI

struct CustomAlertFG: View {
    let title: String
    let message: String
    let primaryButton: AlertButtonFG
    let secondaryButton: AlertButtonFG?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            GlassCardFG {
                VStack(spacing: 20) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 12) {
                        Button(action: primaryButton.action) {
                            Text(primaryButton.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryButton.isPrimary ? Color.fgNeon : Color.white.opacity(0.1))
                                .foregroundColor(primaryButton.isPrimary ? .black : .white)
                                .cornerRadius(12)
                        }
                        
                        if let secondary = secondaryButton {
                            Button(action: secondary.action) {
                                Text(secondary.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
                .frame(width: 300)
            }
        }
    }
}

struct AlertButtonFG {
    let title: String
    var isPrimary: Bool = false
    let action: () -> Void
}

extension View {
    func customAlert(isPresented: Binding<Bool>, alert: CustomAlertFG) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                alert
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeIn(duration: 0.1), value: isPresented.wrappedValue)
    }
}
