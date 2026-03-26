import Foundation

nonisolated struct Level: Codable, Sendable, Identifiable, Hashable {
    let level: Int
    let tense: String
    let verbs: [Verb]

    var id: Int { level }

    var zone: ForestZone {
        switch level {
        case 1...12: .rootsAndGlade
        case 13...16: .theStream
        case 17...26: .deepWoods
        case 27...31: .theAscent
        case 32: .personalInfinitive
        case 33...40: .theClouds
        case 41...43: .theSummit
        default: .rootsAndGlade
        }
    }

    var isSpecial: Bool {
        level == 32 || level == 37
    }
}

nonisolated enum ForestZone: String, Sendable, CaseIterable {
    case rootsAndGlade = "Roots & Glade"
    case theStream = "The Stream"
    case deepWoods = "Deep Woods"
    case theAscent = "The Ascent"
    case personalInfinitive = "Personal Infinitive"
    case theClouds = "The Clouds"
    case theSummit = "The Summit"

    var levelRange: ClosedRange<Int> {
        switch self {
        case .rootsAndGlade: 1...12
        case .theStream: 13...16
        case .deepWoods: 17...26
        case .theAscent: 27...31
        case .personalInfinitive: 32...32
        case .theClouds: 33...40
        case .theSummit: 41...43
        }
    }

    var icon: String {
        switch self {
        case .rootsAndGlade: "leaf.fill"
        case .theStream: "water.waves"
        case .deepWoods: "tree.fill"
        case .theAscent: "mountain.2.fill"
        case .personalInfinitive: "sparkles"
        case .theClouds: "cloud.fill"
        case .theSummit: "flag.fill"
        }
    }
}
