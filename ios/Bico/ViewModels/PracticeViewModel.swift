import SwiftUI
import AVFoundation
import AudioToolbox

@Observable
@MainActor
class PracticeViewModel {
    let verbDataService: VerbDataService
    let progressService: ProgressService
    let dialect: Dialect

    var selectedTense: String = "All"
    var practiceItems: [PracticeItem] = []
    var currentIndex: Int = 0
    var userAnswer: String = ""
    var showingResult: Bool = false
    var isCorrect: Bool?
    var correctAnswer: String = ""
    var score: Int = 0
    var totalAnswered: Int = 0
    var totalCorrect: Int = 0
    var isSessionActive: Bool = false
    var practiceMode: PracticeMode = .fillBlank
    var multipleChoiceOptions: [String] = []

    private let synthesizer = AVSpeechSynthesizer()

    struct PracticeItem: Identifiable {
        let id = UUID()
        let verb: Verb
        let pronoun: Pronoun
        let tense: String
        let answer: String
    }

    var availableTenses: [String] {
        var tenses = Set<String>()
        for level in verbDataService.levels {
            tenses.insert(level.tense)
        }
        return ["All"] + tenses.sorted()
    }

    init(verbDataService: VerbDataService, progressService: ProgressService, dialect: Dialect) {
        self.verbDataService = verbDataService
        self.progressService = progressService
        self.dialect = dialect
    }

    func startSession() {
        var items: [PracticeItem] = []
        let levels = selectedTense == "All"
            ? verbDataService.levels
            : verbDataService.levels.filter { $0.tense == selectedTense }

        for level in levels {
            for verb in level.verbs {
                let conjugations = verb.conjugations.forDialect(dialect)
                for (key, value) in conjugations {
                    guard value != "—", let pronoun = Pronoun(rawValue: key) else { continue }
                    items.append(PracticeItem(
                        verb: verb,
                        pronoun: pronoun,
                        tense: level.tense,
                        answer: value
                    ))
                }
            }
        }

        practiceItems = items.shuffled().prefix(20).map { $0 }
        currentIndex = 0
        score = 0
        totalAnswered = 0
        totalCorrect = 0
        userAnswer = ""
        showingResult = false
        isCorrect = nil
        isSessionActive = true

        if !practiceItems.isEmpty {
            loadQuestion()
        }
    }

    private func loadQuestion() {
        guard currentIndex < practiceItems.count else { return }
        let item = practiceItems[currentIndex]
        correctAnswer = item.answer
        userAnswer = ""
        showingResult = false
        isCorrect = nil

        if practiceMode == .multipleChoice {
            generateOptions()
        }
    }

    private func generateOptions() {
        var options = Set<String>()
        options.insert(correctAnswer)

        if let item = currentItem {
            let sameVerbConjugations = item.verb.conjugations.forDialect(dialect)
                .values
                .filter { $0 != "\u{2014}" && $0.lowercased() != correctAnswer.lowercased() }

            for conj in sameVerbConjugations.shuffled() {
                if options.count >= 4 { break }
                options.insert(conj)
            }
        }

        if options.count < 4 {
            let otherAnswers = practiceItems
                .filter { $0.verb.infinitive != currentItem?.verb.infinitive }
                .map(\.answer)
                .filter { !options.contains($0) }

            for answer in otherAnswers.shuffled() {
                if options.count >= 4 { break }
                options.insert(answer)
            }
        }

        multipleChoiceOptions = Array(options).shuffled()
    }

    var currentItem: PracticeItem? {
        guard currentIndex < practiceItems.count else { return nil }
        return practiceItems[currentIndex]
    }

    var isComplete: Bool {
        isSessionActive && currentIndex >= practiceItems.count
    }

    var progress: Double {
        guard !practiceItems.isEmpty else { return 0 }
        return Double(currentIndex) / Double(practiceItems.count)
    }

    func submitAnswer() {
        guard currentIndex < practiceItems.count else { return }
        let trimmed = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = correctAnswer.lowercased()
        isCorrect = trimmed == correct
        showingResult = true
        totalAnswered += 1

        if isCorrect == true {
            score += 10
            totalCorrect += 1
            HapticService.success()
            AudioServicesPlaySystemSound(1025)
        } else {
            HapticService.error()
            AudioServicesPlaySystemSound(1053)
        }
    }

    func selectOption(_ option: String) {
        userAnswer = option
        submitAnswer()
    }

    func nextQuestion() {
        currentIndex += 1
        if currentIndex < practiceItems.count {
            loadQuestion()
        }
    }

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: dialect == .brazilian ? "pt-BR" : "pt-PT")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }

    func resetSession() {
        isSessionActive = false
        practiceItems = []
        currentIndex = 0
    }
}

nonisolated enum PracticeMode: String, CaseIterable, Sendable {
    case fillBlank = "Fill in the Blank"
    case multipleChoice = "Multiple Choice"

    var icon: String {
        switch self {
        case .fillBlank: "keyboard"
        case .multipleChoice: "list.bullet"
        }
    }
}
