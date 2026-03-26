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
    @State private var growthRingAppeared: Bool = false

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
                VStack(spacing: 0) {
                    botanicalHeader
                    
                    VStack(spacing: Pico.spacingL) {
                        growthRingWidget
                        streakAndXPRow

                        if let level = currentLevel {
                            continueCard(level: level)
                        }

                        learningPathCards
                        quickActionsRow

                        if !recentlyPracticed.isEmpty {
                            reviewSection
                        }

                        todaysTip
                    }
                    .padding(.horizontal, Pico.spacingXL)
                    .padding(.top, Pico.spacingL)
                    .padding(.bottom, 120)
                }
            }
            .background(Pico.plaster.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pico")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.5)
                        .foregroundStyle(Pico.deepForestGreen)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    levelBadge
                }
            }
            .navigationDestination(item: $navigateToLevel) { level in
                LevelDetailView(level: level, dialect: dialect)
            }
            .fullScreenCover(isPresented: $showQuickReview) {
                NavigationStack {
                    QuickReviewView(dialect: dialect)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Done") { showQuickReview = false }
                                    .foregroundStyle(Pico.deepForestGreen)
                            }
                        }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
                    animateStreak = true
                    growthRingAppeared = true
                }
            }
        }
    }

    // MARK: - Botanical Header

    private var botanicalHeader: some View {
        ZStack(alignment: .bottomLeading) {
            Color(red: 0.92, green: 0.91, blue: 0.88)
                .frame(height: 220)
                .overlay {
                    AsyncImage(url: URL(string: Pico.monsteraHeaderURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .allowsHitTesting(false)
                }
                .clipped()

            LinearGradient(
                stops: [
                    .init(color: Color.clear, location: 0.3),
                    .init(color: Pico.plaster.opacity(0.6), location: 0.7),
                    .init(color: Pico.plaster, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 220)
            .allowsHitTesting(false)

            HStack(alignment: .bottom, spacing: 14) {
                AsyncImage(url: URL(string: Pico.bicoMascotURL)) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "bird.fill")
                            .font(.title)
                            .foregroundStyle(Pico.deepForestGreen)
                    }
                }
                .frame(width: 48, height: 48)
                .offset(x: 4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(greetingText)
                        .font(.system(.largeTitle, design: .serif, weight: .bold))
                        .tracking(-0.5)
                        .foregroundStyle(Pico.deepForestGreen)
                    Text(motivationalText)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                }
            }
            .padding(.horizontal, Pico.spacingXL)
            .padding(.bottom, Pico.spacingM)
        }
    }

    // MARK: - Level Badge

    private var levelBadge: some View {
        ZStack {
            Circle()
                .stroke(Pico.leafGreen.opacity(0.2), lineWidth: 3)
                .frame(width: 36, height: 36)
            Circle()
                .trim(from: 0, to: engagementService.levelProgress)
                .stroke(Pico.leafGreen, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 36, height: 36)
                .rotationEffect(.degrees(-90))
            Text("\(engagementService.userLevel)")
                .font(.system(.caption, design: .rounded, weight: .heavy))
                .foregroundStyle(Pico.deepForestGreen)
        }
    }

    // MARK: - Growth Ring Widget

    private var growthRingWidget: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Pico.leafGreen.opacity(0.12), lineWidth: 10)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: growthRingAppeared ? engagementService.dailyProgress : 0)
                    .stroke(
                        Pico.leafGreen,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.7), value: growthRingAppeared)

                VStack(spacing: 0) {
                    if engagementService.dailyGoalMet {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Pico.leafGreen)
                            .symbolEffect(.bounce, value: animateStreak)
                    } else {
                        Text("\(Int(engagementService.dailyProgress * 100))")
                            .font(.system(.title3, design: .rounded, weight: .heavy))
                            .foregroundStyle(Pico.deepForestGreen)
                        Text("%")
                            .font(.system(.caption2, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Goal")
                    .font(.system(.headline, design: .serif, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(Pico.deepForestGreen)

                Text("\(engagementService.todayXP) / \(engagementService.dailyXPGoal) XP")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.6))

                if engagementService.dailyGoalMet {
                    HStack(spacing: 4) {
                        Image(systemName: "leaf.fill")
                            .font(.caption2)
                        Text("Goal reached!")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(Pico.leafGreen)
                }
            }

            Spacer()
        }
        .picoCard()
    }

    // MARK: - Streak & XP

    private var streakAndXPRow: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .symbolEffect(.bounce, value: animateStreak)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(engagementService.dayStreak)")
                        .font(.system(.title3, design: .rounded, weight: .bold).monospacedDigit())
                        .foregroundStyle(Pico.deepForestGreen)
                    Text("Day Streak")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                }
                Spacer()
            }
            .picoCard()

            HStack(spacing: 10) {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundStyle(Pico.gold)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(engagementService.xp)")
                        .font(.system(.title3, design: .rounded, weight: .bold).monospacedDigit())
                        .foregroundStyle(Pico.deepForestGreen)
                    Text("Total XP")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                }
                Spacer()
            }
            .picoCard()
        }
    }

    // MARK: - Continue Card

    private func continueCard(level: Level) -> some View {
        Button {
            navigateToLevel = level
            HapticService.lightTap()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Pico.deepForestGreen.opacity(0.1))
                        .frame(width: 56, height: 56)
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Pico.deepForestGreen)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Continue Learning")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                    Text("Level \(level.level) — \(level.tense)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                    Text("\(level.verbs.count) verbs to master")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
            }
            .picoCard()
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: navigateToLevel)
    }

    // MARK: - Learning Path Cards

    private var learningPathCards: some View {
        VStack(spacing: 14) {
            Text("Explore")
                .font(.system(.title3, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)
                .frame(maxWidth: .infinity, alignment: .leading)

            pathCard(
                title: "O Vocabulário",
                subtitle: "Words & conjugations",
                icon: "textformat.abc",
                textureURL: Pico.leafVeinTextureURL,
                tint: Pico.leafGreen
            )

            pathCard(
                title: "A Conversa",
                subtitle: "Practice & drills",
                icon: "bubble.left.and.bubble.right.fill",
                textureURL: Pico.stoneArchTextureURL,
                tint: Pico.deepForestGreen
            )

            culturalCard
        }
    }

    private func pathCard(title: String, subtitle: String, icon: String, textureURL: String, tint: Color) -> some View {
        Button {
            HapticService.lightTap()
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(tint)
                    Spacer()
                    Text(title)
                        .font(.system(.title3, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                }
                .padding(20)

                Spacer()

                Color.clear
                    .frame(width: 100)
                    .overlay {
                        AsyncImage(url: URL(string: textureURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .opacity(0.3)
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .clipped()
            }
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(Pico.cardSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                    )
            )
            .clipShape(.rect(cornerRadius: Pico.cardRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var culturalCard: some View {
        Button {
            HapticService.lightTap()
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: "globe.americas.fill")
                        .font(.title2)
                        .foregroundStyle(Pico.terracotta)
                    Spacer()
                    Text("Cultura")
                        .font(.system(.title3, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                    Text("Brazilian culture & tips")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                }
                .padding(20)

                Spacer()

                ZStack {
                    Circle()
                        .fill(Pico.terracotta.opacity(0.08))
                        .frame(width: 80, height: 80)
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Pico.terracotta.opacity(0.25))
                }
                .padding(.trailing, 20)
            }
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(Pico.cardSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                    )
            )
            .clipShape(.rect(cornerRadius: Pico.cardRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Quick Actions

    private var quickActionsRow: some View {
        HStack(spacing: 12) {
            quickActionButton(
                icon: "bolt.fill",
                title: "3-min Review",
                color: Pico.amber
            ) {
                showQuickReview = true
                HapticService.lightTap()
            }

            quickActionButton(
                icon: "rectangle.stack.fill",
                title: "Flashcards",
                color: Pico.softTeal
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
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(Pico.deepForestGreen)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(Pico.cardSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Review Section

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Practiced")
                .font(.system(.headline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)

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
                                        .foregroundStyle(Pico.leafGreen)
                                    Text("Lvl \(level.level)")
                                        .font(.system(.caption, design: .rounded, weight: .bold).monospacedDigit())
                                        .foregroundStyle(Pico.deepForestGreen)
                                }
                                Text(level.tense)
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Pico.deepForestGreen)
                                    .lineLimit(1)

                                let prog = progressService.progress(for: level.level)
                                let acc = prog.totalAttempts > 0 ? Int(Double(prog.correctAttempts) / Double(prog.totalAttempts) * 100) : 0
                                Text("\(acc)% accuracy")
                                    .font(.system(.caption2, design: .rounded))
                                    .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                            }
                            .padding(14)
                            .frame(width: 140)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Pico.cardSurface)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .contentMargins(.horizontal, 0)
        }
    }

    // MARK: - Tip

    private var todaysTip: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.title3)
                .foregroundStyle(Pico.amber)

            VStack(alignment: .leading, spacing: 4) {
                Text("Tip of the Day")
                    .font(.system(.subheadline, design: .serif, weight: .semibold))
                    .foregroundStyle(Pico.deepForestGreen)
                Text(dailyTip)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                    .lineSpacing(2)
            }
        }
        .picoCard()
    }

    // MARK: - Helpers

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Bom dia" }
        if hour < 18 { return "Boa tarde" }
        return "Boa noite"
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
