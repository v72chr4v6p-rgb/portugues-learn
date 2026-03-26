import SwiftUI

struct LevelDashboardSheet: View {
    let level: Level
    let dialect: Dialect
    let onStart: (QuizConfig) -> Void

    @Environment(ProgressService.self) private var progressService
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPronouns: Set<Pronoun>
    @State private var gameMode: GameMode = .zenTyping
    @State private var useTimer: Bool = false
    @State private var animateIn: Bool = false

    init(level: Level, dialect: Dialect, onStart: @escaping (QuizConfig) -> Void) {
        self.level = level
        self.dialect = dialect
        self.onStart = onStart
        _selectedPronouns = State(initialValue: Set(dialect.pronouns))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    levelHeader
                    verbPreview
                    pronounFilters
                    gameModeSection
                    timerSection
                    startButton
                }
                .padding(20)
            }
            .navigationTitle("Level \(level.level)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    animateIn = true
                }
            }
        }
    }

    private var levelHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Theme.tangerine.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: level.zone.icon)
                        .font(.title3)
                        .foregroundStyle(Theme.tangerine)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(level.tense)
                        .font(.title3.weight(.bold))
                    HStack(spacing: 6) {
                        Text(level.zone.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        if level.isSpecial {
                            Text("Special")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(Theme.tangerine)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Theme.tangerine.opacity(0.12), in: Capsule())
                        }
                    }
                }
                Spacer()
            }

            let prog = progressService.progress(for: level.level)
            if prog.totalAttempts > 0 {
                HStack(spacing: 10) {
                    statPill(icon: "checkmark.circle.fill", value: "\(prog.correctAttempts)", label: "Correct", color: .green)
                    statPill(icon: "flame.fill", value: "\(prog.bestScore)", label: "Best", color: .orange)
                    if prog.isCracked {
                        statPill(icon: "wrench.fill", value: "\(prog.failedVerbs.count)", label: "Repair", color: .red)
                    } else {
                        let pct = prog.totalAttempts > 0 ? "\(Int(Double(prog.correctAttempts) / Double(prog.totalAttempts) * 100))%" : "—"
                        statPill(icon: "target", value: pct, label: "Accuracy", color: Theme.tangerine)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
    }

    private func statPill(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                Text(value)
                    .font(.subheadline.weight(.bold).monospacedDigit())
            }
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.tertiarySystemBackground), in: .rect(cornerRadius: 10))
    }

    private var verbPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(level.verbs, id: \.infinitive) { verb in
                    VStack(spacing: 3) {
                        Text(verb.infinitive)
                            .font(.subheadline.weight(.semibold))
                        Text(verb.translation)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        if verb.irregular {
                            Text("Irregular")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 1)
                                .background(.orange.opacity(0.1), in: Capsule())
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.tertiarySystemBackground), in: .rect(cornerRadius: 10))
                }
            }
        }
        .contentMargins(.horizontal, 0)
    }

    private var pronounFilters: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Pronouns")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                ForEach(dialect.pronouns) { pronoun in
                    Button {
                        if selectedPronouns.contains(pronoun) {
                            if selectedPronouns.count > 1 {
                                selectedPronouns.remove(pronoun)
                            }
                        } else {
                            selectedPronouns.insert(pronoun)
                        }
                        HapticService.selection()
                    } label: {
                        Text(pronoun.shortName)
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedPronouns.contains(pronoun)
                                    ? Theme.tangerine.opacity(0.15)
                                    : Color(.tertiarySystemBackground),
                                in: .rect(cornerRadius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        selectedPronouns.contains(pronoun) ? Theme.tangerine : .clear,
                                        lineWidth: 1.5
                                    )
                            )
                            .foregroundStyle(selectedPronouns.contains(pronoun) ? Theme.tangerine : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var gameModeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Game Mode")
                .font(.headline)

            HStack(spacing: 10) {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    Button {
                        gameMode = mode
                        HapticService.selection()
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: mode.icon)
                                .font(.title3)
                            Text(mode.rawValue)
                                .font(.caption.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            gameMode == mode
                                ? Theme.tangerine.opacity(0.15)
                                : Color(.tertiarySystemBackground),
                            in: .rect(cornerRadius: 12)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(gameMode == mode ? Theme.tangerine : .clear, lineWidth: 1.5)
                        )
                        .foregroundStyle(gameMode == mode ? Theme.tangerine : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var timerSection: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "timer")
                    .foregroundStyle(Theme.tangerine)
                Text("Bico's Timer")
                    .font(.subheadline.weight(.medium))
            }
            Spacer()
            Toggle("", isOn: $useTimer)
                .tint(Theme.tangerine)
                .labelsHidden()
        }
        .padding(14)
        .background(Color(.tertiarySystemBackground), in: .rect(cornerRadius: 12))
    }

    private var startButton: some View {
        Button {
            HapticService.heavyTap()
            let config = QuizConfig(
                level: level,
                pronouns: selectedPronouns,
                gameMode: gameMode,
                useTimer: useTimer
            )
            onStart(config)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: progressService.isLevelCracked(level.level) ? "wrench.and.screwdriver" : "play.fill")
                Text(progressService.isLevelCracked(level.level) ? "Repair Session" : "Start")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.tangerineGradient, in: .rect(cornerRadius: 16))
            .shadow(color: Theme.tangerine.opacity(0.3), radius: 8, y: 4)
        }
    }
}
