import Foundation

nonisolated enum Dialect: String, Codable, Sendable, CaseIterable {
    case brazilian = "br"
    case european = "pt"

    var displayName: String {
        switch self {
        case .brazilian: "Brasileiro"
        case .european: "Europeu"
        }
    }

    var flag: String {
        switch self {
        case .brazilian: "🇧🇷"
        case .european: "🇵🇹"
        }
    }

    var subtitle: String {
        switch self {
        case .brazilian: "Brazilian Portuguese"
        case .european: "European Portuguese"
        }
    }

    var description: String {
        switch self {
        case .brazilian: "Uses gerunds (estou falando), Vocês, and A gente"
        case .european: "Uses a + infinitive (estou a falar), Tu and Vós forms"
        }
    }

    var pronouns: [Pronoun] {
        switch self {
        case .brazilian: [.eu, .voce, .nos, .voces, .eles]
        case .european: [.eu, .tu, .ele, .nos, .vos, .eles]
        }
    }
}
