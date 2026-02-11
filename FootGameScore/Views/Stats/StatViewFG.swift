import SwiftUI
import Charts

struct StatViewFG: View {
    @EnvironmentObject var viewModel: ViewModelFG
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        ZStack {
            Color.fgBackground.ignoresSafeArea()
            VStack {
                HeaderFG(title: "Statistics")
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Main Stats Cards
                        HStack(spacing: 15) {
                            StatCardFG(title: "Drills", value: "\(viewModel.userStats.completedDrills)", icon: "figure.soccer")
                            StatCardFG(title: "Articles", value: "\(viewModel.userStats.readArticles)", icon: "book.fill")
                            StatCardFG(title: "Streak", value: "\(viewModel.userStats.currentStreak)", icon: "flame.fill")
                        }
                        .padding(.horizontal)
                        
                        // Activity Chart
                        GlassCardFG {
                            VStack(alignment: .leading) {
                                Text("Activity")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)
                                
                                Chart {
                                    ForEach(viewModel.userStats.recentActivity, id: \.self) { date in
                                        LineMark(
                                            x: .value("Day", date, unit: .day),
                                            y: .value("Activity", 1)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .foregroundStyle(Color.fgNeon)
                                        .lineStyle(StrokeStyle(lineWidth: 3))
                                        .shadow(color: .fgNeon.opacity(0.8), radius: 8)
                                        
                                        AreaMark(
                                            x: .value("Day", date, unit: .day),
                                            y: .value("Activity", 1)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [Color.fgNeon.opacity(0.4), Color.fgNeon.opacity(0.0)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                    }
                                }
                                .frame(height: 200)
                                .chartYAxis(.hidden)
                                .chartXAxis {
                                    AxisMarks(values: .stride(by: .day)) { value in
                                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                                            .foregroundStyle(Color.white.opacity(0.1))
                                        AxisValueLabel(format: .dateTime.weekday())
                                            .foregroundStyle(Color.gray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Skill Breakdown
                        SectionHeaderFG(title: "Skill Breakdown")
                            .padding(.horizontal)
                        
                        GlassCardFG {
                            VStack(spacing: 20) {
                                SkillBarFG(skill: "Finishing", value: 0.8)
                                SkillBarFG(skill: "Dribbling", value: 0.65)
                                SkillBarFG(skill: "Pace", value: 0.9)
                                SkillBarFG(skill: "Passing", value: 0.7)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 80)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct StatCardFG: View {
    let title: String
    let value: String
    let icon: String
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        GlassCardFG {
            VStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.fgNeon)
                    .padding(.bottom, 5)
                
                Text(value)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct SkillBarFG: View {
    let skill: String
    let value: Double // 0.0 to 1.0
    @ObservedObject private var themeManager = ThemeManagerFG.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(skill)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.caption)
                    .foregroundColor(.fgNeon)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                colors: [.fgNeon, .fgGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * value, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
