import SwiftUI

struct ConversationPracticeView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(SpeechService.self) private var speechService
    @Environment(EngagementService.self) private var engagementService
    @State private var currentScenario: Int = 0
    @State private var userAnswer: String = ""
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool = false
    @State private var score: Int = 0
    @State private var isComplete: Bool = false
    @State private var selectedDifficulty: Difficulty = .beginner
    @Environment(\.dismiss) private var dismiss

    private var scenarios: [ConversationScenario] {
        let all = ConversationDataService.scenarios(for: dialect)
        return Array(all.filter { $0.difficulty == selectedDifficulty }.shuffled().prefix(10))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Pico.plaster.ignoresSafeArea()

                if isComplete {
                    completionView
                } else if scenarios.isEmpty {
                    setupView
                } else if !showResult && currentScenario == 0 && userAnswer.isEmpty {
                    setupView
                } else {
                    scenarioView
                }
            }
            .navigationTitle("A Conversa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("A Conversa")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
        }
    }

    private var setupView: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Pico.deepForestGreen.opacity(0.08))
                            .frame(width: 90, height: 90)
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Pico.deepForestGreen)
                    }

                    Text("Conversation Practice")
                        .font(.system(.title2, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.darkText)

                    Text(dialect == .brazilian
                         ? "Practice real-world Brazilian Portuguese conversations"
                         : "Practice real-world European Portuguese conversations")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.darkTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Difficulty")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.darkText)

                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        Button {
                            selectedDifficulty = diff
                            HapticService.selection()
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: diff.icon)
                                    .font(.title3)
                                    .foregroundStyle(diff.color)
                                    .frame(width: 36)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(diff.title)
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundStyle(Pico.darkText)
                                    Text(diff.subtitle)
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Pico.darkTextSecondary)
                                }

                                Spacer()

                                if selectedDifficulty == diff {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(Pico.leafGreen)
                                }
                            }
                            .picoCard()
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        startSession()
                    }
                    HapticService.heavyTap()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Practice")
                            .font(.system(.headline, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 16))
                    .shadow(color: Pico.deepForestGreen.opacity(0.2), radius: 8, y: 4)
                }
            }
            .padding(.horizontal, Pico.spacingXL)
            .padding(.bottom, 40)
        }
    }

    private var scenarioView: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Pico.earthBrown.opacity(0.08)).frame(height: 6)
                    Capsule().fill(Pico.primaryGradient)
                        .frame(width: scenarios.isEmpty ? 0 : geo.size.width * CGFloat(currentScenario) / CGFloat(scenarios.count), height: 6)
                        .animation(.spring, value: currentScenario)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 20)
            .padding(.top, 8)

            HStack {
                Text("\(currentScenario + 1)/\(scenarios.count)")
                    .font(.system(.caption, design: .rounded, weight: .semibold).monospacedDigit())
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.caption).foregroundStyle(Pico.gold)
                    Text("\(score)").font(.system(.caption, design: .rounded, weight: .bold).monospacedDigit())
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

            if currentScenario < scenarios.count {
                let scenario = scenarios[currentScenario]
                VStack(spacing: 16) {
                    Text(scenario.situation)
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.darkText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Pico.deepForestGreen.opacity(0.08), in: Capsule())

                    VStack(spacing: 8) {
                        Image(systemName: "person.wave.2.fill")
                            .font(.title2)
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.3))

                        Text(scenario.prompt)
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.darkText)
                            .multilineTextAlignment(.center)

                        Button {
                            speechService.speak(scenario.prompt, dialect: dialect)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.body)
                                .foregroundStyle(Pico.deepForestGreen)
                                .frame(width: 40, height: 40)
                                .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                        }
                    }

                    Text(scenario.instruction)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.darkTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                        .fill(Pico.cardSurface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                                .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
            }

            Spacer()

            VStack(spacing: 12) {
                TextField("Type your response...", text: $userAnswer)
                    .font(.system(.title3, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Pico.cardSurface, in: .rect(cornerRadius: 14))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 20)
                    .disabled(showResult)
                    .onSubmit { if !showResult && !userAnswer.isEmpty { checkAnswer() } }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Pico.portugueseChars, id: \.self) { char in
                            Button {
                                userAnswer += char
                                HapticService.lightTap()
                            } label: {
                                Text(char)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .foregroundStyle(Pico.deepForestGreen)
                                    .frame(width: 38, height: 38)
                                    .background(Pico.cardSurface, in: .rect(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .disabled(showResult)
                        }
                    }
                }
                .contentMargins(.horizontal, 20)

                if showResult {
                    resultBanner
                } else {
                    Button {
                        checkAnswer()
                    } label: {
                        Text("Check")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                userAnswer.isEmpty
                                ? AnyShapeStyle(Pico.earthBrown.opacity(0.2))
                                : AnyShapeStyle(Pico.primaryGradient),
                                in: .rect(cornerRadius: 14)
                            )
                    }
                    .disabled(userAnswer.isEmpty)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
            .animation(.spring(response: 0.35), value: showResult)
        }
    }

    private var resultBanner: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "info.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? Pico.leafGreen : Pico.terracotta)

                VStack(alignment: .leading, spacing: 2) {
                    Text(isCorrect ? "Correct!" : "Good try!")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Pico.darkText)
                    if currentScenario < scenarios.count {
                        Text("Answer: \(scenarios[currentScenario].answer)")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(isCorrect ? Pico.leafGreen : Pico.terracotta)
                    }
                }
                Spacer()

                if currentScenario < scenarios.count {
                    Button {
                        speechService.speak(scenarios[currentScenario].answer, dialect: dialect)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title3)
                            .foregroundStyle(Pico.deepForestGreen)
                            .frame(width: 44, height: 44)
                            .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                    }
                }
            }
            .picoCard()

            Button {
                advance()
            } label: {
                Text(currentScenario + 1 >= scenarios.count ? "Finish" : "Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var completionView: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 56))
                .foregroundStyle(Pico.leafGreen)
                .symbolEffect(.bounce, value: isComplete)

            Text("Conversation Done!")
                .font(.system(.title, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.darkText)

            Text("+\(score) XP")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Pico.gold)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .sensoryFeedback(.success, trigger: isComplete)
    }

    private func startSession() {
        currentScenario = 0
        score = 0
        userAnswer = ""
        showResult = false
        isCorrect = false
        isComplete = false
        if !scenarios.isEmpty {
            showResult = false
        }
    }

    private func checkAnswer() {
        guard currentScenario < scenarios.count else { return }
        let scenario = scenarios[currentScenario]
        let answer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = scenario.answer.lowercased()
        let acceptables = scenario.alternates.map { $0.lowercased() } + [correct]
        isCorrect = acceptables.contains(answer)
        showResult = true

        if isCorrect {
            score += 15
            engagementService.awardXP(15, source: "conversation")
            HapticService.success()
        } else {
            score += 3
            engagementService.awardXP(3, source: "conversation")
            HapticService.error()
        }
    }

    private func advance() {
        currentScenario += 1
        userAnswer = ""
        showResult = false
        isCorrect = false
        if currentScenario >= scenarios.count {
            engagementService.recordSession()
            isComplete = true
        }
    }
}

enum Difficulty: String, CaseIterable {
    case beginner, intermediate, advanced

    var title: String {
        switch self {
        case .beginner: "Beginner"
        case .intermediate: "Intermediate"
        case .advanced: "Advanced"
        }
    }

    var subtitle: String {
        switch self {
        case .beginner: "Simple greetings & responses"
        case .intermediate: "Daily situations & questions"
        case .advanced: "Complex sentences & expressions"
        }
    }

    var icon: String {
        switch self {
        case .beginner: "leaf.fill"
        case .intermediate: "tree.fill"
        case .advanced: "mountain.2.fill"
        }
    }

    var color: Color {
        switch self {
        case .beginner: Pico.leafGreen
        case .intermediate: Pico.amber
        case .advanced: Pico.terracotta
        }
    }
}

struct ConversationScenario {
    let situation: String
    let prompt: String
    let instruction: String
    let answer: String
    let alternates: [String]
    let difficulty: Difficulty
}
