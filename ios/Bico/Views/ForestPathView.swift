import SwiftUI

struct ForestPathView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(ProgressService.self) private var progressService
    @State private var navigateToLevel: Level?
    @State private var jumpLevel: Level?
    @State private var showJumpConfirmation: Bool = false
    @State private var appeared: Bool = false
    @State private var pulseActive: Bool = false
    @State private var glowPhase: Bool = false

    private let enchantedBgURL = "https://r2-pub.rork.com/generated-images/61b7cdd6-28f6-4690-b077-04a474078187.png"

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ZStack {
                        forestBackground

                        VStack(spacing: 0) {
                            pathHeader
                                .padding(.top, 16)
                                .padding(.bottom, 24)

                            let sorted = verbDataService.allSortedLevels()
                            ForEach(Array(sorted.enumerated()), id: \.element.level) { index, level in
                                let isUnlocked = progressService.isLevelUnlocked(level.level)
                                let isCompleted = progressService.isLevelCompleted(level.level)
                                let isCracked = progressService.isLevelCracked(level.level)
                                let isCurrent = isCurrentLevel(level.level, allLevels: sorted)

                                if shouldShowZoneLabel(level: level, index: index, allLevels: sorted) {
                                    zoneLabelView(for: level.zone)
                                        .padding(.top, index == 0 ? 0 : 24)
                                        .padding(.bottom, 16)
                                        .padding(.horizontal, 20)
                                }

                                ZStack {
                                    if index < sorted.count - 1 {
                                        pathConnector(
                                            fromIndex: index,
                                            toIndex: index + 1,
                                            fromCompleted: isCompleted
                                        )
                                    }

                                    pathNode(
                                        level: level,
                                        index: index,
                                        isUnlocked: isUnlocked,
                                        isCompleted: isCompleted,
                                        isCracked: isCracked,
                                        isCurrent: isCurrent
                                    )
                                    .id(level.level)
                                }
                            }

                            summitFooter
                                .padding(.top, 40)
                                .padding(.bottom, 120)
                        }
                    }
                }
                .background(Color(red: 0.06, green: 0.12, blue: 0.06))
                .ignoresSafeArea(edges: .top)
                .onAppear {
                    guard !appeared else { return }
                    appeared = true
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                        pulseActive = true
                    }
                    withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                        glowPhase = true
                    }
                    let current = currentLevelNumber(verbDataService.allSortedLevels())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            proxy.scrollTo(current, anchor: .center)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("The Path")
                        .font(.system(.title3, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(.white.opacity(0.9))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    levelCountBadge
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $navigateToLevel) { level in
                LevelDetailView(level: level, dialect: dialect)
            }
            .alert("Skip to Level \(jumpLevel?.level ?? 0)?", isPresented: $showJumpConfirmation) {
                Button("Cancel", role: .cancel) { jumpLevel = nil }
                Button("Jump Ahead") {
                    if let level = jumpLevel {
                        progressService.jumpToLevel(level.level)
                        HapticService.heavyTap()
                        navigateToLevel = level
                    }
                    jumpLevel = nil
                }
            } message: {
                Text("This will mark all previous levels as completed. You can always go back and practice them later.")
            }
        }
    }

    // MARK: - Forest Background

    private var forestBackground: some View {
        GeometryReader { geo in
            Color(red: 0.04, green: 0.08, blue: 0.04)
                .overlay {
                    AsyncImage(url: URL(string: enchantedBgURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width)
                                .opacity(0.55)
                        }
                    }
                    .allowsHitTesting(false)
                }
                .overlay {
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.04, green: 0.08, blue: 0.04).opacity(0.0), location: 0),
                            .init(color: Color(red: 0.04, green: 0.08, blue: 0.04).opacity(0.3), location: 0.15),
                            .init(color: Color.clear, location: 0.35),
                            .init(color: Color.clear, location: 0.7),
                            .init(color: Color(red: 0.03, green: 0.06, blue: 0.03).opacity(0.5), location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                }
                .overlay(alignment: .top) {
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.95, blue: 0.7).opacity(glowPhase ? 0.12 : 0.06),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 200
                    )
                    .frame(height: 350)
                    .allowsHitTesting(false)
                }
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    // MARK: - Level Count Badge

    private var levelCountBadge: some View {
        let total = 43
        let done = progressService.completedLevelCount

        return Text("\(done)/\(total)")
            .font(.system(.caption, design: .rounded, weight: .bold).monospacedDigit())
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Pico.deepForestGreen.opacity(0.7))
                    .overlay(
                        Capsule()
                            .strokeBorder(Pico.leafGreen.opacity(0.4), lineWidth: 1)
                    )
            )
    }

    // MARK: - Path Header

    private var pathHeader: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: Pico.kingfisherMascotURL)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Pico.leafGreen)
                }
            }
            .frame(width: 64, height: 64)
            .shadow(color: Pico.amber.opacity(0.4), radius: 12, y: 2)

            Text("Your Journey")
                .font(.system(.title2, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(.white.opacity(0.9))

            let total = 43
            let done = progressService.completedLevelCount
            pathProgressBar(done: done, total: total)
        }
        .padding(.top, 50)
    }

    private func pathProgressBar(done: Int, total: Int) -> some View {
        let progress = Double(done) / Double(total)

        return HStack(spacing: 10) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 5)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Pico.leafGreen, Pico.amber],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(5, 120 * progress), height: 5)
                    .shadow(color: Pico.leafGreen.opacity(0.5), radius: 4)
            }

            Text("\(done) of \(total) levels")
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
    }

    // MARK: - Path Node

    private func pathNode(level: Level, index: Int, isUnlocked: Bool, isCompleted: Bool, isCracked: Bool, isCurrent: Bool) -> some View {
        let xOffset = naturalCurveOffset(for: index)
        let baseSize: CGFloat = level.isSpecial ? 64 : 54
        let nodeSize: CGFloat = isCurrent ? baseSize * 1.2 : baseSize

        return Button {
            if isUnlocked {
                navigateToLevel = level
                HapticService.lightTap()
            } else {
                jumpLevel = level
                showJumpConfirmation = true
                HapticService.selection()
            }
        } label: {
            VStack(spacing: 0) {
                ZStack {
                    if isCurrent {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Pico.amber.opacity(pulseActive ? 0.35 : 0.15),
                                        Pico.leafGreen.opacity(pulseActive ? 0.12 : 0.04),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: nodeSize * 0.25,
                                    endRadius: nodeSize * 1.1
                                )
                            )
                            .frame(width: nodeSize * 2.2, height: nodeSize * 2.2)
                            .allowsHitTesting(false)
                    }

                    if isCompleted {
                        completedNode(level: level, size: nodeSize)
                    } else if isCurrent {
                        currentNode(level: level, size: nodeSize)
                    } else if isUnlocked {
                        unlockedNode(level: level, size: nodeSize)
                    } else {
                        lockedNode(size: nodeSize)
                    }

                    if isCracked && !isCompleted {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.red)
                            .offset(x: nodeSize / 2 - 4, y: -nodeSize / 2 + 4)
                    }
                }

                nodeLabel(level: level, isUnlocked: isUnlocked, isCompleted: isCompleted, isCurrent: isCurrent)
                    .padding(.top, 8)
            }
            .offset(x: xOffset)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 10)
        .opacity(!isUnlocked ? 0.6 : 1)
    }

    private func completedNode(level: Level, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.5, blue: 0.25),
                            Color(red: 0.14, green: 0.38, blue: 0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [Pico.leafGreen.opacity(0.6), Pico.tropicalGreen.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                }
                .shadow(color: Pico.leafGreen.opacity(0.3), radius: 8, y: 2)

            Image(systemName: "checkmark")
                .font(.system(size: size * 0.3, weight: .bold))
                .foregroundStyle(.white.opacity(0.9))
        }
    }

    private func currentNode(level: Level, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.18, green: 0.42, blue: 0.22),
                            Color(red: 0.12, green: 0.32, blue: 0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    Circle()
                        .strokeBorder(
                            AngularGradient(
                                colors: [Pico.amber, Pico.gold, Pico.amber],
                                center: .center
                            ),
                            lineWidth: 3
                        )
                }
                .shadow(color: Pico.amber.opacity(0.5), radius: 14, y: 0)

            Text("\(level.level)")
                .font(.system(size: size * 0.35, weight: .heavy, design: .rounded))
                .foregroundStyle(Pico.amber)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
        }
    }

    private func unlockedNode(level: Level, size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.36, blue: 0.22),
                            Color(red: 0.14, green: 0.28, blue: 0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    Circle()
                        .strokeBorder(Pico.leafGreen.opacity(0.3), lineWidth: 1.5)
                }
                .shadow(color: Pico.deepForestGreen.opacity(0.4), radius: 6, y: 3)

            Text("\(level.level)")
                .font(.system(size: size * 0.32, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
                .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
        }
    }

    private func lockedNode(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.28, green: 0.32, blue: 0.26),
                            Color(red: 0.2, green: 0.24, blue: 0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

            Image(systemName: "lock.fill")
                .font(.system(size: size * 0.24))
                .foregroundStyle(.white.opacity(0.25))
        }
    }

    // MARK: - Node Label

    private func nodeLabel(level: Level, isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some View {
        VStack(spacing: 3) {
            Text(level.tense)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    isUnlocked
                        ? (isCurrent ? Pico.amber : .white.opacity(0.8))
                        : .white.opacity(0.3)
                )
                .lineLimit(1)
                .shadow(color: .black.opacity(0.5), radius: 2, y: 1)

            if level.isSpecial {
                HStack(spacing: 3) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 8))
                    Text("Special")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                }
                .foregroundStyle(Pico.amber)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
            }

            if isCompleted {
                let prog = progressService.progress(for: level.level)
                if prog.bestScore > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 7))
                        Text("\(prog.bestScore)")
                            .font(.system(size: 9, weight: .bold, design: .rounded).monospacedDigit())
                    }
                    .foregroundStyle(Pico.amber)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                }
            }
        }
    }

    // MARK: - Path Connector

    private func pathConnector(fromIndex: Int, toIndex: Int, fromCompleted: Bool) -> some View {
        let fromX = naturalCurveOffset(for: fromIndex)
        let toX = naturalCurveOffset(for: toIndex)

        return Canvas { context, size in
            let startX = size.width / 2 + fromX
            let endX = size.width / 2 + toX
            let startY: CGFloat = 0
            let endY = size.height

            var path = Path()
            path.move(to: CGPoint(x: startX, y: startY))

            let midY = (startY + endY) / 2
            let controlOffset = (endX - startX) * 0.3
            path.addCurve(
                to: CGPoint(x: endX, y: endY),
                control1: CGPoint(x: startX + controlOffset, y: midY - 10),
                control2: CGPoint(x: endX - controlOffset, y: midY + 10)
            )

            if fromCompleted {
                context.stroke(
                    path,
                    with: .color(Pico.leafGreen.opacity(0.15)),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                context.stroke(
                    path,
                    with: .color(Pico.leafGreen.opacity(0.4)),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
            } else {
                context.stroke(
                    path,
                    with: .color(Color.white.opacity(0.08)),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                context.stroke(
                    path,
                    with: .color(Color.white.opacity(0.12)),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 8])
                )
            }
        }
        .frame(height: 22)
        .allowsHitTesting(false)
    }

    // MARK: - Header & Footer

    private var summitFooter: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Pico.amber.opacity(0.25), Color.clear],
                            center: .center,
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "flag.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Pico.amber)
                    .shadow(color: Pico.amber.opacity(0.6), radius: 8)
            }

            Text("The Summit")
                .font(.system(.title3, design: .serif, weight: .bold))
                .foregroundStyle(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.4), radius: 2, y: 1)

            Text("Master all 43 levels to conquer Portuguese verbs")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
        }
    }

    // MARK: - Zone Label

    private func zoneLabelView(for zone: ForestZone) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.1), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            HStack(spacing: 6) {
                Image(systemName: zone.icon)
                    .font(.system(size: 10))
                Text(zone.rawValue)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                    .tracking(1)
            }
            .foregroundStyle(.white.opacity(0.8))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Pico.deepForestGreen.opacity(0.6))
                    .overlay(
                        Capsule()
                            .strokeBorder(Pico.leafGreen.opacity(0.2), lineWidth: 0.5)
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.white.opacity(0.1), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
    }

    // MARK: - Helpers

    private func shouldShowZoneLabel(level: Level, index: Int, allLevels: [Level]) -> Bool {
        if index == 0 { return true }
        return allLevels[index - 1].zone != level.zone
    }

    private func naturalCurveOffset(for index: Int) -> CGFloat {
        let t = Double(index)
        let primary = sin(t * 0.55 + 0.3) * 42
        let secondary = cos(t * 0.35 + 1.2) * 22
        let micro = sin(t * 1.1) * 8
        return CGFloat(primary + secondary + micro)
    }

    private func currentLevelNumber(_ allLevels: [Level]) -> Int {
        for level in allLevels {
            if !progressService.isLevelCompleted(level.level) {
                return level.level
            }
        }
        return 43
    }

    private func isCurrentLevel(_ levelNum: Int, allLevels: [Level]) -> Bool {
        levelNum == currentLevelNumber(allLevels)
    }
}
