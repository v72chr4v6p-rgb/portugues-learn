import AVFoundation

@Observable
@MainActor
class SpeechService {
    var speechRate: Float = 0.4
    var isSpeaking: Bool = false

    private let synthesizer = AVSpeechSynthesizer()

    nonisolated enum Speed: String, CaseIterable, Sendable {
        case slow = "0.75x"
        case normal = "1x"
        case fast = "1.25x"

        var rate: Float {
            switch self {
            case .slow: 0.3
            case .normal: 0.4
            case .fast: 0.5
            }
        }

        var icon: String {
            switch self {
            case .slow: "tortoise.fill"
            case .normal: "hare.fill"
            case .fast: "bolt.fill"
            }
        }
    }

    func speak(_ text: String, dialect: Dialect) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: dialect == .brazilian ? "pt-BR" : "pt-PT")
        utterance.rate = speechRate
        utterance.pitchMultiplier = 1.0
        isSpeaking = true
        synthesizer.speak(utterance)
        Task {
            try? await Task.sleep(for: .milliseconds(Int(Double(text.count) * 120 / Double(speechRate))))
            isSpeaking = false
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    func setSpeed(_ speed: Speed) {
        speechRate = speed.rate
    }
}
