import Foundation

struct QuizConfig: Identifiable {
    let id = UUID()
    let level: Level
    let pronouns: Set<Pronoun>
    let gameMode: GameMode
    let useTimer: Bool
}
