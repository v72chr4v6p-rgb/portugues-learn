import SwiftUI

struct HomeView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @Environment(EngagementService.self) private var engagementService
    @Environment(SpeechService.self) private var speechService
    @State private var navigateToLevel: Level?
    @State private var showQuickReview: Bool = false
    @State private var animateStreak: Bool = false

    private var currentLevel: Level? {
        verbDataService.allSortedLevels().first { !progressService.isLevelCompleted($0.level) }
    }

    private var recentlyPracticed: [Level] {
        let sorted = verbDataService.allSortedLevels()
        return sorted.filter {
            progressService.isLevelCompleted($0.level) &&
            progressService.progress(for: $0.level).lastAttemptDate != nil
        }
        .sorted { a, b in
            let aDate = progressService.progress(for: a.level).lastAttemptDate ?? .distantPast
            let bDate = progressService.progress(for: b.level).lastAttemptDate ?? .distantPast
            return aDate > bDate
        }
        .prefix(5)
        .map { $0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    greetingHeader
                    dailyProgressCard
                    streakAndXPRow
                    if let level = currentLevel {
                        continueCard(level: level)
                    }
                    quickActionsRow
                    if !recentlyPracticed.isEmpty {
                        reviewSection
                    }
                    todaysTip
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Bico")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $navigateToLevel) { level in
                LevelDetailView(level: level, dialect: dialect)
            }
            .fullScreenCover(isPresented: $showQuickReview) {
                NavigationStack {
                    QuickReviewView(dialect: dialect)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Done") { showQuickReview = false }
                                    .foregroundStyle(Theme.tangerine)
                            }
                        }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6).delay(0.3)) {
                    animateStreak = true
                }
            }
        }
    }

    private var greetingHeader: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: Theme.bicoMascotURL)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.title)
                        .foregroundStyle(Theme.tangerine)
                }
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(.title2.weight(.bold))
                Text(motivationalText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            levelBadge
        }
        .padding(.top, 8)
    }

    private var levelBadge: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .stroke(Theme.tangerine.opacity(0.2), lineWidth: 3)
                    .frame(width: 44, height: 44)
                Circle()
                    .trim(from: 0, to: engagementService.levelProgress)
                    .stroke(Theme.tangerine, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                Text("\(engagementService.userLevel)")
                    .font(.system(.body, design: .rounded, weight: .heavy))
                    .foregroundStyle(Theme.tangerine)
            }
            Text("Level")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }

    private var dailyProgressCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Goal")
                        .font(.headline)
                    Text("\(engagementService.todayXP) / \(engagementService.dailyXPGoal) XP")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if engagementService.dailyGoalMet {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                        .symbolEffect(.bounce, value: animateStreak)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                    Capsule()
                        .fill(
                            engagementService.dailyGoalMet
                            ? AnyShapeStyle(Theme.successGradient)
                            : AnyShapeStyle(Theme.tangerineGradient)
                        )
                        .frame(width: max(8, geo.size.width * engagementService.dailyProgress))
                        .animation(.spring(response: 0.6), value: engagementService.dailyProgress)
                }
            }
            .frame(height: 10)
            .clipShape(Capsule())
        }
        .premiumCard()
    }

    private var streakAndXPRow: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .symbolEffect(.bounce, value: animateStreak)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(engagementService.dayStreak)")
                        .font(.title3.weight(.bold).monospacedDigit())
                    Text("Day Streak")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .premiumCard()

            HStack(spacing: 10) {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.gold)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(engagementService.xp)")
                        .font(.title3.weight(.bold).monospacedDigit())
                    Text("Total XP")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .premiumCard()
        }
    }

    private func continueCard(level: Level) -> some View {
        Button {
            navigateToLevel = level
            HapticService.lightTap()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.tangerine.opacity(0.15))
                        .frame(width: 56, height: 56)
                    Text("\(level.level)")
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .foregroundStyle(Theme.tangerine)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Continue Learning")
                        .font(.headline)
                    Text("Level \(level.level) — \(level.tense)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(level.verbs.count) verbs to master")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Theme.tangerine)
            }
            .premiumCard()
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: navigateToLevel)
    }

    private var quickActionsRow: some View {
        HStack(spacing: 12) {
            quickActionButton(
                icon: "bolt.fill",
                title: "3-min Review",
                color: Theme.amber
            ) {
                showQuickReview = true
                HapticService.lightTap()
            }

            quickActionButton(
                icon: "rectangle.stack.fill",
                title: "Flashcards",
                color: Theme.softTeal
            ) {
                HapticService.lightTap()
            }
        }
    }

    private func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Practiced")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(recentlyPracticed) { level in
                        Button {
                            navigateToLevel = level
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: level.zone.icon)
                                        .font(.caption)
                                        .foregroundStyle(Theme.leafGreen)
                                    Text("Lvl \(level.level)")
                                        .font(.caption.weight(.bold).monospacedDigit())
                                }
                                Text(level.tense)
                                    .font(.subheadline.weight(.semibold))
                                    .lineLimit(1)

                                let prog = progressService.progress(for: level.level)
                                let acc = prog.totalAttempts > 0 ? Int(Double(prog.correctAttempts) / Double(prog.totalAttempts) * 100) : 0
                                Text("\(acc)% accuracy")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .frame(width: 140)
                            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    private var todaysTip: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .foregroundStyle(Theme.amber)

            VStack(alignment: .leading, spacing: 4) {
                Text("Tip of the Day")
                    .font(.subheadline.weight(.semibold))
                Text(dailyTip)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
        }
        .premiumCard()
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Bom dia!" }
        if hour < 18 { return "Boa tarde!" }
        return "Boa noite!"
    }

    private var motivationalText: String {
        if engagementService.dayStreak >= 7 { return "Amazing \(engagementService.dayStreak)-day streak!" }
        if engagementService.dayStreak >= 3 { return "Keep the streak going!" }
        if engagementService.todayXP > 0 { return "Great progress today." }
        return "Ready to learn?"
    }

    private var dailyTip: String {
        let tips = [
            "In Brazilian Portuguese, 'você' is standard. In European Portuguese, 'tu' is more common for informal situations.",
            "Regular -AR verbs are the most common group. Master their pattern and you can conjugate hundreds of verbs!",
            "SER vs ESTAR is one of the trickiest distinctions. SER = permanent (identity), ESTAR = temporary (state).",
            "Portuguese has nasal vowels (ã, õ) that don't exist in English. Practice makes them natural!",
            "The personal infinitive is unique to Portuguese — no other Romance language has it!",
            "Try saying conjugations out loud. Muscle memory helps you recall forms faster.",
            "Don't try to memorize everything at once. Spaced repetition (flashcards) is scientifically proven to work."
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return tips[dayOfYear % tips.count]
    }
}
