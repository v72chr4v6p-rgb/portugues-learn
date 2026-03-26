import SwiftUI
import AVFoundation

@Observable
@MainActor
class QuizViewModel {
    var level: Level
    let dialect: Dialect
    var selectedPronouns: Set<Pronoun>
    var gameMode: GameMode
    var useTimer: Bool

    var currentVerbIndex: Int = 0
    var currentPronoun: Pronoun = .eu
    var userAnswer: String = ""
    var isCorrect: Bool?
    var correctAnswer: String = ""
    var score: Int = 0
    var questionsAnswered: Int = 0
    var totalQuestions: Int = 0
    var isComplete: Bool = false
    var showingResult: Bool = false
    var timeRemaining: Int = 30
    var multipleChoiceOptions: [String] = []
    var shakeCount: Double = 0

    private var quizItems: [(Verb, Pronoun)] = []
    private var timerTask: Task<Void, Never>?
    private let synthesizer = AVSpeechSynthesizer()

    init(level: Level, dialect: Dialect, selectedPronouns pronouns: Set<Pronoun>, gameMode: GameMode, useTimer: Bool) {
        self.level = level
        self.dialect = dialect
        self.selectedPronouns = pronouns
        self.gameMode = gameMode
        self.useTimer = useTimer
        buildQuizItems()
    }

    private func buildQuizItems() {
        var items: [(Verb, Pronoun)] = []
        for verb in level.verbs {
            for pronoun in selectedPronouns {
                if verb.conjugation(for: pronoun, dialect: dialect) != nil {
                    items.append((verb, pronoun))
                }
            }
        }
        quizItems = items.shuffled()
        totalQuestions = quizItems.count
        if !quizItems.isEmpty {
            loadCurrentQuestion()
        }
    }

    private func loadCurrentQuestion() {
        guard currentVerbIndex < quizItems.count else {
            isComplete = true
            timerTask?.cancel()
            return
        }
        let (verb, pronoun) = quizItems[currentVerbIndex]
        currentPronoun = pronoun
        userAnswer = ""
        isCorrect = nil
        showingResult = false
        correctAnswer = verb.conjugation(for: pronoun, dialect: dialect) ?? ""

        if gameMode == .speedTap {
            generateMultipleChoiceOptions()
        }

        if useTimer {
            timeRemaining = 30
            startTimer()
        }
    }

    private func generateMultipleChoiceOptions() {
        var options = Set<String>()
        options.insert(correctAnswer)

        let allConjugations = level.verbs.flatMap { verb in
            selectedPronouns.compactMap { verb.conjugation(for: $0, dialect: dialect) }
        }

        while options.count < min(4, allConjugations.count + 1) {
            if let random = allConjugations.randomElement() {
                options.insert(random)
            } else {
                break
            }
        }
        multipleChoiceOptions = Array(options).shuffled()
    }

    var currentVerb: Verb? {
        guard currentVerbIndex < quizItems.count else { return nil }
        return quizItems[currentVerbIndex].0
    }

    func submitAnswer() {
        guard currentVerbIndex < quizItems.count else { return }
        let trimmed = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = correctAnswer.lowercased()
        isCorrect = trimmed == correct
        showingResult = true
        questionsAnswered += 1

        if isCorrect == true {
            score += useTimer ? max(10, timeRemaining) : 10
            HapticService.success()
        } else {
            HapticService.error()
            withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                shakeCount += 1
            }
        }
        timerTask?.cancel()
    }

    func selectMultipleChoice(_ answer: String) {
        userAnswer = answer
        submitAnswer()
    }

    func nextQuestion() {
        currentVerbIndex += 1
        loadCurrentQuestion()
    }

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: dialect == .brazilian ? "pt-BR" : "pt-PT")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }

    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task {
            while timeRemaining > 0 && !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled {
                    timeRemaining -= 1
                }
            }
            if timeRemaining <= 0 && !showingResult {
                submitAnswer()
            }
        }
    }

    nonisolated deinit {
    }
}
