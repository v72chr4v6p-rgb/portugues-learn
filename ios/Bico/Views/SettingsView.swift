import SwiftUI

struct SettingsView: View {
    @Environment(SpeechService.self) private var speechService
    @Environment(EngagementService.self) private var engagementService
    @AppStorage("selectedDialect") private var dialectRaw: String = ""
    @State private var selectedSpeed: SpeechService.Speed = .normal
    @State private var showResetAlert: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section("Audio") {
                    HStack {
                        Label("Speech Speed", systemImage: "speaker.wave.2.fill")
                        Spacer()
                        Picker("Speed", selection: $selectedSpeed) {
                            ForEach(SpeechService.Speed.allCases, id: \.self) { speed in
                                Text(speed.rawValue).tag(speed)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 180)
                    }
                    .onChange(of: selectedSpeed) { _, newValue in
                        speechService.setSpeed(newValue)
                    }
                }

                Section("Daily Goal") {
                    @Bindable var engagement = engagementService
                    Picker("XP Goal", selection: $engagement.dailyXPGoal) {
                        Text("Casual (30 XP)").tag(30)
                        Text("Regular (50 XP)").tag(50)
                        Text("Serious (100 XP)").tag(100)
                        Text("Intense (150 XP)").tag(150)
                    }
                }

                Section("Dialect") {
                    if let dialect = Dialect(rawValue: dialectRaw) {
                        HStack {
                            Text(dialect.flag)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(dialect.displayName)
                                    .font(.subheadline.weight(.semibold))
                                Text(dialect.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }

                        Button("Switch Dialect") {
                            dialectRaw = ""
                        }
                        .foregroundStyle(Theme.tangerine)
                    }
                }

                Section("Stats") {
                    LabeledContent("Total XP", value: "\(engagementService.xp)")
                    LabeledContent("User Level", value: "\(engagementService.userLevel)")
                    LabeledContent("Best Streak", value: "\(engagementService.bestDayStreak) days")
                    LabeledContent("Badges Earned", value: "\(engagementService.badges.count)")
                }

                Section {
                    Button("Reset All Progress", role: .destructive) {
                        showResetAlert = true
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Progress?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
                }
            } message: {
                Text("This will permanently delete all your learning progress, XP, and streaks.")
            }
        }
    }
}
