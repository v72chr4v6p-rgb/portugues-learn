import Foundation

nonisolated struct Verb: Codable, Sendable, Identifiable, Hashable {
    var id: String { infinitive.lowercased() + "-" + (level?.description ?? "") }
    let infinitive: String
    let translation: String
    let irregular: Bool
    let context: String
    let conjugations: ConjugationSet
    var level: Int?

    nonisolated struct ConjugationSet: Codable, Sendable, Hashable {
        let br: [String: String]
        let pt: [String: String]

        func forDialect(_ dialect: Dialect) -> [String: String] {
            switch dialect {
            case .brazilian: br
            case .european: pt
            }
        }
    }

    func conjugation(for pronoun: Pronoun, dialect: Dialect) -> String? {
        conjugations.forDialect(dialect)[pronoun.rawValue]
    }
}
