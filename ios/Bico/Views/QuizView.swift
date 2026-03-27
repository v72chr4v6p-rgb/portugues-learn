import SwiftUI

struct QuizView: View {
    @State private var viewModel: QuizViewModel
    @Environment(ProgressService.self) private var progressService
    @Environment(EngagementService.self) private var engagementService
    @Environment(\.dismiss) private var dismiss

    init(level: Level, dialect: Dialect, pronouns: Set<Pronoun>, gameMode: GameMode, useTimer: Bool) {
        _viewModel = State(initialValue: QuizViewModel(
            level: level,
            dialect: dialect,
            selectedPronouns: pronouns,
            gameMode: gameMode,
            useTimer: useTimer
        ))
    }

    var body: some View {
        ZStack {
            Pico.plaster.ignoresSafeArea()

            if viewModel.isComplete {
                completionView
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            } else {
                quizContent
            }
        }
        .navigationTitle("Level \(viewModel.level.level)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(viewModel.questionsAnswered)/\(viewModel.totalQuestions)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var quizContent: some View {
        VStack(spacing: 0) {
            progressBar
                .padding(.horizontal, 20)
                .padding(.top, 8)

            if viewModel.useTimer {
                timerBar
                    .padding(.top, 10)
            }

            streakIndicator
                .padding(.top, 8)

            Spacer()

            if let verb = viewModel.currentVerb {
                verbPrompt(verb: verb)
            }

            Spacer()

            if viewModel.gameMode == .zenTyping {
                typingInput
            } else {
                multipleChoiceInput
            }

            if viewModel.showingResult {
                resultBanner
                    .padding(.top, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.bottom, 20)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showingResult)
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Pico.earthBrown.opacity(0.08))
                    .frame(height: 8)

                Capsule()
                    .fill(Pico.primaryGradient)
                    .frame(
                        width: viewModel.totalQuestions > 0
                            ? geo.size.width * CGFloat(viewModel.questionsAnswered) / CGFloat(viewModel.totalQuestions)
                            : 0,
                        height: 8
                    )
                    .animation(.spring(response: 0.4), value: viewModel.questionsAnswered)
            }
        }
        .frame(height: 8)
    }

    private var timerBar: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(.caption)
                .foregroundStyle(viewModel.timeRemaining <= 10 ? .red : Pico.terracotta)
            Text("\(viewModel.timeRemaining)s")
                .font(.system(.headline, design: .rounded).monospacedDigit())
                .foregroundStyle(viewModel.timeRemaining <= 10 ? .red : Pico.deepForestGreen)
                .contentTransition(.numericText())
                .animation(.spring, value: viewModel.timeRemaining)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
            (viewModel.timeRemaining <= 10 ? Color.red : Pico.terracotta).opacity(0.08),
            in: Capsule()
        )
    }

    private var streakIndicator: some View {
        Group {
            if viewModel.score > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    Text("\(viewModel.score) pts")
                        .font(.caption.weight(.bold).monospacedDigit())
                        .foregroundStyle(.orange)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring, value: viewModel.score)
    }

    private func verbPrompt(verb: Verb) -> some View {
        VStack(spacing: 18) {
            Text(viewModel.currentPronoun.displayName)
                .font(.system(.title3, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.darkTextSecondary)

            Text(verb.infinitive)
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(Pico.darkText)

            HStack(spacing: 10) {
                Text(verb.translation)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Pico.darkTextSecondary)

                Button {
                    viewModel.speak(verb.infinitive)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.body)
                        .foregroundStyle(Pico.deepForestGreen)
                        .frame(width: 36, height: 36)
                        .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                }
            }

            if verb.irregular {
                Text("Irregular")
                    .font(.system(.caption, design: .rounded, weight: .bold))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.1), in: Capsule())
            }

            Text(viewModel.level.tense)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.darkTextSecondary)
        }
        .padding(.horizontal, 20)
    }

    private var typingInput: some View {
        VStack(spacing: 12) {
            TextField("Type the conjugation...", text: Bindable(viewModel).userAnswer)
                .font(.system(.title3, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(16)
                .background(Pico.cardSurface, in: .rect(cornerRadius: 14))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 20)
                .disabled(viewModel.showingResult)
                .onSubmit {
                    if !viewModel.showingResult {
                        submitCurrentAnswer()
                    }
                }

            portugueseKeyboardRow

            if !viewModel.showingResult {
                Button {
                    submitCurrentAnswer()
                } label: {
                    Text("Check")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Pico.plaster)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            viewModel.userAnswer.isEmpty
                                ? AnyShapeStyle(Pico.earthBrown.opacity(0.2))
                                : AnyShapeStyle(Pico.primaryGradient),
                            in: .rect(cornerRadius: 14)
                        )
                }
                .disabled(viewModel.userAnswer.isEmpty)
                .padding(.horizontal, 20)
            }
        }
    }

    private var portugueseKeyboardRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(Theme.portugueseChars, id: \.self) { char in
                    Button {
                        viewModel.userAnswer += char
                        HapticService.lightTap()
                    } label: {
                        Text(char)
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundStyle(Pico.deepForestGreen)
                            .frame(width: 38, height: 38)
                            .background(Pico.cardSurface, in: .rect(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.showingResult)
                }
            }
        }
        .contentMargins(.horizontal, 20)
    }

    private var multipleChoiceInput: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.multipleChoiceOptions, id: \.self) { option in
                Button {
                    viewModel.selectMultipleChoice(option)
                    recordCurrentAnswer()
                } label: {
                    HStack {
                        Text(option)
                            .font(.body.weight(.medium))
                        Spacer()
                        if viewModel.showingResult {
                            if option.lowercased() == viewModel.correctAnswer.lowercased() {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else if option == viewModel.userAnswer && viewModel.isCorrect == false {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(optionBackground(option), in: .rect(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(optionBorder(option), lineWidth: 2)
                    )
                    .foregroundStyle(optionForeground(option))
                }
                .buttonStyle(.plain)
                .disabled(viewModel.showingResult)
            }
        }
        .padding(.horizontal, 20)
    }

    private func optionBackground(_ option: String) -> some ShapeStyle {
        guard viewModel.showingResult else {
            return AnyShapeStyle(Pico.cardSurface)
        }
        if option.lowercased() == viewModel.correctAnswer.lowercased() {
            return AnyShapeStyle(Pico.leafGreen.opacity(0.1))
        }
        if option == viewModel.userAnswer && viewModel.isCorrect == false {
            return AnyShapeStyle(Color.red.opacity(0.1))
        }
        return AnyShapeStyle(Pico.cardSurface)
    }

    private func optionBorder(_ option: String) -> Color {
        guard viewModel.showingResult else { return .clear }
        if option.lowercased() == viewModel.correctAnswer.lowercased() { return Pico.leafGreen }
        if option == viewModel.userAnswer && viewModel.isCorrect == false { return .red }
        return .clear
    }

    private func optionForeground(_ option: String) -> Color {
        guard viewModel.showingResult else { return Pico.darkText }
        if option.lowercased() == viewModel.correctAnswer.lowercased() { return Pico.leafGreen }
        if option == viewModel.userAnswer && viewModel.isCorrect == false { return .red }
        return Pico.darkTextSecondary
    }

    private func submitCurrentAnswer() {
        viewModel.submitAnswer()
        recordCurrentAnswer()
    }

    private func recordCurrentAnswer() {
        progressService.recordAnswer(
            level: viewModel.level.level,
            verb: viewModel.currentVerb?.infinitive ?? "",
            correct: viewModel.isCorrect == true
        )
        let xpAmount = viewModel.isCorrect == true ? 10 : 2
        engagementService.awardXP(xpAmount, source: "quiz")
    }

    private var resultBanner: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill((viewModel.isCorrect == true ? Pico.leafGreen : Color.red).opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: viewModel.isCorrect == true ? "checkmark" : "xmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(viewModel.isCorrect == true ? Pico.leafGreen : .red)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.isCorrect == true ? "Correct!" : "Not quite")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Pico.darkText)

                    if viewModel.isCorrect == false {
                        Text(viewModel.correctAnswer)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.terracotta)
                    }
                }

                Spacer()

                Button {
                    viewModel.speak(viewModel.correctAnswer)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                        .foregroundStyle(Pico.deepForestGreen)
                        .frame(width: 44, height: 44)
                        .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                }
            }
            .picoCard()

            if viewModel.isCorrect == false && !viewModel.feedbackExplanation.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundStyle(Pico.amber)
                        Text("Why?")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundStyle(Pico.amber)
                    }
                    Text(viewModel.feedbackExplanation)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                        .lineSpacing(2)
                    if !viewModel.feedbackExample.isEmpty {
                        Text(viewModel.feedbackExample)
                            .font(.system(.caption, design: .rounded).italic())
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Pico.amber.opacity(0.06), in: .rect(cornerRadius: 12))
                .padding(.horizontal, 4)
            }

            Button {
                if viewModel.questionsAnswered >= viewModel.totalQuestions {
                    progressService.completeLevel(viewModel.level.level, score: viewModel.score)
                    engagementService.recordSession()
                }
                viewModel.nextQuestion()
            } label: {
                Text(viewModel.questionsAnswered >= viewModel.totalQuestions ? "Finish" : "Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Pico.plaster)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
    }

    private var completionView: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Pico.leafGreen.opacity(0.08))
                    .frame(width: 140, height: 140)
                Image(systemName: "bird.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(Pico.leafGreen)
                    .symbolEffect(.bounce, value: viewModel.isComplete)
            }

            VStack(spacing: 8) {
                Text("Level Complete!")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .tracking(-0.5)
                    .foregroundStyle(Pico.darkText)

                Text("You conquered the \(viewModel.level.tense)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Pico.darkTextSecondary)
            }

            HStack(spacing: 20) {
                completionStat(icon: "star.fill", value: "\(viewModel.score)", label: "Score", color: Pico.gold)
                completionStat(icon: "checkmark.circle.fill", value: "\(viewModel.questionsAnswered)", label: "Answered", color: Pico.leafGreen)
            }
            .padding(.horizontal, 40)

            Spacer()

            Button {
                HapticService.heavyTap()
                dismiss()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.left")
                    Text("Back to Path")
                        .font(.system(.headline, design: .rounded))
                }
                .foregroundStyle(Pico.plaster)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Pico.primaryGradient, in: .rect(cornerRadius: 16))
                .shadow(color: Pico.deepForestGreen.opacity(0.2), radius: 8, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .sensoryFeedback(.success, trigger: viewModel.isComplete)
    }

    private func completionStat(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.system(.title, design: .rounded, weight: .bold).monospacedDigit())
                .foregroundStyle(Pico.deepForestGreen)
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Pico.cardSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                )
        )
    }
}
