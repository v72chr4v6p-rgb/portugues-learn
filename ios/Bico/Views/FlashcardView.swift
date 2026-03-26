import SwiftUI

struct FlashcardView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @Environment(SpeechService.self) private var speechService
    @State private var viewModel: FlashcardViewModel?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                if let vm = viewModel {
                    if vm.isComplete {
                        completionView(vm: vm)
                    } else if vm.cards.isEmpty {
                        ContentUnavailableView("No Cards", systemImage: "rectangle.stack", description: Text("No flashcards available"))
                    } else {
                        cardStackView(vm: vm)
                    }
                }
            }
            .navigationTitle("Flashcards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            viewModel?.reset()
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.subheadline.weight(.medium))
                    }
                    .tint(Theme.tangerine)
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = FlashcardViewModel(
                        verbDataService: verbDataService,
                        progressService: progressService,
                        dialect: dialect
                    )
                }
            }
        }
    }

    private func cardStackView(vm: FlashcardViewModel) -> some View {
        VStack(spacing: 16) {
            progressHeader(vm: vm)
                .padding(.horizontal, 24)
                .padding(.top, 8)

            Spacer()

            ZStack {
                let start = vm.currentIndex
                let end = min(vm.currentIndex + 3, vm.cards.count)
                if start < end {
                    ForEach(Array(start..<end), id: \.self) { index in
                        let offset = index - vm.currentIndex
                        let card = vm.cards[index]
                        cardView(card: card, stackOffset: offset, vm: vm)
                            .zIndex(Double(3 - offset))
                    }
                }
            }
            .frame(height: 400)
            .padding(.horizontal, 24)

            Spacer()

            swipeActionBar(vm: vm)
                .padding(.horizontal, 40)
                .padding(.bottom, 4)

            swipeHintText
                .padding(.bottom, 16)
        }
    }

    private func cardView(card: FlashcardViewModel.FlashcardItem, stackOffset: Int, vm: FlashcardViewModel) -> some View {
        let isFront = stackOffset == 0
        let scale = 1.0 - Double(stackOffset) * 0.05
        let yOff = Double(stackOffset) * 10

        return ZStack {
            if isFront {
                frontCard(card: card, vm: vm)
                    .offset(vm.dragOffset)
                    .rotationEffect(.degrees(Double(vm.dragOffset.width) / 25))
                    .scaleEffect(scale)
                    .offset(y: yOff)
                    .gesture(swipeGesture(vm: vm))
                    .overlay {
                        swipeOverlayIndicator(vm: vm)
                            .offset(vm.dragOffset)
                            .rotationEffect(.degrees(Double(vm.dragOffset.width) / 25))
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.dragOffset)
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.tertiarySystemBackground))
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                    .frame(maxWidth: .infinity)
                    .frame(height: 380)
                    .overlay {
                        Text(card.verb.infinitive)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.tertiary)
                    }
                    .scaleEffect(scale)
                    .offset(y: yOff)
            }
        }
    }

    private func frontCard(card: FlashcardViewModel.FlashcardItem, vm: FlashcardViewModel) -> some View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                vm.flipCard()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 8)

                if !vm.isFlipped {
                    cardFrontContent(card: card, vm: vm)
                } else {
                    cardBackContent(card: card, vm: vm)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 380)
        }
        .buttonStyle(.plain)
        .rotation3DEffect(
            .degrees(vm.isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
    }

    private func cardFrontContent(card: FlashcardViewModel.FlashcardItem, vm: FlashcardViewModel) -> some View {
        VStack(spacing: 16) {
            Spacer()

            Text(card.tense)
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.tangerine)
                .padding(.horizontal, 14)
                .padding(.vertical, 5)
                .background(Theme.tangerine.opacity(0.1), in: Capsule())

            Text(card.verb.infinitive)
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text(card.verb.translation)
                .font(.title3)
                .foregroundStyle(.secondary)

            if card.verb.irregular {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                    Text("Irregular")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(.orange)
            }

            Button {
                speechService.speak(card.verb.infinitive, dialect: vm.dialect)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.subheadline)
                    Text("Listen")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(Theme.tangerine)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Theme.tangerine.opacity(0.1), in: Capsule())
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "hand.tap")
                    .font(.caption2)
                Text("Tap to reveal conjugations")
                    .font(.caption)
            }
            .foregroundStyle(.quaternary)
            .padding(.bottom, 20)
        }
        .padding(24)
    }

    private func cardBackContent(card: FlashcardViewModel.FlashcardItem, vm: FlashcardViewModel) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text(card.verb.infinitive)
                    .font(.headline)
                    .foregroundStyle(Theme.tangerine)
                Spacer()
                Button {
                    speechService.speak(card.verb.infinitive, dialect: vm.dialect)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.subheadline)
                        .foregroundStyle(Theme.tangerine)
                        .frame(width: 36, height: 36)
                        .background(Theme.tangerine.opacity(0.1), in: Circle())
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)

            Divider().padding(.horizontal, 20)

            let conjugations = card.verb.conjugations.forDialect(vm.dialect)
            VStack(spacing: 8) {
                ForEach(Array(conjugations.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                    HStack {
                        Text(Pronoun(rawValue: key)?.displayName ?? key)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(width: 80, alignment: .trailing)
                        Text(value)
                            .font(.body.weight(.semibold))

                        Spacer()

                        Button {
                            speechService.speak(value, dialect: vm.dialect)
                        } label: {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.tangerine.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }

            Spacer()
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }

    private func swipeOverlayIndicator(vm: FlashcardViewModel) -> some View {
        ZStack {
            if vm.dragOffset.width > 40 {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.green, lineWidth: 3)
                    .overlay(alignment: .topLeading) {
                        Text("MASTERED")
                            .font(.title3.weight(.heavy))
                            .foregroundStyle(.green)
                            .rotationEffect(.degrees(-15))
                            .padding(24)
                    }
                    .opacity(min(Double(vm.dragOffset.width - 40) / 80, 1))
            }

            if vm.dragOffset.width < -40 {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.red, lineWidth: 3)
                    .overlay(alignment: .topTrailing) {
                        Text("REVIEW")
                            .font(.title3.weight(.heavy))
                            .foregroundStyle(.red)
                            .rotationEffect(.degrees(15))
                            .padding(24)
                    }
                    .opacity(min(Double(abs(vm.dragOffset.width) - 40) / 80, 1))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
        .allowsHitTesting(false)
    }

    private func swipeGesture(vm: FlashcardViewModel) -> some Gesture {
        DragGesture()
            .onChanged { value in
                vm.dragOffset = value.translation
            }
            .onEnded { value in
                let threshold: CGFloat = 120
                if value.translation.width > threshold {
                    swipeAway(direction: .right, vm: vm)
                } else if value.translation.width < -threshold {
                    swipeAway(direction: .left, vm: vm)
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        vm.dragOffset = .zero
                    }
                }
            }
    }

    private func swipeAway(direction: SwipeDirection, vm: FlashcardViewModel) {
        let flyOutX: CGFloat = direction == .right ? 500 : -500
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            vm.dragOffset = CGSize(width: flyOutX, height: direction == .right ? -30 : 30)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if direction == .right {
                vm.swipeRight()
            } else {
                vm.swipeLeft()
            }
        }
    }

    private func progressHeader(vm: FlashcardViewModel) -> some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(Color.green).frame(width: 8, height: 8)
                    Text("\(vm.masteredCount) mastered")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(vm.currentIndex + 1) of \(vm.cards.count)")
                    .font(.subheadline.weight(.bold).monospacedDigit())

                Spacer()

                HStack(spacing: 6) {
                    Text("\(vm.studyAgainCount) review")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Circle().fill(Color.orange).frame(width: 8, height: 8)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5))
                    Capsule().fill(Theme.tangerineGradient)
                        .frame(width: vm.cards.count > 0
                            ? geo.size.width * CGFloat(vm.currentIndex) / CGFloat(vm.cards.count)
                            : 0
                        )
                        .animation(.spring, value: vm.currentIndex)
                }
            }
            .frame(height: 5)
        }
    }

    private func swipeActionBar(vm: FlashcardViewModel) -> some View {
        HStack(spacing: 36) {
            Button {
                swipeAway(direction: .left, vm: vm)
            } label: {
                Image(systemName: "xmark")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.red)
                    .frame(width: 64, height: 64)
                    .background(
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: .red.opacity(0.1), radius: 8, y: 2)
                    )
            }

            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    vm.flipCard()
                }
            } label: {
                Image(systemName: "arrow.turn.up.right")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.tangerine)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Theme.tangerine.opacity(0.1), radius: 8, y: 2)
                    )
            }

            Button {
                swipeAway(direction: .right, vm: vm)
            } label: {
                Image(systemName: "checkmark")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.green)
                    .frame(width: 64, height: 64)
                    .background(
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: .green.opacity(0.1), radius: 8, y: 2)
                    )
            }
        }
    }

    private var swipeHintText: some View {
        HStack(spacing: 24) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.left").font(.caption2)
                Text("Study Again")
            }
            .foregroundStyle(.red.opacity(0.5))

            HStack(spacing: 4) {
                Text("Mastered")
                Image(systemName: "arrow.right").font(.caption2)
            }
            .foregroundStyle(.green.opacity(0.5))
        }
        .font(.caption.weight(.medium))
    }

    private func completionView(vm: FlashcardViewModel) -> some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Theme.tangerine.opacity(0.08))
                    .frame(width: 140, height: 140)
                Image(systemName: "sparkles")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.tangerine)
                    .symbolEffect(.bounce, value: vm.isComplete)
            }

            Text("Session Complete!")
                .font(.system(.title, design: .rounded, weight: .bold))

            HStack(spacing: 32) {
                VStack(spacing: 6) {
                    Text("\(vm.masteredCount)")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.green)
                    Text("Mastered")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 6) {
                    Text("\(vm.studyAgainCount)")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.orange)
                    Text("Review")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(24)
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20))

            Spacer()

            Button {
                withAnimation(.spring) { vm.reset() }
            } label: {
                Text("Start New Session")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Theme.tangerineGradient, in: .rect(cornerRadius: 16))
                    .shadow(color: Theme.tangerine.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

nonisolated enum SwipeDirection: Sendable {
    case left, right
}
