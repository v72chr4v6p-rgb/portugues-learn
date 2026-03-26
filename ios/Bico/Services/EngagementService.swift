import Foundation

@Observable
@MainActor
class EngagementService {
    var xp: Int = 0
    var dailyXPGoal: Int = 50
    var todayXP: Int = 0
    var dayStreak: Int = 0
    var bestDayStreak: Int = 0
    var streakFreezes: Int = 1
    var lastSessionDate: Date?
    var sessionsToday: Int = 0
    var verbsLearnedToday: Int = 0
    var badges: Set<String> = []

    private let storageKey = "bico_engagement"

    init() {
        load()
        checkDayRollover()
    }

    var userLevel: Int {
        xpToLevel(xp)
    }

    var xpForCurrentLevel: Int {
        let currentLevelXP = levelToXP(userLevel)
        return xp - currentLevelXP
    }

    var xpForNextLevel: Int {
        levelToXP(userLevel + 1) - levelToXP(userLevel)
    }

    var levelProgress: Double {
        guard xpForNextLevel > 0 else { return 0 }
        return Double(xpForCurrentLevel) / Double(xpForNextLevel)
    }

    var dailyProgress: Double {
        guard dailyXPGoal > 0 else { return 0 }
        return min(1.0, Double(todayXP) / Double(dailyXPGoal))
    }

    var dailyGoalMet: Bool {
        todayXP >= dailyXPGoal
    }

    func awardXP(_ amount: Int, source: String) {
        xp += amount
        todayXP += amount
        checkBadges(source: source)
        save()
    }

    func recordSession() {
        sessionsToday += 1
        let today = Calendar.current.startOfDay(for: Date())

        if let last = lastSessionDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let dayDiff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if dayDiff == 1 {
                dayStreak += 1
            } else if dayDiff > 1 {
                if streakFreezes > 0 && dayDiff == 2 {
                    streakFreezes -= 1
                    dayStreak += 1
                } else {
                    dayStreak = 1
                }
            }
        } else {
            dayStreak = 1
        }

        if dayStreak > bestDayStreak {
            bestDayStreak = dayStreak
        }

        lastSessionDate = Date()
        save()
    }

    func recordVerbLearned() {
        verbsLearnedToday += 1
        save()
    }

    private func checkDayRollover() {
        guard let last = lastSessionDate else { return }
        let today = Calendar.current.startOfDay(for: Date())
        let lastDay = Calendar.current.startOfDay(for: last)
        if today != lastDay {
            todayXP = 0
            sessionsToday = 0
            verbsLearnedToday = 0
        }
    }

    private func checkBadges(source: String) {
        if xp >= 100 { badges.insert("first_100_xp") }
        if xp >= 500 { badges.insert("xp_500") }
        if xp >= 1000 { badges.insert("xp_1000") }
        if dayStreak >= 3 { badges.insert("streak_3") }
        if dayStreak >= 7 { badges.insert("streak_7") }
        if dayStreak >= 30 { badges.insert("streak_30") }
        if sessionsToday >= 3 { badges.insert("dedicated_learner") }
    }

    private func xpToLevel(_ xp: Int) -> Int {
        var level = 1
        var threshold = 100
        var accumulated = 0
        while accumulated + threshold <= xp {
            accumulated += threshold
            level += 1
            threshold = 100 + (level - 1) * 25
        }
        return level
    }

    private func levelToXP(_ level: Int) -> Int {
        var accumulated = 0
        for l in 1..<level {
            accumulated += 100 + (l - 1) * 25
        }
        return accumulated
    }

    nonisolated private struct StorageData: Codable, Sendable {
        var xp: Int
        var dailyXPGoal: Int
        var todayXP: Int
        var dayStreak: Int
        var bestDayStreak: Int
        var streakFreezes: Int
        var lastSessionDate: Date?
        var sessionsToday: Int
        var verbsLearnedToday: Int
        var badges: [String]
    }

    private func save() {
        let data = StorageData(
            xp: xp,
            dailyXPGoal: dailyXPGoal,
            todayXP: todayXP,
            dayStreak: dayStreak,
            bestDayStreak: bestDayStreak,
            streakFreezes: streakFreezes,
            lastSessionDate: lastSessionDate,
            sessionsToday: sessionsToday,
            verbsLearnedToday: verbsLearnedToday,
            badges: Array(badges)
        )
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(StorageData.self, from: data) else { return }
        xp = decoded.xp
        dailyXPGoal = decoded.dailyXPGoal
        todayXP = decoded.todayXP
        dayStreak = decoded.dayStreak
        bestDayStreak = decoded.bestDayStreak
        streakFreezes = decoded.streakFreezes
        lastSessionDate = decoded.lastSessionDate
        sessionsToday = decoded.sessionsToday
        verbsLearnedToday = decoded.verbsLearnedToday
        badges = Set(decoded.badges)
    }
}
