import Foundation

@Observable
@MainActor
class VerbDataService {
    private(set) var levels: [Level] = []
    private(set) var isLoaded: Bool = false

    init() {
        loadLevels()
    }

    func loadLevels() {
        levels = Self.buildAllLevels()
        isLoaded = true
    }

    func level(for number: Int) -> Level? {
        levels.first { $0.level == number }
    }

    func verbs(forLevel number: Int) -> [Verb] {
        level(for: number)?.verbs ?? []
    }

    func allSortedLevels() -> [Level] {
        levels.sorted { $0.level < $1.level }
    }

    private static func buildAllLevels() -> [Level] {
        var result: [Level] = []
        result.append(contentsOf: buildLevels1to4())
        result.append(contentsOf: buildLevels5to8())
        result.append(contentsOf: buildLevels9to12())
        result.append(contentsOf: buildLevels13to16())
        result.append(contentsOf: buildLevels17to22())
        result.append(contentsOf: buildLevels23to26())
        result.append(contentsOf: buildLevels27to32())
        result.append(contentsOf: buildLevels33to43())
        return result
    }
}
