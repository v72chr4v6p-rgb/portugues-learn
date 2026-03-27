import SwiftUI

struct PracticeView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @Environment(EngagementService.self) private var engagementService
    @Environment(SpeechService.self) private var speechService
    @State private var viewModel: PracticeViewModel?

    var body: some View {
        NavigationStack {
            ZStack {
                Pico.plaster.ignoresSafeArea()

                if let vm = viewModel {
                    if !vm.isSessionActive {
                        setupView(vm: vm)
                    } else if vm.isComplete {
                        resultsView(vm: vm)
                    } else {
                        practiceSessionView(vm: vm)
                    }
                }
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Practice")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
                if let vm = viewModel, vm.isSessionActive && !vm.isComplete {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("End") {
                            withAnimation(.spring) {
                                vm.resetSession()
                            }
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = PracticeViewModel(
                        verbDataService: verbDataService,
                        progressService: progressService,
                        dialect: dialect
                    )
                }
            }
        }
    }

    private func setupView(vm: PracticeViewModel) -> some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Pico.deepForestGreen.opacity(0.08))
                            .frame(width: 90, height: 90)
                        Image(systemName: "brain.head.profile.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Pico.deepForestGreen)
                    }

                    Text("Conjugation Practice")
                        .font(.system(.title2, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.darkText)

                    Text("Test your knowledge across tenses and pronouns")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.darkTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Tense")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.darkText)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(vm.availableTenses, id: \.self) { tense in
                                Button {
                                    vm.selectedTense = tense
                                    HapticService.selection()
                                } label: {
                                    Text(tense)
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            vm.selectedTense == tense
                                                ? Pico.deepForestGreen.opacity(0.12)
                                                : Pico.cardSurface,
                                            in: Capsule()
                                        )
                                        .overlay(
                                            Capsule().strokeBorder(
                                                vm.selectedTense == tense ? Pico.deepForestGreen : .clear,
                                                lineWidth: 1.5
                                            )
                                        )
                                        .foregroundStyle(vm.selectedTense == tense ? Pico.deepForestGreen : Pico.deepForestGreen.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .contentMargins(.horizontal, 0)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Practice Mode")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.darkText)

                    HStack(spacing: 12) {
                        ForEach(PracticeMode.allCases, id: \.self) { mode in
                            Button {
                                vm.practiceMode = mode
                                HapticService.selection()
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: mode.icon)
                                        .font(.title3)
                                    Text(mode.rawValue)
                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                                .foregroundStyle(vm.practiceMode == mode ? Pico.deepForestGreen : Pico.deepForestGreen.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(vm.practiceMode == mode ? Pico.deepForestGreen.opacity(0.1) : Pico.cardSurface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .strokeBorder(
                                                    vm.practiceMode == mode ? AnyShapeStyle(Pico.deepForestGreen.opacity(0.3)) : AnyShapeStyle(Pico.cardLightStroke),
                                                    lineWidth: 1
                                                )
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        vm.startSession()
                    }
                    engagementService.recordSession()
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
                .padding(.top, 8)
            }
            .padding(.horizontal, Pico.spacingXL)
            .padding(.bottom, 40)
        }
    }

    private func practiceSessionView(vm: PracticeViewModel) -> some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Pico.earthBrown.opacity(0.08)).frame(height: 8)
                    Capsule().fill(Pico.primaryGradient)
                        .frame(width: geo.size.width * vm.progress, height: 8)
                        .animation(.spring, value: vm.progress)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, 20)
            .padding(.top, 8)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    Text("\(vm.score)")
                        .font(.system(.subheadline, design: .rounded, weight: .bold).monospacedDigit())
                        .foregroundStyle(Pico.darkText)
                }
                Spacer()
                Text("\(vm.currentIndex + 1) / \(vm.practiceItems.count)")
                    .font(.system(.subheadline, design: .rounded, weight: .medium).monospacedDigit())
                    .foregroundStyle(Pico.darkTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()

            if let item = vm.currentItem {
                questionCard(item: item, vm: vm)
                    .padding(.horizontal, 20)
            }

            Spacer()

            if vm.practiceMode == .fillBlank {
                typingSection(vm: vm)
            } else {
                multipleChoiceSection(vm: vm)
            }

            if vm.showingResult {
                resultFeedback(vm: vm)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.bottom, 20)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.showingResult)
    }

    private func questionCard(item: PracticeViewModel.PracticeItem, vm: PracticeViewModel) -> some View {
        VStack(spacing: 20) {
            Text(item.tense)
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(Pico.deepForestGreen)
                .padding(.horizontal, 14)
                .padding(.vertical, 5)
                .background(Pico.deepForestGreen.opacity(0.08), in: Capsule())

            VStack(spacing: 6) {
                Text(item.pronoun.displayName)
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.6))

                Text(item.verb.infinitive)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Pico.darkText)

                HStack(spacing: 10) {
                    Text(item.verb.translation)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.darkTextSecondary)

                    Button {
                        speechService.speak(item.verb.infinitive, dialect: dialect)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.body)
                            .foregroundStyle(Pico.deepForestGreen)
                            .frame(width: 36, height: 36)
                            .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                    }
                }
            }

            if item.verb.irregular {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                    Text("Irregular")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                }
                .foregroundStyle(.orange)
            }
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
    }

    private func typingSection(vm: PracticeViewModel) -> some View {
        VStack(spacing: 12) {
            TextField("Type the conjugation...", text: Bindable(vm).userAnswer)
                .font(.system(.title3, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(16)
                .background(Pico.cardSurface, in: .rect(cornerRadius: 14))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 20)
                .disabled(vm.showingResult)
                .onSubmit {
                    if !vm.showingResult && !vm.userAnswer.isEmpty {
                        vm.submitAnswer()
                        awardPracticeXP(vm: vm)
                    }
                }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Pico.portugueseChars, id: \.self) { char in
                        Button {
                            vm.userAnswer += char
                            HapticService.lightTap()
                        } label: {
                            Text(char)
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .foregroundStyle(Pico.deepForestGreen)
                                .frame(width: 38, height: 38)
                                .background(Pico.cardSurface, in: .rect(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                        .disabled(vm.showingResult)
                    }
                }
            }
            .contentMargins(.horizontal, 20)

            if !vm.showingResult {
                Button {
                    vm.submitAnswer()
                    awardPracticeXP(vm: vm)
                } label: {
                    Text("Check")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            vm.userAnswer.isEmpty
                                ? AnyShapeStyle(Pico.earthBrown.opacity(0.2))
                                : AnyShapeStyle(Pico.primaryGradient),
                            in: .rect(cornerRadius: 14)
                        )
                }
                .disabled(vm.userAnswer.isEmpty)
                .padding(.horizontal, 20)
            }
        }
    }

    private func multipleChoiceSection(vm: PracticeViewModel) -> some View {
        VStack(spacing: 10) {
            ForEach(vm.multipleChoiceOptions, id: \.self) { option in
                Button {
                    vm.selectOption(option)
                    awardPracticeXP(vm: vm)
                } label: {
                    HStack {
                        Text(option)
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundStyle(mcOptionFg(option, vm: vm))
                        Spacer()
                        if vm.showingResult {
                            if option.lowercased() == vm.correctAnswer.lowercased() {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Pico.leafGreen)
                            } else if option == vm.userAnswer && vm.isCorrect == false {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(mcOptionBg(option, vm: vm), in: .rect(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .disabled(vm.showingResult)
            }
        }
        .padding(.horizontal, 20)
    }

    private func mcOptionBg(_ option: String, vm: PracticeViewModel) -> some ShapeStyle {
        guard vm.showingResult else { return AnyShapeStyle(Pico.cardSurface) }
        if option.lowercased() == vm.correctAnswer.lowercased() { return AnyShapeStyle(Pico.leafGreen.opacity(0.1)) }
        if option == vm.userAnswer && vm.isCorrect == false { return AnyShapeStyle(Color.red.opacity(0.1)) }
        return AnyShapeStyle(Pico.cardSurface)
    }

    private func mcOptionFg(_ option: String, vm: PracticeViewModel) -> Color {
        guard vm.showingResult else { return Pico.darkText }
        if option.lowercased() == vm.correctAnswer.lowercased() { return Pico.leafGreen }
        if option == vm.userAnswer && vm.isCorrect == false { return .red }
        return Pico.darkTextSecondary
    }

    private func awardPracticeXP(vm: PracticeViewModel) {
        let amount = vm.isCorrect == true ? 10 : 2
        engagementService.awardXP(amount, source: "practice")
    }

    private func resultFeedback(vm: PracticeViewModel) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill((vm.isCorrect == true ? Pico.leafGreen : Color.red).opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: vm.isCorrect == true ? "checkmark" : "xmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(vm.isCorrect == true ? Pico.leafGreen : .red)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.isCorrect == true ? "Correct!" : "Not quite")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Pico.darkText)
                    if vm.isCorrect == false {
                        Text(vm.correctAnswer)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.terracotta)
                    }
                }

                Spacer()

                Button {
                    speechService.speak(vm.correctAnswer, dialect: dialect)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                        .foregroundStyle(Pico.deepForestGreen)
                        .frame(width: 44, height: 44)
                        .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                }
            }
            .picoCard()

            Button {
                withAnimation(.spring(response: 0.3)) {
                    vm.nextQuestion()
                }
            } label: {
                Text(vm.currentIndex + 1 >= vm.practiceItems.count ? "See Results" : "Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 14))
            }
        }
    }

    private func resultsView(vm: PracticeViewModel) -> some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Pico.leafGreen.opacity(0.08))
                    .frame(width: 120, height: 120)
                Image(systemName: vm.totalCorrect > vm.practiceItems.count / 2 ? "star.fill" : "arrow.trianglehead.counterclockwise")
                    .font(.system(size: 52))
                    .foregroundStyle(vm.totalCorrect > vm.practiceItems.count / 2 ? Pico.gold : Pico.deepForestGreen)
            }

            Text("Practice Complete!")
                .font(.system(.title, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.darkText)

            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    resultStat(value: "\(vm.totalCorrect)", label: "Correct", color: Pico.leafGreen)
                    resultStat(value: "\(vm.totalAnswered - vm.totalCorrect)", label: "Incorrect", color: .red)
                    resultStat(value: "\(vm.score)", label: "Score", color: Pico.gold)
                }

                let pct = vm.totalAnswered > 0 ? Int(Double(vm.totalCorrect) / Double(vm.totalAnswered) * 100) : 0
                Text("\(pct)% Accuracy")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Pico.darkTextSecondary)
            }
            .picoCard()

            Spacer()

            VStack(spacing: 12) {
                Button {
                    withAnimation(.spring) { vm.startSession() }
                } label: {
                    Text("Practice Again")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Pico.primaryGradient, in: .rect(cornerRadius: 16))
                        .shadow(color: Pico.deepForestGreen.opacity(0.2), radius: 8, y: 4)
                }

                Button {
                    withAnimation(.spring) { vm.resetSession() }
                } label: {
                    Text("Change Settings")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    private func resultStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(color)
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
}
