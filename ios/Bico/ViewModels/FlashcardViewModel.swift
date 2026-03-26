import SwiftUI
import AVFoundation

@Observable
@MainActor
class FlashcardViewModel {
    let verbDataService: VerbDataService
    let progressService: ProgressService
    let dialect: Dialect

    var cards: [FlashcardItem] = []
    var currentIndex: Int = 0
    var isFlipped: Bool = false
    var dragOffset: CGSize = .zero
    var masteredCount: Int = 0
    var studyAgainCount: Int = 0

    private let synthesizer = AVSpeechSynthesizer()

    struct FlashcardItem: Identifiable {
        let id = UUID()
        let verb: Verb
        let tense: String
    }

    init(verbDataService: VerbDataService, progressService: ProgressService, dialect: Dialect) {
        self.verbDataService = verbDataService
        self.progressService = progressService
        self.dialect = dialect
        buildCards()
    }

    func buildCards() {
        cards = verbDataService.levels.flatMap { level in
            level.verbs.map { FlashcardItem(verb: $0, tense: level.tense) }
        }.shuffled()
        currentIndex = 0
        masteredCount = 0
        studyAgainCount = 0
        isFlipped = false
    }

    var currentCard: FlashcardItem? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var isComplete: Bool {
        currentIndex >= cards.count
    }

    func flipCard() {
        isFlipped.toggle()
    }

    func swipeRight() {
        guard let card = currentCard else { return }
        progressService.updateFlashcard(verbKey: card.verb.infinitive, mastered: true)
        masteredCount += 1
        HapticService.success()
        advance()
    }

    func swipeLeft() {
        guard let card = currentCard else { return }
        progressService.updateFlashcard(verbKey: card.verb.infinitive, mastered: false)
        studyAgainCount += 1
        HapticService.lightTap()
        advance()
    }

    private func advance() {
        isFlipped = false
        dragOffset = .zero
        currentIndex += 1
    }

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: dialect == .brazilian ? "pt-BR" : "pt-PT")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }

    func reset() {
        buildCards()
    }
}
