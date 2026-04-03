import AVFoundation

@Observable
@MainActor
class SoundService {
    private var audioSession: AVAudioSession { AVAudioSession.sharedInstance() }

    init() {
        configureAudioSession()
    }

    func playCorrect() {
        HapticService.success()
        AudioServicesPlaySystemSound(1025)
    }

    func playIncorrect() {
        HapticService.error()
        AudioServicesPlaySystemSound(1053)
    }

    private func configureAudioSession() {
        do {
            try audioSession.setCategory(.ambient, mode: .default, options: .mixWithOthers)
            try audioSession.setActive(true)
        } catch {
        }
    }
}
