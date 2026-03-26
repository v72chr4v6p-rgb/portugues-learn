import SwiftUI

struct StatsView: View {
    @Environment(ProgressService.self) private var progressService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    overviewCards
                    streakSection
                    levelProgressSection
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Statistics")
        }
    }

    private var overviewCards: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            StatCard(icon: "checkmark.circle.fill", iconColor: .green, value: "\(progressService.completedLevelCount)", label: "Levels Done", total: "/ 43")
            StatCard(icon: "percent", iconColor: Theme.tangerine, value: progressService.totalAttempts > 0 ? "\(Int(progressService.accuracy * 100))%" : "—", label: "Accuracy", total: nil)
            StatCard(icon: "flame.fill", iconColor: .orange, value: "\(progressService.currentStreak)", label: "Current Streak", total: nil)
            StatCard(icon: "star.fill", iconColor: Theme.gold, value: "\(progressService.totalCorrect)", label: "Total Correct", total: nil)
        }
    }

    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Streak Record")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Best Streak")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(progressService.bestStreak) correct in a row")
                        .font(.title3.weight(.bold))
                }

                Spacer()

                Image(systemName: "flame.fill")
                    .font(.largeTitle)
                    .foregroundStyle(
                        LinearGradient(colors: [.orange, .red], startPoint: .bottom, endPoint: .top)
                    )
            }
            .padding(16)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
        }
    }

    private var levelProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Level Progress")
                .font(.headline)

            ForEach(ForestZone.allCases, id: \.self) { zone in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: zone.icon)
                            .font(.caption)
                            .foregroundStyle(Theme.sage)
                        Text(zone.rawValue)
                            .font(.subheadline.weight(.semibold))
                    }

                    let range = zone.levelRange
                    let completed = range.filter { progressService.isLevelCompleted($0) }.count
                    let total = range.count

                    HStack(spacing: 8) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color(.systemGray5))
                                Capsule().fill(Theme.tangerineGradient)
                                    .frame(width: total > 0 ? geo.size.width * CGFloat(completed) / CGFloat(total) : 0)
                            }
                        }
                        .frame(height: 8)

                        Text("\(completed)/\(total)")
                            .font(.caption.weight(.semibold).monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 12))
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String
    let total: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2.weight(.bold))
                if let total {
                    Text(total)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
    }
}
