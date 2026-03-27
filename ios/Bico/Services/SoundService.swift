import AVFoundation

@Observable
@MainActor
class SoundService {
    private var correctPlayer: AVAudioPlayer?
    private var incorrectPlayer: AVAudioPlayer?

    func playCorrect() {
        HapticService.success()
        playSystemSound(id: 1025)
    }

    func playIncorrect() {
        HapticService.error()
        playSystemSound(id: 1053)
    }

    private func playSystemSound(id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
}
