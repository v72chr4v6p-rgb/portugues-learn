import SwiftUI

@main
struct BicoApp: App {
    @State private var verbDataService = VerbDataService()
    @State private var progressService = ProgressService()
    @State private var engagementService = EngagementService()
    @State private var speechService = SpeechService()
    @AppStorage("selectedDialect") private var dialectRaw: String = ""

    var body: some Scene {
        WindowGroup {
            if let dialect = Dialect(rawValue: dialectRaw) {
                MainTabView(dialect: dialect)
                    .environment(verbDataService)
                    .environment(progressService)
                    .environment(engagementService)
                    .environment(speechService)
                    .tint(Theme.tangerine)
            } else {
                OnboardingView(onDialectSelected: { dialect in
                    dialectRaw = dialect.rawValue
                })
                .tint(Theme.tangerine)
            }
        }
    }
}
