import SwiftUI

struct PracticeView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @State private var viewModel: PracticeViewModel?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

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
                            .fill(Theme.tangerine.opacity(0.1))
                            .frame(width: 90, height: 90)
                        Image(systemName: "brain.head.profile.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Theme.tangerine)
                    }

                    Text("Conjugation Practice")
                        .font(.title2.weight(.bold))

                    Text("Test your knowledge across tenses and pronouns")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Tense")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(vm.availableTenses, id: \.self) { tense in
                                Button {
                                    vm.selectedTense = tense
                                    HapticService.selection()
                                } label: {
                                    Text(tense)
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            vm.selectedTense == tense
                                                ? Theme.tangerine.opacity(0.15)
                                                : Color(.tertiarySystemBackground),
                                            in: Capsule()
                                        )
                                        .overlay(
                                            Capsule().strokeBorder(
                                                vm.selectedTense == tense ? Theme.tangerine : .clear,
                                                lineWidth: 1.5
                                            )
                                        )
                                        .foregroundStyle(vm.selectedTense == tense ? Theme.tangerine : .primary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .contentMargins(.horizontal, 0)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Practice Mode")
                        .font(.headline)

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
                                        .font(.caption.weight(.semibold))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    vm.practiceMode == mode
                                        ? Theme.tangerine.opacity(0.15)
                                        : Color(.tertiarySystemBackground),
                                    in: .rect(cornerRadius: 12)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12).strokeBorder(
                                        vm.practiceMode == mode ? Theme.tangerine : .clear,
                                        lineWidth: 1.5
                                    )
                                )
                                .foregroundStyle(vm.practiceMode == mode ? Theme.tangerine : .primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        vm.startSession()
                    }
                    HapticService.heavyTap()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Practice")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Theme.tangerineGradient, in: .rect(cornerRadius: 16))
                    .shadow(color: Theme.tangerine.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.top, 8)
            }
            .padding(20)
        }
    }

    private func practiceSessionView(vm: PracticeViewModel) -> some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 8)
                    Capsule().fill(Theme.tangerineGradient)
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
                        .font(.subheadline.weight(.bold).monospacedDigit())
                }
                Spacer()
                Text("\(vm.currentIndex + 1) / \(vm.practiceItems.count)")
                    .font(.subheadline.weight(.medium).monospacedDigit())
                    .foregroundStyle(.secondary)
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
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.tangerine)
                .padding(.horizontal, 14)
                .padding(.vertical, 5)
                .background(Theme.tangerine.opacity(0.1), in: Capsule())

            VStack(spacing: 6) {
                Text(item.pronoun.displayName)
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.secondary)

                Text(item.verb.infinitive)
                    .font(.system(size: 34, weight: .bold, design: .rounded))

                HStack(spacing: 10) {
                    Text(item.verb.translation)
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)

                    Button {
                        vm.speak(item.verb.infinitive)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.body)
                            .foregroundStyle(Theme.tangerine)
                            .frame(width: 36, height: 36)
                            .background(Theme.tangerine.opacity(0.1), in: Circle())
                    }
                }
            }

            if item.verb.irregular {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                    Text("Irregular")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.orange)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))
    }

    private func typingSection(vm: PracticeViewModel) -> some View {
        VStack(spacing: 12) {
            TextField("Type the conjugation...", text: Bindable(vm).userAnswer)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(16)
                .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 20)
                .disabled(vm.showingResult)
                .onSubmit {
                    if !vm.showingResult && !vm.userAnswer.isEmpty {
                        vm.submitAnswer()
                    }
                }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Theme.portugueseChars, id: \.self) { char in
                        Button {
                            vm.userAnswer += char
                            HapticService.lightTap()
                        } label: {
                            Text(char)
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .frame(width: 38, height: 38)
                                .background(Color(.tertiarySystemBackground), in: .rect(cornerRadius: 8))
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
                } label: {
                    Text("Check")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            vm.userAnswer.isEmpty
                                ? AnyShapeStyle(Color(.systemGray4))
                                : AnyShapeStyle(Theme.tangerineGradient),
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
                } label: {
                    HStack {
                        Text(option)
                            .font(.body.weight(.medium))
                        Spacer()
                        if vm.showingResult {
                            if option.lowercased() == vm.correctAnswer.lowercased() {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else if option == vm.userAnswer && vm.isCorrect == false {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(mcOptionBg(option, vm: vm), in: .rect(cornerRadius: 14))
                    .foregroundStyle(mcOptionFg(option, vm: vm))
                }
                .buttonStyle(.plain)
                .disabled(vm.showingResult)
            }
        }
        .padding(.horizontal, 20)
    }

    private func mcOptionBg(_ option: String, vm: PracticeViewModel) -> some ShapeStyle {
        guard vm.showingResult else { return AnyShapeStyle(Color(.secondarySystemBackground)) }
        if option.lowercased() == vm.correctAnswer.lowercased() { return AnyShapeStyle(Color.green.opacity(0.1)) }
        if option == vm.userAnswer && vm.isCorrect == false { return AnyShapeStyle(Color.red.opacity(0.1)) }
        return AnyShapeStyle(Color(.secondarySystemBackground))
    }

    private func mcOptionFg(_ option: String, vm: PracticeViewModel) -> Color {
        guard vm.showingResult else { return .primary }
        if option.lowercased() == vm.correctAnswer.lowercased() { return .green }
        if option == vm.userAnswer && vm.isCorrect == false { return .red }
        return .secondary
    }

    private func resultFeedback(vm: PracticeViewModel) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill((vm.isCorrect == true ? Color.green : Color.red).opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: vm.isCorrect == true ? "checkmark" : "xmark")
                        .font(.body.weight(.bold))
                        .foregroundStyle(vm.isCorrect == true ? .green : .red)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.isCorrect == true ? "Correct!" : "Not quite")
                        .font(.headline)
                    if vm.isCorrect == false {
                        Text(vm.correctAnswer)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.tangerine)
                    }
                }

                Spacer()

                Button {
                    vm.speak(vm.correctAnswer)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.tangerine)
                        .frame(width: 44, height: 44)
                        .background(Theme.tangerine.opacity(0.1), in: Circle())
                }
            }
            .padding(16)
            .background(
                (vm.isCorrect == true ? Color.green : Color.red).opacity(0.06),
                in: .rect(cornerRadius: 16)
            )

            Button {
                withAnimation(.spring(response: 0.3)) {
                    vm.nextQuestion()
                }
            } label: {
                Text(vm.currentIndex + 1 >= vm.practiceItems.count ? "See Results" : "Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Theme.tangerineGradient, in: .rect(cornerRadius: 14))
            }
        }
    }

    private func resultsView(vm: PracticeViewModel) -> some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Theme.tangerine.opacity(0.08))
                    .frame(width: 120, height: 120)
                Image(systemName: vm.totalCorrect > vm.practiceItems.count / 2 ? "star.fill" : "arrow.trianglehead.counterclockwise")
                    .font(.system(size: 52))
                    .foregroundStyle(Theme.tangerine)
            }

            Text("Practice Complete!")
                .font(.system(.title, design: .rounded, weight: .bold))

            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    resultStat(value: "\(vm.totalCorrect)", label: "Correct", color: .green)
                    resultStat(value: "\(vm.totalAnswered - vm.totalCorrect)", label: "Incorrect", color: .red)
                    resultStat(value: "\(vm.score)", label: "Score", color: Theme.tangerine)
                }

                let pct = vm.totalAnswered > 0 ? Int(Double(vm.totalCorrect) / Double(vm.totalAnswered) * 100) : 0
                Text("\(pct)% Accuracy")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))

            Spacer()

            VStack(spacing: 12) {
                Button {
                    withAnimation(.spring) { vm.startSession() }
                } label: {
                    Text("Practice Again")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Theme.tangerineGradient, in: .rect(cornerRadius: 16))
                        .shadow(color: Theme.tangerine.opacity(0.3), radius: 8, y: 4)
                }

                Button {
                    withAnimation(.spring) { vm.resetSession() }
                } label: {
                    Text("Change Settings")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.tangerine)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

    private func resultStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.weight(.bold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
