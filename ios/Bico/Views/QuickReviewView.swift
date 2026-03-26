import SwiftUI

struct QuickReviewView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @Environment(EngagementService.self) private var engagementService
    @Environment(SpeechService.self) private var speechService
    @Environment(\.dismiss) private var dismiss
    @State private var items: [(Verb, Pronoun, String)] = []
    @State private var currentIndex: Int = 0
    @State private var userAnswer: String = ""
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool = false
    @State private var score: Int = 0
    @State private var isComplete: Bool = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            if isComplete {
                completionView
            } else if !items.isEmpty {
                quizContent
            } else {
                ProgressView("Loading...")
                    .task { buildItems() }
            }
        }
        .navigationTitle("Quick Review")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var quizContent: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 6)
                    Capsule().fill(Theme.tangerineGradient)
                        .frame(width: items.isEmpty ? 0 : geo.size.width * CGFloat(currentIndex) / CGFloat(items.count), height: 6)
                        .animation(.spring, value: currentIndex)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 20)
            .padding(.top, 8)

            HStack {
                Text("\(currentIndex + 1)/\(items.count)")
                    .font(.caption.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.caption).foregroundStyle(Theme.gold)
                    Text("\(score)").font(.caption.weight(.bold).monospacedDigit())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

            if currentIndex < items.count {
                let item = items[currentIndex]
                VStack(spacing: 16) {
                    Text(item.2)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.tangerine)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Theme.tangerine.opacity(0.1), in: Capsule())

                    Text(item.1.displayName)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.secondary)

                    Text(item.0.infinitive)
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    Text(item.0.translation)
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)

                    Button {
                        speechService.speak(item.0.infinitive, dialect: dialect)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.body)
                            .foregroundStyle(Theme.tangerine)
                            .frame(width: 40, height: 40)
                            .background(Theme.tangerine.opacity(0.1), in: Circle())
                    }
                }
            }

            Spacer()

            VStack(spacing: 12) {
                TextField("Type the conjugation...", text: $userAnswer)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 20)
                    .disabled(showResult)
                    .onSubmit { if !showResult && !userAnswer.isEmpty { checkAnswer() } }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Theme.portugueseChars, id: \.self) { char in
                            Button {
                                userAnswer += char
                                HapticService.lightTap()
                            } label: {
                                Text(char)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .frame(width: 38, height: 38)
                                    .background(Color(.tertiarySystemBackground), in: .rect(cornerRadius: 8))
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
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                userAnswer.isEmpty
                                ? AnyShapeStyle(Color(.systemGray4))
                                : AnyShapeStyle(Theme.tangerineGradient),
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
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? .green : .red)

                VStack(alignment: .leading, spacing: 2) {
                    Text(isCorrect ? "Correct!" : "Not quite")
                        .font(.headline)
                    if !isCorrect && currentIndex < items.count {
                        Text(items[currentIndex].0.conjugation(for: items[currentIndex].1, dialect: dialect) ?? "")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.tangerine)
                    }
                }
                Spacer()
            }
            .padding(14)
            .background((isCorrect ? Color.green : Color.red).opacity(0.06), in: .rect(cornerRadius: 14))

            Button {
                advance()
            } label: {
                Text(currentIndex + 1 >= items.count ? "Finish" : "Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Theme.tangerineGradient, in: .rect(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var completionView: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 56))
                .foregroundStyle(Theme.tangerine)
                .symbolEffect(.bounce, value: isComplete)

            Text("Quick Review Done!")
                .font(.system(.title, design: .rounded, weight: .bold))

            Text("+\(score) XP")
                .font(.title2.weight(.bold))
                .foregroundStyle(Theme.gold)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Theme.tangerineGradient, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .sensoryFeedback(.success, trigger: isComplete)
    }

    private func buildItems() {
        var pool: [(Verb, Pronoun, String)] = []
        for level in verbDataService.levels where progressService.isLevelUnlocked(level.level) {
            for verb in level.verbs {
                for pronoun in dialect.pronouns {
                    if let conj = verb.conjugation(for: pronoun, dialect: dialect), conj != "—" {
                        pool.append((verb, pronoun, level.tense))
                    }
                }
            }
        }
        items = Array(pool.shuffled().prefix(10))
    }

    private func checkAnswer() {
        guard currentIndex < items.count else { return }
        let item = items[currentIndex]
        let correct = item.0.conjugation(for: item.1, dialect: dialect)?.lowercased() ?? ""
        let answer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        isCorrect = answer == correct
        showResult = true

        if isCorrect {
            score += 10
            engagementService.awardXP(10, source: "quick_review")
            HapticService.success()
        } else {
            HapticService.error()
        }

        progressService.recordAnswer(
            level: item.0.level ?? 1,
            verb: item.0.infinitive,
            correct: isCorrect
        )
    }

    private func advance() {
        currentIndex += 1
        userAnswer = ""
        showResult = false
        isCorrect = false
        if currentIndex >= items.count {
            engagementService.recordSession()
            isComplete = true
        }
    }
}
