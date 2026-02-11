import SwiftUI
import StoreKit

struct PaywallViewFG: View {
    let theme: ThemeModelFG
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var store = StoreManagerFG.shared
    
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    @State private var resultTitle = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            Color.fgBlack.ignoresSafeArea()
            
            // Visual Accents
            let themeColor = Color(hex: theme.accentColorHex)
            Circle()
                .fill(themeColor.opacity(0.1))
                .blur(radius: 100)
                .offset(y: -200)
            
            VStack(spacing: 0) {
                // Drag handle for sheet
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Theme Preview
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [themeColor, themeColor.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 140, height: 140)
                                    .shadow(color: themeColor.opacity(0.5), radius: 30)
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .shadow(radius: 10)
                            }
                            .padding(.top, 40)
                            
                            Text(theme.name)
                                .font(.system(size: 36, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Experience the ultimate tactical look.")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        // Feature List
                        VStack(alignment: .leading, spacing: 20) {
                            FeatureRowFG(icon: "paintpalette.fill", title: "Premium Theme", desc: "Unlock the \(theme.name) colors across the entire app.")
                            FeatureRowFG(icon: "star.fill", title: "Pro Badge", desc: "Get an exclusive player status badge.")
                            FeatureRowFG(icon: "bolt.fill", title: "Advanced Analytics", desc: "Unlock deeper insights into your training.")
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                        
                        // Purchase Section
                        if let product = store.products.first(where: { $0.id == theme.productID }) {
                            VStack(spacing: 16) {
                                Button(action: {
                                    selectedProduct = product
                                    showConfirmAlert = true
                                }) {
                                    HStack {
                                        Text("GET ACCESS FOR \(product.displayPrice)")
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.fgNeon)
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                                    .shadow(color: .fgNeon.opacity(0.4), radius: 10)
                                }
                                
                                Button(action: {
                                    Task {
                                        await store.restorePurchases()
                                        if store.hasAccess(to: theme) {
                                            resultTitle = "Success"
                                            resultMessage = "Your purchases have been restored!"
                                            isSuccess = true
                                            showResultAlert = true
                                        } else {
                                            resultTitle = "No Purchases Found"
                                            resultMessage = "We couldn't find any previous purchases."
                                            isSuccess = false
                                            showResultAlert = true
                                        }
                                    }
                                }) {
                                    Text("Restore Purchases")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            if store.isLoading {
                                ProgressView().tint(.fgNeon)
                            } else {
                                Text("Product unavailable at the moment")
                                    .foregroundColor(.gray)
                                Button("Retry") {
                                    Task { await store.fetchProducts() }
                                }
                                .foregroundColor(.fgNeon)
                            }
                        }
                        
                        Button { dismiss() } label: {
                            Text("Maybe Later")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .customAlert(isPresented: $showConfirmAlert, alert: confirmAlert)
        .customAlert(isPresented: $showResultAlert, alert: resultAlert)
        .task {
            if store.products.isEmpty {
                await store.fetchProducts()
            }
        }
    }
    
    var confirmAlert: CustomAlertFG {
        CustomAlertFG(
            title: "Confirm Purchase",
            message: "Unlock \(theme.name) for \(selectedProduct?.displayPrice ?? "...")?\n\none-time purchase.",
            primaryButton: .init(title: "Purchase", isPrimary: true) {
                showConfirmAlert = false
                Task { await performPurchase() }
            },
            secondaryButton: .init(title: "Cancel") {
                showConfirmAlert = false
            }
        )
    }
    
    var resultAlert: CustomAlertFG {
        CustomAlertFG(
            title: resultTitle,
            message: resultMessage,
            primaryButton: .init(title: "OK", isPrimary: true) {
                showResultAlert = false
                if isSuccess { dismiss() }
            },
            secondaryButton: nil
        )
    }
    
    func performPurchase() async {
        guard let product = selectedProduct else { return }
        let status = await store.purchase(product)
        
        switch status {
        case .success:
            resultTitle = "Success!"
            resultMessage = "\(theme.name) is now yours!"
            isSuccess = true
            showResultAlert = true
        case .cancelled:
            break
        case .pending:
            resultTitle = "Pending"
            resultMessage = "Purchase is pending approval."
            isSuccess = false
            showResultAlert = true
        case .failed:
            resultTitle = "Error"
            resultMessage = "Purchase failed. Please try again."
            isSuccess = false
            showResultAlert = true
        }
    }
}

struct FeatureRowFG: View {
    let icon: String
    let title: String
    let desc: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.fgNeon)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
