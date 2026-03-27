import SwiftUI

struct LevelDetailView: View {
    let level: Level
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @Environment(SpeechService.self) private var speechService
    @Environment(EngagementService.self) private var engagementService
    @State private var selectedLessonIndex: Int?
    @State private var quizConfig: QuizConfig?
    @State private var selectedGameMode: GameMode = .speedTap
    @State private var useTimer: Bool = false

    private var lessons: [LessonPage] {
        LessonContentService.lessons(for: level, dialect: dialect)
    }

    private var pronouns: [Pronoun] {
        dialect.pronouns.filter { pronoun in
            level.verbs.contains { $0.conjugation(for: pronoun, dialect: dialect) != nil }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                levelHeader
                verbCardsSection
                lessonsSection
                practiceSection
            }
            .padding(.vertical, 20)
        }
        .background(Pico.plaster.ignoresSafeArea())
        .navigationTitle("Level \(level.level)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: Binding(
            get: { selectedLessonIndex.map { LessonSelection(index: $0) } },
            set: { selectedLessonIndex = $0?.index }
        )) { selection in
            LessonPageView(
                lessons: lessons,
                startIndex: selection.index
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(item: $quizConfig) { config in
            NavigationStack {
                QuizView(
                    level: config.level,
                    dialect: dialect,
                    pronouns: config.pronouns,
                    gameMode: config.gameMode,
                    useTimer: config.useTimer
                )
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            quizConfig = nil
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.body.weight(.semibold))
                                Text("Exit")
                            }
                            .foregroundStyle(Pico.deepForestGreen)
                        }
                    }
                }
            }
        }
    }

    private var levelHeader: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Pico.deepForestGreen.opacity(0.08))
                        .frame(width: 48, height: 48)
                    Image(systemName: level.zone.icon)
                        .font(.title3)
                        .foregroundStyle(Pico.deepForestGreen)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(level.tense)
                        .font(.system(.title3, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                    HStack(spacing: 6) {
                        Text(level.zone.rawValue)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                        if level.isSpecial {
                            Text("Special")
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                .foregroundStyle(Pico.terracotta)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Pico.terracotta.opacity(0.1), in: Capsule())
                        }
                    }
                }
                Spacer()
            }

            Text(levelDescription)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)

            let prog = progressService.progress(for: level.level)
            if prog.totalAttempts > 0 {
                HStack(spacing: 10) {
                    miniStat(icon: "checkmark.circle.fill", value: "\(prog.correctAttempts)", label: "Correct", color: Pico.leafGreen)
                    miniStat(icon: "flame.fill", value: "\(prog.bestScore)", label: "Best", color: .orange)
                    miniStat(icon: "target", value: prog.totalAttempts > 0 ? "\(Int(Double(prog.correctAttempts) / Double(prog.totalAttempts) * 100))%" : "—", label: "Accuracy", color: Pico.deepForestGreen)
                }
            }
        }
        .picoCard()
        .padding(.horizontal, 16)
    }

    private var verbCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Verbs in this Level")
                .font(.system(.headline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(level.verbs, id: \.infinitive) { verb in
                        VStack(spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(verb.infinitive)
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundStyle(Pico.deepForestGreen)
                                    Text(verb.translation)
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                                }
                                Spacer()
                                Button {
                                    speechService.speak(verb.infinitive, dialect: dialect)
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.subheadline)
                                        .foregroundStyle(Pico.deepForestGreen)
                                        .frame(width: 36, height: 36)
                                        .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                                }
                            }

                            if verb.irregular {
                                HStack {
                                    Text("Irregular")
                                        .font(.system(.caption2, design: .rounded, weight: .bold))
                                        .foregroundStyle(.orange)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(.orange.opacity(0.1), in: Capsule())
                                    Spacer()
                                }
                            }

                            let conjugations = verb.conjugations.forDialect(dialect)
                            VStack(spacing: 4) {
                                ForEach(Array(conjugations.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                                    HStack(spacing: 8) {
                                        Text(Pronoun(rawValue: key)?.shortName ?? key)
                                            .font(.system(.caption2, design: .rounded, weight: .medium))
                                            .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                                            .frame(width: 50, alignment: .trailing)
                                        Text(value)
                                            .font(.system(.caption, design: .rounded, weight: .semibold))
                                            .foregroundStyle(Pico.deepForestGreen)
                                        Spacer()
                                        Button {
                                            speechService.speak(value, dialect: dialect)
                                        } label: {
                                            Image(systemName: "speaker.wave.1.fill")
                                                .font(.system(size: 10))
                                                .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(14)
                        .frame(width: 220)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Pico.cardSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .contentMargins(.horizontal, 16)
        }
    }

    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Lessons")
                    .font(.system(.title3, design: .serif, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(Pico.deepForestGreen)
                Text("Learn the theory before you practice")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
            }
            .padding(.horizontal, 16)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                    Button {
                        selectedLessonIndex = index
                        HapticService.selection()
                    } label: {
                        lessonCell(lesson: lesson)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func lessonCell(lesson: LessonPage) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Pico.cardSurface)
                    .frame(width: 68, height: 68)
                    .overlay {
                        Circle()
                            .strokeBorder(Pico.deepForestGreen.opacity(0.15), lineWidth: 1.5)
                    }

                Image(systemName: lesson.icon)
                    .font(.title2)
                    .foregroundStyle(Pico.deepForestGreen)
            }

            Text(lesson.title)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.deepForestGreen)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
    }

    private var practiceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Practice")
                    .font(.system(.title3, design: .serif, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(Pico.deepForestGreen)

                let verbNames = level.verbs.prefix(4).map(\.infinitive).joined(separator: ", ")
                Text("Conjugate \(level.verbs.count) verb\(level.verbs.count == 1 ? "" : "s") in the \(level.tense): \(verbNames)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
            }
            .padding(.horizontal, 16)

            gameModeSelector
                .padding(.horizontal, 16)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(pronouns) { pronoun in
                    Button {
                        startPractice(pronoun: pronoun)
                    } label: {
                        pronounCell(pronoun: pronoun)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    startPractice(pronoun: nil)
                } label: {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Pico.cardSurface)
                                .frame(width: 68, height: 68)
                                .overlay {
                                    Circle()
                                        .strokeBorder(Pico.leafGreen.opacity(0.2), lineWidth: 1.5)
                                }
                            Image(systemName: "pencil.line")
                                .font(.title2)
                                .foregroundStyle(Pico.leafGreen)
                        }
                        Text("All Pronouns")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(Pico.deepForestGreen)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)

            startAllButton
                .padding(.horizontal, 16)
                .padding(.top, 4)
        }
    }

    private func pronounCell(pronoun: Pronoun) -> some View {
        let hasProgress = progressService.progress(for: level.level).completedVerbs.count > 0

        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Pico.cardSurface)
                    .frame(width: 68, height: 68)
                    .overlay {
                        Circle()
                            .strokeBorder(
                                hasProgress ? Pico.deepForestGreen.opacity(0.3) : Pico.deepForestGreen.opacity(0.15),
                                lineWidth: 1.5
                            )
                    }
                Text(pronoun.shortName.prefix(2))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Pico.deepForestGreen)
            }
            Text(pronoun.displayName)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.deepForestGreen)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
        }
    }

    private var gameModeSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mode")
                .font(.system(.subheadline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen.opacity(0.6))

            HStack(spacing: 10) {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    Button {
                        selectedGameMode = mode
                        HapticService.selection()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: mode.icon)
                                .font(.subheadline)
                            Text(mode.rawValue)
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                        }
                        .foregroundStyle(selectedGameMode == mode ? Pico.deepForestGreen : Pico.deepForestGreen.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(selectedGameMode == mode ? Pico.deepForestGreen.opacity(0.1) : Pico.cardSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(
                                            selectedGameMode == mode ? AnyShapeStyle(Pico.deepForestGreen.opacity(0.3)) : AnyShapeStyle(Pico.cardLightStroke),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Button {
                useTimer.toggle()
                HapticService.selection()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: useTimer ? "checkmark.square.fill" : "square")
                        .font(.body)
                        .foregroundStyle(useTimer ? Pico.leafGreen : Pico.deepForestGreen.opacity(0.3))
                    Text("Timed mode (30s per question)")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                    Spacer()
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var startAllButton: some View {
        Button {
            HapticService.heavyTap()
            let config = QuizConfig(
                level: level,
                pronouns: Set(pronouns),
                gameMode: selectedGameMode,
                useTimer: useTimer
            )
            quizConfig = config
        } label: {
            HStack(spacing: 8) {
                Image(systemName: progressService.isLevelCracked(level.level) ? "wrench.and.screwdriver" : "play.fill")
                Text(progressService.isLevelCracked(level.level) ? "Repair Session" : "Start Full Practice")
                    .font(.system(.headline, design: .rounded))
            }
            .foregroundStyle(Pico.plaster)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Pico.primaryGradient, in: .rect(cornerRadius: 14))
            .shadow(color: Pico.deepForestGreen.opacity(0.2), radius: 8, y: 4)
        }
    }

    private func miniStat(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                Text(value)
                    .font(.system(.subheadline, design: .rounded, weight: .bold).monospacedDigit())
                    .foregroundStyle(Pico.deepForestGreen)
            }
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Pico.cardSurface, in: .rect(cornerRadius: 10))
    }

    private func startPractice(pronoun: Pronoun?) {
        HapticService.heavyTap()
        let selectedPronouns: Set<Pronoun>
        if let pronoun {
            selectedPronouns = [pronoun]
        } else {
            selectedPronouns = Set(pronouns)
        }
        let config = QuizConfig(
            level: level,
            pronouns: selectedPronouns,
            gameMode: selectedGameMode,
            useTimer: useTimer
        )
        quizConfig = config
    }

    private var levelDescription: String {
        switch level.level {
        case 1: return "Master your first regular verbs in the Present Tense. Learn -AR and -ER verb conjugation patterns."
        case 2: return "Tackle the four most important irregular verbs: Ser, Estar, Ter, and Ir."
        case 3: return "Learn essential power verbs: Fazer, Poder, Querer, and Saber."
        case 4: return "Master verbs of communication and movement: Dizer, Ver, Dar, and Vir."
        case 5: return "Practice common everyday regular verbs in the Present Tense."
        case 6: return "Explore -ER and -IR regular verb patterns in the Present Tense."
        default:
            let tense = level.tense
            let verbCount = level.verbs.count
            return "Practice \(verbCount) verb\(verbCount == 1 ? "" : "s") in the \(tense)."
        }
    }
}

struct LessonSelection: Identifiable {
    let index: Int
    var id: Int { index }
}
