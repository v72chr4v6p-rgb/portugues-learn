import Foundation

@Observable
@MainActor
class VerbGlossaryService {
    private(set) var allVerbs: [GlossaryVerb] = []
    private(set) var isLoaded: Bool = false

    init() {
        loadVerbs()
    }

    func loadVerbs() {
        allVerbs = Self.buildGlossary()
        isLoaded = true
    }

    func search(_ query: String) -> [GlossaryVerb] {
        guard !query.isEmpty else { return allVerbs }
        return allVerbs.filter {
            $0.infinitive.localizedStandardContains(query) ||
            $0.translation.localizedStandardContains(query)
        }
    }

    var verbCount: Int { allVerbs.count }

    static func v(_ inf: String, _ trans: String, _ irr: Bool = false) -> GlossaryVerb {
        GlossaryVerb(infinitive: inf, translation: trans, irregular: irr)
    }

    static func buildGlossary() -> [GlossaryVerb] {
        var result: [GlossaryVerb] = []
        result.append(contentsOf: glossaryAtoB())
        result.append(contentsOf: glossaryCtoD())
        result.append(contentsOf: glossaryEtoI())
        result.append(contentsOf: glossaryJtoR())
        result.append(contentsOf: glossaryStoZ())
        result.append(contentsOf: glossaryReflexive())
        result.append(contentsOf: glossaryExtra())
        return result.sorted { $0.infinitive.localizedCompare($1.infinitive) == .orderedAscending }
    }
}

nonisolated struct GlossaryVerb: Codable, Sendable, Identifiable, Hashable {
    var id: String { infinitive.lowercased() }
    let infinitive: String
    let translation: String
    let irregular: Bool
}
