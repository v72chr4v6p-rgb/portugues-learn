import SwiftUI

struct MainTabView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                HomeView(dialect: dialect)
            }

            Tab("Path", systemImage: "map.fill", value: 1) {
                ForestPathView(dialect: dialect)
            }

            Tab("Verbs", systemImage: "textformat.abc", value: 2) {
                VerbExplorerView(dialect: dialect)
            }

            Tab("Practice", systemImage: "brain.head.profile.fill", value: 3) {
                PracticeView(dialect: dialect)
            }

            Tab("Settings", systemImage: "gearshape.fill", value: 4) {
                SettingsView()
            }
        }
        .tint(Pico.deepForestGreen)
    }
}
