import SwiftUI

struct NutritionViewFG: View {
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    Text("NUTRITION GUIDE")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.fgNeon)
                    
                    Spacer()
                    
                    Circle().fill(Color.clear).frame(width: 44, height: 44).padding()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        // Hero Card
                        GlassCardFG {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Fuel Your Performance")
                                        .font(.title2)
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                    Text("Eat like a pro, play like a pro.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.fgNeon)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sections
                        NutritionSectionFG(title: "PRE-MATCH (3-4 HOURS)", icon: "timer") {
                            NutritionItemFG(title: "Complex Carbs", desc: "Brown rice, whole wheat pasta, or sweet potatoes for sustained energy.")
                            NutritionItemFG(title: "Lean Protein", desc: "Chicken breast or white fish. Avoid heavy red meats before game.")
                        }
                        
                        NutritionSectionFG(title: "HYDRATION STRATEGY", icon: "drop.fill") {
                            NutritionItemFG(title: "The 2% Rule", desc: "Losing 2% body weight in sweat significantly drops performance. Drink 500ml 2h before.")
                            NutritionItemFG(title: "Electrolytes", desc: "Add a pinch of salt or electrolyte tablets to water for better absorption.")
                        }
                        
                        NutritionSectionFG(title: "RECOVERY (POST-SESSION)", icon: "clock.arrow.2.circlepath") {
                            NutritionItemFG(title: "Whey Protein", desc: "20-30g of fast-acting protein within 30 minutes of training.")
                            NutritionItemFG(title: "Antioxidants", desc: "Blueberries or tart cherry juice to reduce muscle inflammation.")
                        }
                        
                        // Sample Meal Plan
                        VStack(alignment: .leading, spacing: 15) {
                            Text("SAMPLE DAILY PLAN")
                                .font(.headline)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            GlassCardFG {
                                VStack(spacing: 15) {
                                    MealRowFG(time: "08:00", meal: "Oatmeal with berries and nuts")
                                    MealRowFG(time: "12:30", meal: "Grilled chicken, quinoa & avocado")
                                    MealRowFG(time: "16:00", meal: "Greek yogurt & banana")
                                    MealRowFG(time: "20:00", meal: "Baked salmon with asparagus")
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

struct NutritionSectionFG<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.fgNeon)
                Text(title)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(.fgNeon)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                content
            }
        }
    }
}

struct NutritionItemFG: View {
    let title: String
    let desc: String
    
    var body: some View {
        GlassCardFG {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

struct MealRowFG: View {
    let time: String
    let meal: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text(time)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.fgNeon)
            Text(meal)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct NutritionViewFG_Previews: PreviewProvider {
    static var previews: some View {
        NutritionViewFG()
    }
}
