import Foundation

@Observable
@MainActor
class ProgressService {
    var levelProgress: [Int: LevelProgress] = [:]
    var flashcardProgress: [String: FlashcardProgress] = [:]
    var totalCorrect: Int = 0
    var totalAttempts: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0

    private let progressKey = "bico_level_progress"
    private let flashcardKey = "bico_flashcard_progress"
    private let statsKey = "bico_stats"

    init() {
        load()
    }

    func progress(for level: Int) -> LevelProgress {
        levelProgress[level] ?? LevelProgress()
    }

    func isLevelUnlocked(_ level: Int) -> Bool {
        if level <= 1 { return true }
        return levelProgress[level - 1]?.isCompleted == true
    }

    func isLevelCompleted(_ level: Int) -> Bool {
        levelProgress[level]?.isCompleted == true
    }

    func isLevelCracked(_ level: Int) -> Bool {
        levelProgress[level]?.isCracked == true
    }

    func jumpToLevel(_ level: Int) {
        for i in 1..<level {
            if levelProgress[i]?.isCompleted != true {
                var prog = levelProgress[i] ?? LevelProgress()
                prog.isCompleted = true
                prog.isCracked = false
                prog.failedVerbs.removeAll()
                levelProgress[i] = prog
            }
        }
        save()
    }

    func recordAnswer(level: Int, verb: String, correct: Bool) {
        var prog = levelProgress[level] ?? LevelProgress()
        prog.totalAttempts += 1
        totalAttempts += 1

        if correct {
            prog.correctAttempts += 1
            prog.completedVerbs.insert(verb)
            totalCorrect += 1
            currentStreak += 1
            if currentStreak > bestStreak { bestStreak = currentStreak }
        } else {
            prog.failedVerbs.insert(verb)
            prog.isCracked = true
            currentStreak = 0
        }
        prog.lastAttemptDate = Date()
        levelProgress[level] = prog
        save()
    }

    func completeLevel(_ level: Int, score: Int) {
        var prog = levelProgress[level] ?? LevelProgress()
        prog.isCompleted = true
        if score > prog.bestScore { prog.bestScore = score }
        prog.failedVerbs.removeAll()
        prog.isCracked = false
        levelProgress[level] = prog
        save()
    }

    func repairRock(level: Int) {
        var prog = levelProgress[level] ?? LevelProgress()
        prog.isCracked = false
        prog.failedVerbs.removeAll()
        levelProgress[level] = prog
        save()
    }

    func updateFlashcard(verbKey: String, mastered: Bool) {
        var prog = flashcardProgress[verbKey] ?? FlashcardProgress()
        prog.lastReviewed = Date()

        if mastered {
            prog.box = min(prog.box + 1, 4)
        } else {
            prog.box = max(prog.box - 1, 0)
        }

        let intervals: [TimeInterval] = [0, 86400, 86400 * 3, 86400 * 7, 86400 * 14]
        prog.nextReview = Date().addingTimeInterval(intervals[prog.box])
        flashcardProgress[verbKey] = prog
        save()
    }

    var completedLevelCount: Int {
        levelProgress.values.filter(\.isCompleted).count
    }

    var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalAttempts)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(levelProgress) {
            UserDefaults.standard.set(data, forKey: progressKey)
        }
        if let data = try? JSONEncoder().encode(flashcardProgress) {
            UserDefaults.standard.set(data, forKey: flashcardKey)
        }
        let stats: [String: Int] = [
            "totalCorrect": totalCorrect,
            "totalAttempts": totalAttempts,
            "currentStreak": currentStreak,
            "bestStreak": bestStreak
        ]
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: statsKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([Int: LevelProgress].self, from: data) {
            levelProgress = decoded
        }
        if let data = UserDefaults.standard.data(forKey: flashcardKey),
           let decoded = try? JSONDecoder().decode([String: FlashcardProgress].self, from: data) {
            flashcardProgress = decoded
        }
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            totalCorrect = decoded["totalCorrect"] ?? 0
            totalAttempts = decoded["totalAttempts"] ?? 0
            currentStreak = decoded["currentStreak"] ?? 0
            bestStreak = decoded["bestStreak"] ?? 0
        }
    }
}
