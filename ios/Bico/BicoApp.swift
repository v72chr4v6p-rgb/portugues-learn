import SwiftUI

@main
struct BicoApp: App {
    @State private var verbDataService = VerbDataService()
    @State private var progressService = ProgressService()
    @State private var engagementService = EngagementService()
    @State private var speechService = SpeechService()
    @State private var soundService = SoundService()
    @State private var verbGlossaryService = VerbGlossaryService()
    @AppStorage("selectedDialect") private var dialectRaw: String = ""
    @AppStorage("appearanceMode") private var appearanceModeRaw: String = AppearanceMode.system.rawValue

    private var preferredScheme: ColorScheme? {
        (AppearanceMode(rawValue: appearanceModeRaw) ?? .system).colorScheme
    }

    var body: some Scene {
        WindowGroup {
            if let dialect = Dialect(rawValue: dialectRaw) {
                MainTabView(dialect: dialect)
                    .environment(verbDataService)
                    .environment(progressService)
                    .environment(engagementService)
                    .environment(speechService)
                    .environment(soundService)
                    .environment(verbGlossaryService)
                    .tint(Pico.deepForestGreen)
                    .preferredColorScheme(preferredScheme)
            } else {
                OnboardingView(onDialectSelected: { dialect in
                    dialectRaw = dialect.rawValue
                })
                .tint(Pico.deepForestGreen)
                .preferredColorScheme(preferredScheme)
            }
        }
    }
}
