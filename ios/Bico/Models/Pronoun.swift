import Foundation

nonisolated enum Pronoun: String, Codable, Sendable, CaseIterable, Identifiable {
    case eu
    case tu
    case voce
    case ele
    case nos
    case vos
    case voces
    case eles

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .eu: "Eu"
        case .tu: "Tu"
        case .voce: "Você"
        case .ele: "Ele/Ela"
        case .nos: "Nós"
        case .vos: "Vós"
        case .voces: "Vocês"
        case .eles: "Eles/Elas"
        }
    }

    var shortName: String {
        switch self {
        case .eu: "Eu"
        case .tu: "Tu"
        case .voce: "Você"
        case .ele: "Ele"
        case .nos: "Nós"
        case .vos: "Vós"
        case .voces: "Vocês"
        case .eles: "Eles"
        }
    }
}
