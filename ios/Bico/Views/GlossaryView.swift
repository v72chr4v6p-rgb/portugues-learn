import SwiftUI
import AVFoundation

struct GlossaryView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @State private var searchText: String = ""
    @State private var expandedVerbId: String?
    private let synthesizer = AVSpeechSynthesizer()

    var filteredVerbs: [Verb] {
        let allVerbs = uniqueVerbs
        if searchText.isEmpty { return allVerbs }
        return allVerbs.filter {
            $0.infinitive.localizedStandardContains(searchText) ||
            $0.translation.localizedStandardContains(searchText)
        }
    }

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

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVerbs, id: \.infinitive) { verb in
                    VerbGlossaryRow(
                        verb: verb,
                        dialect: dialect,
                        isExpanded: expandedVerbId == verb.infinitive,
                        onTap: {
                            withAnimation(.spring(response: 0.35)) {
                                expandedVerbId = expandedVerbId == verb.infinitive ? nil : verb.infinitive
                            }
                            HapticService.selection()
                        },
                        onSpeak: { speak(verb.infinitive) }
                    )
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search verbs...")
            .navigationTitle("Glossary")
            .overlay {
                if filteredVerbs.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
    }

    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: dialect == .brazilian ? "pt-BR" : "pt-PT")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

struct VerbGlossaryRow: View {
    let verb: Verb
    let dialect: Dialect
    let isExpanded: Bool
    let onTap: () -> Void
    let onSpeak: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text(verb.infinitive)
                                .font(.headline)
                                .foregroundStyle(.primary)

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

                    Button(action: onSpeak) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.subheadline)
                            .foregroundStyle(Theme.tangerine)
                    }

                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }

                if isExpanded {
                    conjugationGrid
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var conjugationGrid: some View {
        VStack(spacing: 6) {
            Divider()

            Text(verb.context)
                .font(.caption)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .leading)

            let conjugations = verb.conjugations.forDialect(dialect)
            ForEach(Array(conjugations.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                HStack {
                    Text(Pronoun(rawValue: key)?.displayName ?? key)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 70, alignment: .trailing)
                    Text(value)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                }
            }
        }
        .padding(.top, 4)
    }
}
