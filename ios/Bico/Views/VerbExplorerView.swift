import SwiftUI

struct VerbExplorerView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(SpeechService.self) private var speechService
    @State private var searchText: String = ""
    @State private var selectedVerb: Verb?
    @State private var filterIrregular: Bool? = nil

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

    var body: some View {
        NavigationStack {
            List {
                filterRow

                ForEach(filteredVerbs, id: \.infinitive) { verb in
                    Button {
                        selectedVerb = verb
                        HapticService.selection()
                    } label: {
                        verbRow(verb)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search verbs...")
            .navigationTitle("Verb Explorer")
            .sheet(item: $selectedVerb) { verb in
                VerbDetailSheet(verb: verb, dialect: dialect)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .overlay {
                if filteredVerbs.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip("All", isActive: filterIrregular == nil) { filterIrregular = nil }
                filterChip("Regular", isActive: filterIrregular == false) { filterIrregular = false }
                filterChip("Irregular", isActive: filterIrregular == true) { filterIrregular = true }
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }

    private func filterChip(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isActive ? Theme.tangerine.opacity(0.15) : Color(.tertiarySystemBackground), in: Capsule())
                .overlay(Capsule().strokeBorder(isActive ? Theme.tangerine : .clear, lineWidth: 1.5))
                .foregroundStyle(isActive ? Theme.tangerine : .primary)
        }
        .buttonStyle(.plain)
    }

    private func verbRow(_ verb: Verb) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(verb.infinitive)
                        .font(.headline)

                    if verb.irregular {
                        Text("IRR")
                            .font(.system(.caption2, weight: .bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange.opacity(0.12), in: .rect(cornerRadius: 4))
                    }
                }

                Text(verb.translation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                speechService.speak(verb.infinitive, dialect: dialect)
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.subheadline)
                    .foregroundStyle(Theme.tangerine)
                    .frame(width: 36, height: 36)
                    .background(Theme.tangerine.opacity(0.1), in: Circle())
            }

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
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
                    Text(verb.translation)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    speechService.speak(verb.infinitive, dialect: dialect)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Theme.tangerineGradient, in: Circle())
                        .glowButton()
                }
            }

            HStack(spacing: 8) {
                if verb.irregular {
                    Label("Irregular", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.orange.opacity(0.1), in: Capsule())
                }

                Text(verb.context)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(.tertiarySystemBackground), in: Capsule())

                Spacer()
            }
        }
    }

    private var speedControl: some View {
        HStack(spacing: 8) {
            Text("Speed")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

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
                            .font(.caption.weight(.semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        selectedSpeed == speed ? Theme.tangerine.opacity(0.15) : Color(.tertiarySystemBackground),
                        in: Capsule()
                    )
                    .foregroundStyle(selectedSpeed == speed ? Theme.tangerine : .primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
    }

    private var conjugationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conjugation")
                .font(.headline)

            let conjugations = verb.conjugations.forDialect(dialect)
            VStack(spacing: 0) {
                ForEach(Array(conjugations.sorted(by: { $0.key < $1.key }).enumerated()), id: \.element.key) { index, pair in
                    let pronoun = Pronoun(rawValue: pair.key)
                    HStack {
                        Text(pronoun?.displayName ?? pair.key)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(width: 90, alignment: .trailing)

                        Text(pair.value)
                            .font(.body.weight(.semibold))

                        Spacer()

                        Button {
                            speechService.speak(pair.value, dialect: dialect)
                        } label: {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.tangerine)
                                .frame(width: 32, height: 32)
                                .background(Theme.tangerine.opacity(0.08), in: Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < conjugations.count - 1 {
                        Divider().padding(.leading, 106)
                    }
                }
            }
            .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 14))
        }
    }

    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Examples")
                .font(.headline)

            ForEach(exampleSet.examples) { example in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(example.portuguese)
                                .font(.body.weight(.medium))
                            Text(example.english)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            speechService.speak(example.portuguese, dialect: dialect)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.tangerine)
                                .frame(width: 32, height: 32)
                                .background(Theme.tangerine.opacity(0.08), in: Circle())
                        }
                    }
                }
                .padding(14)
                .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 12))
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
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.red)
            }

            Text(exampleSet.commonMistake)
                .font(.subheadline.weight(.medium))

            Text(exampleSet.mistakeExplanation)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.06), in: .rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.red.opacity(0.15), lineWidth: 1)
        )
    }
}
