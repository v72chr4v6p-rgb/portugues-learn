import SwiftUI

struct VerbExplorerView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(VerbGlossaryService.self) private var glossaryService
    @Environment(SpeechService.self) private var speechService
    @State private var searchText: String = ""
    @State private var selectedVerb: Verb?
    @State private var filterIrregular: Bool? = nil
    @State private var showGlossary: Bool = false

    private var uniqueVerbs: [Verb] {
        var seen = Set<String>()
        var result: [Verb] = []
        for level in verbDataService.levels {
            for verb in level.verbs {
                let key = verb.infinitive.lowercased()
                if !seen.contains(key) {
                    seen.insert(key)
                    result.append(verb)
                }
            }
        }
        return result.sorted { $0.infinitive < $1.infinitive }
    }

    private var filteredVerbs: [Verb] {
        var verbs = uniqueVerbs
        if let irregular = filterIrregular {
            verbs = verbs.filter { $0.irregular == irregular }
        }
        if !searchText.isEmpty {
            verbs = verbs.filter {
                $0.infinitive.localizedStandardContains(searchText) ||
                $0.translation.localizedStandardContains(searchText)
            }
        }
        return verbs
    }

    private var filteredGlossary: [GlossaryVerb] {
        var verbs = glossaryService.allVerbs
        if let irregular = filterIrregular {
            verbs = verbs.filter { $0.irregular == irregular }
        }
        if !searchText.isEmpty {
            verbs = verbs.filter {
                $0.infinitive.localizedStandardContains(searchText) ||
                $0.translation.localizedStandardContains(searchText)
            }
        }
        return verbs
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    filterRow
                        .padding(.horizontal, Pico.spacingXL)
                        .padding(.vertical, 12)

                    viewToggle
                        .padding(.horizontal, Pico.spacingXL)
                        .padding(.bottom, 12)

                    if showGlossary {
                        glossaryList
                    } else {
                        levelVerbsList
                    }
                }
                .padding(.bottom, 120)
            }
            .background(Pico.plaster.ignoresSafeArea())
            .searchable(text: $searchText, prompt: "Search verbs...")
            .navigationTitle("Verb Explorer")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Verb Explorer")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
            .sheet(item: $selectedVerb) { verb in
                VerbDetailSheet(verb: verb, dialect: dialect)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .overlay {
                if showGlossary && filteredGlossary.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else if !showGlossary && filteredVerbs.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
    }

    private var viewToggle: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3)) { showGlossary = false }
                HapticService.selection()
            } label: {
                Text("Level Verbs")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(!showGlossary ? Pico.deepForestGreen : Color.clear, in: .rect(cornerRadius: 12))
                    .foregroundStyle(!showGlossary ? Pico.plaster : Pico.deepForestGreen.opacity(0.5))
            }
            .buttonStyle(.plain)

            Button {
                withAnimation(.spring(response: 0.3)) { showGlossary = true }
                HapticService.selection()
            } label: {
                Text("Full Glossary (\(glossaryService.verbCount))")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(showGlossary ? Pico.deepForestGreen : Color.clear, in: .rect(cornerRadius: 12))
                    .foregroundStyle(showGlossary ? Pico.plaster : Pico.deepForestGreen.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(4)
        .background(Pico.cardSurface, in: .rect(cornerRadius: 14))
    }

    private var levelVerbsList: some View {
        LazyVStack(spacing: 0) {
            ForEach(filteredVerbs, id: \.infinitive) { verb in
                Button {
                    selectedVerb = verb
                    HapticService.selection()
                } label: {
                    verbRow(verb)
                }
                .buttonStyle(.plain)

                if verb.infinitive != filteredVerbs.last?.infinitive {
                    Divider()
                        .padding(.leading, 20)
                        .foregroundStyle(Pico.earthBrown.opacity(0.08))
                }
            }
        }
        .padding(.horizontal, Pico.spacingM)
        .background(
            RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                .fill(Pico.cardSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                        .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                )
        )
        .padding(.horizontal, Pico.spacingM)
    }

    private var glossaryList: some View {
        LazyVStack(spacing: 0) {
            ForEach(filteredGlossary) { gVerb in
                Button {
                    speechService.speak(gVerb.infinitive, dialect: dialect)
                    HapticService.selection()
                } label: {
                    glossaryRow(gVerb)
                }
                .buttonStyle(.plain)

                if gVerb.id != filteredGlossary.last?.id {
                    Divider()
                        .padding(.leading, 20)
                        .foregroundStyle(Pico.earthBrown.opacity(0.08))
                }
            }
        }
        .padding(.horizontal, Pico.spacingM)
        .background(
            RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                .fill(Pico.cardSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                        .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                )
        )
        .padding(.horizontal, Pico.spacingM)
    }

    private func glossaryRow(_ verb: GlossaryVerb) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(verb.infinitive)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.deepForestGreen)

                    if verb.irregular {
                        Text("IRR")
                            .font(.system(.caption2, design: .rounded, weight: .bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.1), in: .rect(cornerRadius: 4))
                    }
                }

                Text(verb.translation)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
            }

            Spacer()

            Image(systemName: "speaker.wave.2.fill")
                .font(.subheadline)
                .foregroundStyle(Pico.deepForestGreen.opacity(0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var filterRow: some View {
        HStack(spacing: 8) {
            filterChip("All", isActive: filterIrregular == nil) { filterIrregular = nil }
            filterChip("Regular", isActive: filterIrregular == false) { filterIrregular = false }
            filterChip("Irregular", isActive: filterIrregular == true) { filterIrregular = true }
            Spacer()
        }
    }

    private func filterChip(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isActive ? Pico.deepForestGreen.opacity(0.1) : Pico.cardSurface, in: Capsule())
                .overlay(Capsule().strokeBorder(isActive ? Pico.deepForestGreen.opacity(0.3) : .clear, lineWidth: 1.5))
                .foregroundStyle(isActive ? Pico.deepForestGreen : Pico.deepForestGreen.opacity(0.5))
        }
        .buttonStyle(.plain)
    }

    private func verbRow(_ verb: Verb) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(verb.infinitive)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.deepForestGreen)

                    if verb.irregular {
                        Text("IRR")
                            .font(.system(.caption2, design: .rounded, weight: .bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.1), in: .rect(cornerRadius: 4))
                    }
                }

                Text(verb.translation)
                    .font(.system(.subheadline, design: .rounded))
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
                    .background(Pico.deepForestGreen.opacity(0.06), in: Circle())
            }

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct VerbDetailSheet: View {
    let verb: Verb
    let dialect: Dialect
    @Environment(SpeechService.self) private var speechService
    @State private var selectedSpeed: SpeechService.Speed = .normal

    private var exampleSet: VerbExampleSet {
        VerbExampleData.examples(for: verb.infinitive)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    speedControl
                    conjugationSection
                    if !exampleSet.examples.isEmpty {
                        examplesSection
                    }
                    if !exampleSet.commonMistake.isEmpty {
                        commonMistakeSection
                    }
                }
                .padding(20)
                .padding(.bottom, 40)
            }
            .background(Pico.plaster.ignoresSafeArea())
            .navigationTitle(verb.infinitive)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verb.infinitive)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.deepForestGreen)
                    Text(verb.translation)
                        .font(.system(.title3, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                }

                Spacer()

                Button {
                    speechService.speak(verb.infinitive, dialect: dialect)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                        .foregroundStyle(Pico.plaster)
                        .frame(width: 56, height: 56)
                        .background(Pico.primaryGradient, in: Circle())
                        .shadow(color: Pico.deepForestGreen.opacity(0.2), radius: 8, y: 4)
                }
            }

            HStack(spacing: 8) {
                if verb.irregular {
                    Label("Irregular", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.orange.opacity(0.1), in: Capsule())
                }

                Text(verb.context)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Pico.cardSurface, in: Capsule())

                Spacer()
            }
        }
    }

    private var speedControl: some View {
        HStack(spacing: 8) {
            Text("Speed")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.5))

            Spacer()

            ForEach(SpeechService.Speed.allCases, id: \.self) { speed in
                Button {
                    selectedSpeed = speed
                    speechService.setSpeed(speed)
                    HapticService.selection()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: speed.icon)
                            .font(.caption2)
                        Text(speed.rawValue)
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        selectedSpeed == speed ? Pico.deepForestGreen.opacity(0.1) : Pico.cardSurface,
                        in: Capsule()
                    )
                    .foregroundStyle(selectedSpeed == speed ? Pico.deepForestGreen : Pico.deepForestGreen.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
        }
        .picoCard()
    }

    private var conjugationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conjugation")
                .font(.system(.headline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)

            let conjugations = verb.conjugations.forDialect(dialect)
            VStack(spacing: 0) {
                ForEach(Array(conjugations.sorted(by: { $0.key < $1.key }).enumerated()), id: \.element.key) { index, pair in
                    let pronoun = Pronoun(rawValue: pair.key)
                    HStack {
                        Text(pronoun?.displayName ?? pair.key)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                            .frame(width: 90, alignment: .trailing)

                        Text(pair.value)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.deepForestGreen)

                        Spacer()

                        Button {
                            speechService.speak(pair.value, dialect: dialect)
                        } label: {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.caption)
                                .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
                                .frame(width: 32, height: 32)
                                .background(Pico.deepForestGreen.opacity(0.06), in: Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < conjugations.count - 1 {
                        Divider()
                            .padding(.leading, 106)
                            .foregroundStyle(Pico.earthBrown.opacity(0.08))
                    }
                }
            }
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

    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Examples")
                .font(.system(.headline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)

            ForEach(exampleSet.examples) { example in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(example.portuguese)
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .foregroundStyle(Pico.deepForestGreen)
                            Text(example.english)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                        }

                        Spacer()

                        Button {
                            speechService.speak(example.portuguese, dialect: dialect)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.caption)
                                .foregroundStyle(Pico.deepForestGreen)
                                .frame(width: 32, height: 32)
                                .background(Pico.deepForestGreen.opacity(0.06), in: Circle())
                        }
                    }
                }
                .picoCard()
            }
        }
    }

    private var commonMistakeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                Text("Common Mistake")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.red)
            }

            Text(exampleSet.commonMistake)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Pico.deepForestGreen)

            Text(exampleSet.mistakeExplanation)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                .lineSpacing(2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.04), in: .rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.red.opacity(0.12), lineWidth: 1)
        )
    }
}
