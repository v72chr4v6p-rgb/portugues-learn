import SwiftUI

struct MainTabView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Jungle", systemImage: "tree.fill", value: 0) {
                ForestPathView(dialect: dialect)
            }

            Tab("Practice", systemImage: "brain.head.profile.fill", value: 1) {
                PracticeView(dialect: dialect)
            }

            Tab("Flashcards", systemImage: "rectangle.stack.fill", value: 2) {
                FlashcardView(dialect: dialect)
            }

            Tab("Stats", systemImage: "chart.bar.fill", value: 3) {
                StatsView()
            }

            Tab("Glossary", systemImage: "book.fill", value: 4) {
                GlossaryView(dialect: dialect)
            }
        }
        .tint(Theme.tangerine)
    }
}
