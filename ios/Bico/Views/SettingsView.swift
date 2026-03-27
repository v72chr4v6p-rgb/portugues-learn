import SwiftUI

struct SettingsView: View {
    @Environment(SpeechService.self) private var speechService
    @Environment(EngagementService.self) private var engagementService
    @AppStorage("selectedDialect") private var dialectRaw: String = ""
    @State private var selectedSpeed: SpeechService.Speed = .normal
    @State private var showResetAlert: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Pico.spacingL) {
                    audioSection
                    dailyGoalSection
                    dialectSection
                    statsSection
                    resetSection
                }
                .padding(.horizontal, Pico.spacingXL)
                .padding(.vertical, Pico.spacingL)
            }
            .background(Pico.plaster.ignoresSafeArea())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
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

    private var audioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Audio", icon: "speaker.wave.2.fill")

            HStack {
                Text("Speech Speed")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(Pico.darkText)
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
            .picoCard()
        }
    }

    private var dailyGoalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Daily Goal", icon: "target")

            VStack(spacing: 12) {
                @Bindable var engagement = engagementService
                ForEach([(30, "Casual"), (50, "Regular"), (100, "Serious"), (150, "Intense")], id: \.0) { goal, label in
                    Button {
                        engagement.dailyXPGoal = goal
                        HapticService.selection()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(label)
                                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Pico.darkText)
                                Text("\(goal) XP per day")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(Pico.darkTextSecondary)
                            }
                            Spacer()
                            if engagement.dailyXPGoal == goal {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(Pico.leafGreen)
                            }
                        }
                        .picoCard()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var dialectSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Dialect", icon: "globe.americas.fill")

            VStack(spacing: 12) {
                if let dialect = Dialect(rawValue: dialectRaw) {
                    HStack(spacing: 14) {
                        Text(dialect.flag)
                            .font(.title)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(dialect.displayName)
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundStyle(Pico.darkText)
                            Text(dialect.subtitle)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(Pico.darkTextSecondary)
                        }
                        Spacer()
                    }
                    .picoCard()

                    Button {
                        dialectRaw = ""
                    } label: {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.subheadline)
                            Text("Switch Dialect")
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        }
                        .foregroundStyle(Pico.terracotta)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                                .fill(Pico.terracotta.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                                        .strokeBorder(Pico.terracotta.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Overview", icon: "chart.bar.fill")

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                settingsStat(value: "\(engagementService.xp)", label: "Total XP", icon: "star.fill", color: Pico.gold)
                settingsStat(value: "Lv. \(engagementService.userLevel)", label: "User Level", icon: "trophy.fill", color: Pico.leafGreen)
                settingsStat(value: "\(engagementService.bestDayStreak)", label: "Best Streak", icon: "flame.fill", color: .orange)
                settingsStat(value: "\(engagementService.badges.count)", label: "Badges", icon: "medal.fill", color: Pico.terracotta)
            }
        }
    }

    private func settingsStat(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(Pico.darkText)
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Pico.darkTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .picoCard()
    }

    private var resetSection: some View {
        Button {
            showResetAlert = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash.fill")
                    .font(.subheadline)
                Text("Reset All Progress")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
            }
            .foregroundStyle(.red.opacity(0.8))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(.red.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(.red.opacity(0.15), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Pico.darkTextSecondary)
            Text(title)
                .font(.system(.subheadline, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.darkText)
        }
    }
}
