import Foundation

nonisolated struct LevelProgress: Codable, Sendable {
    var completedVerbs: Set<String> = []
    var failedVerbs: Set<String> = []
    var bestScore: Int = 0
    var totalAttempts: Int = 0
    var correctAttempts: Int = 0
    var isCompleted: Bool = false
    var isCracked: Bool = false
    var lastAttemptDate: Date?
}

nonisolated struct FlashcardProgress: Codable, Sendable {
    var box: Int = 0
    var lastReviewed: Date?
    var nextReview: Date?
}

nonisolated enum GameMode: String, Codable, Sendable, CaseIterable {
    case zenTyping = "Zen Typing"
    case speedTap = "Speed Tap"

    var icon: String {
        switch self {
        case .zenTyping: "keyboard"
        case .speedTap: "hand.tap"
        }
    }
}
