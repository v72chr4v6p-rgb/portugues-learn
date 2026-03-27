import SwiftUI

struct StatsView: View {
    @Environment(ProgressService.self) private var progressService
    @Environment(EngagementService.self) private var engagementService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Pico.spacingL) {
                    overviewCards
                    streakSection
                    levelProgressSection
                }
                .padding(.horizontal, Pico.spacingXL)
                .padding(.vertical, Pico.spacingL)
            }
            .background(Pico.plaster.ignoresSafeArea())
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Statistics")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
        }
    }

    private var overviewCards: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            picoStatCard(icon: "checkmark.circle.fill", iconColor: Pico.leafGreen, value: "\(progressService.completedLevelCount)", label: "Levels Done", total: "/ 43")
            picoStatCard(icon: "percent", iconColor: Pico.terracotta, value: progressService.totalAttempts > 0 ? "\(Int(progressService.accuracy * 100))%" : "—", label: "Accuracy", total: nil)
            picoStatCard(icon: "flame.fill", iconColor: .orange, value: "\(engagementService.dayStreak)", label: "Day Streak", total: nil)
            picoStatCard(icon: "star.fill", iconColor: Pico.gold, value: "\(engagementService.xp)", label: "Total XP", total: nil)
        }
    }

    private func picoStatCard(icon: String, iconColor: Color, value: String, label: String, total: String?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Pico.darkText)
                if let total {
                    Text(total)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
                }
            }

            Text(label)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.darkTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .picoCard()
    }

    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Streak Record")
                .font(.system(.headline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.darkText)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Best Streak")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.darkTextSecondary)
                    Text("\(engagementService.bestDayStreak) days in a row")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.darkText)
                }

                Spacer()

                Image(systemName: "flame.fill")
                    .font(.largeTitle)
                    .foregroundStyle(
                        LinearGradient(colors: [.orange, .red], startPoint: .bottom, endPoint: .top)
                    )
            }
            .picoCard()
        }
    }

    private var levelProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Level Progress")
                .font(.system(.headline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.darkText)

            ForEach(ForestZone.allCases, id: \.self) { zone in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: zone.icon)
                            .font(.caption)
                            .foregroundStyle(Pico.leafGreen)
                        Text(zone.rawValue)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.darkText)
                    }

                    let range = zone.levelRange
                    let completed = range.filter { progressService.isLevelCompleted($0) }.count
                    let total = range.count

                    HStack(spacing: 8) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Pico.earthBrown.opacity(0.08))
                                Capsule().fill(Pico.primaryGradient)
                                    .frame(width: total > 0 ? geo.size.width * CGFloat(completed) / CGFloat(total) : 0)
                            }
                        }
                        .frame(height: 8)

                        Text("\(completed)/\(total)")
                            .font(.system(.caption, design: .rounded, weight: .semibold).monospacedDigit())
                            .foregroundStyle(Pico.darkTextSecondary)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
                .picoCard()
            }
        }
    }
}
