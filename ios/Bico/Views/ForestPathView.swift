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

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        pathHeader
                            .padding(.top, 20)
                            .padding(.bottom, 32)

                        let sorted = verbDataService.allSortedLevels()
                        ForEach(Array(sorted.enumerated()), id: \.element.level) { index, level in
                            let isUnlocked = progressService.isLevelUnlocked(level.level)
                            let isCompleted = progressService.isLevelCompleted(level.level)
                            let isCracked = progressService.isLevelCracked(level.level)
                            let isCurrent = isCurrentLevel(level.level, allLevels: sorted)

                            if shouldShowZoneLabel(level: level, index: index, allLevels: sorted) {
                                zoneLabelView(for: level.zone)
                                    .padding(.top, index == 0 ? 0 : 28)
                                    .padding(.bottom, 20)
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

                                nodeView(
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
                .background(premiumBackground)
                .onAppear {
                    guard !appeared else { return }
                    appeared = true
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                        pulseActive = true
                    }
                    let current = currentLevelNumber(verbDataService.allSortedLevels())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            proxy.scrollTo(current, anchor: .center)
                        }
                    }
                }
            }
            .navigationTitle("Path")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $navigateToLevel) { level in
                LevelDetailView(level: level, dialect: dialect)
            }
            .alert("Skip to Level \(jumpLevel?.level ?? 0)?", isPresented: $showJumpConfirmation) {
                Button("Cancel", role: .cancel) {
                    jumpLevel = nil
                }
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

    // MARK: - Node View

    private func nodeView(level: Level, index: Int, isUnlocked: Bool, isCompleted: Bool, isCracked: Bool, isCurrent: Bool) -> some View {
        let xOffset = naturalCurveOffset(for: index)
        let baseSize: CGFloat = level.isSpecial ? 68 : 58
        let nodeSize: CGFloat = isCurrent ? baseSize * 1.15 : baseSize

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
                if isCurrent {
                    mascotBadge
                        .padding(.bottom, -2)
                }

                ZStack {
                    if isCurrent {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Theme.tangerine.opacity(pulseActive ? 0.25 : 0.1),
                                        Theme.amber.opacity(pulseActive ? 0.12 : 0.04),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: nodeSize * 0.3,
                                    endRadius: nodeSize * 0.85
                                )
                            )
                            .frame(width: nodeSize * 1.7, height: nodeSize * 1.7)
                            .allowsHitTesting(false)
                    }

                    Circle()
                        .fill(nodeFill(isUnlocked: isUnlocked, isCompleted: isCompleted, isCurrent: isCurrent))
                        .frame(width: nodeSize, height: nodeSize)
                        .overlay {
                            Circle()
                                .strokeBorder(
                                    nodeBorder(isCompleted: isCompleted, isCurrent: isCurrent, isUnlocked: isUnlocked),
                                    lineWidth: isCurrent ? 2.5 : (isCompleted ? 1.5 : 0.5)
                                )
                        }
                        .shadow(
                            color: isCurrent ? Theme.tangerine.opacity(0.25) : (isCompleted ? Theme.leafGreen.opacity(0.15) : Color.black.opacity(0.06)),
                            radius: isCurrent ? 14 : (isCompleted ? 6 : 3),
                            y: isCurrent ? 0 : 2
                        )

                    if isCracked && !isCompleted {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.red)
                            .offset(x: nodeSize / 2 - 2, y: -nodeSize / 2 + 2)
                    }

                    nodeContent(level: level, isUnlocked: isUnlocked, isCompleted: isCompleted, isCurrent: isCurrent)
                }

                nodeLabel(level: level, isUnlocked: isUnlocked, isCompleted: isCompleted, isCurrent: isCurrent)
                    .padding(.top, 8)

                if isCompleted {
                    completedTree(index: index)
                        .padding(.top, 4)
                }
            }
            .offset(x: xOffset)
        }
        .buttonStyle(.plain)
        .padding(.vertical, isCompleted ? 2 : 8)
        .opacity(!isUnlocked ? 0.55 : 1)
    }

    private func completedTree(index: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 8))
                .foregroundStyle(Theme.leafGreen.opacity(0.5))
                .rotationEffect(.degrees(Double(index % 3) * 15 - 15))
            Image(systemName: "leaf.fill")
                .font(.system(size: 10))
                .foregroundStyle(Theme.leafGreen.opacity(0.6))
            Image(systemName: "leaf.fill")
                .font(.system(size: 8))
                .foregroundStyle(Theme.leafGreen.opacity(0.5))
                .rotationEffect(.degrees(Double(index % 3) * -15 + 15))
        }
    }

    private func nodeContent(level: Level, isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some View {
        Group {
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.leafGreen)
            } else if !isUnlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.earthBrown.opacity(0.4))
            } else {
                Text("\(level.level)")
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .foregroundStyle(isCurrent ? Theme.tangerine : Theme.deepTeal)
            }
        }
    }

    private func nodeLabel(level: Level, isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some View {
        VStack(spacing: 3) {
            Text(level.tense)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(
                    isUnlocked
                        ? (isCurrent ? Theme.tangerine : Theme.deepTeal.opacity(0.8))
                        : Theme.earthBrown.opacity(0.35)
                )
                .lineLimit(1)

            if level.isSpecial {
                HStack(spacing: 3) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 8))
                    Text("Special")
                        .font(.system(size: 9, weight: .bold))
                }
                .foregroundStyle(Theme.amber)
            }

            if isCompleted {
                let prog = progressService.progress(for: level.level)
                if prog.bestScore > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 7))
                        Text("\(prog.bestScore)")
                            .font(.system(size: 9, weight: .bold).monospacedDigit())
                    }
                    .foregroundStyle(Theme.amber)
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
                    with: .color(Theme.leafGreen.opacity(0.3)),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
            } else {
                context.stroke(
                    path,
                    with: .color(Theme.earthBrown.opacity(0.12)),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 7])
                )
            }
        }
        .frame(height: 20)
        .allowsHitTesting(false)
    }

    // MARK: - Mascot

    private var mascotBadge: some View {
        AsyncImage(url: URL(string: Theme.bicoMascotURL)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "bird.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.tangerine)
            }
        }
        .frame(width: 36, height: 36)
        .offset(x: 14, y: 2)
        .offset(y: pulseActive ? -2 : 2)
        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: pulseActive)
    }

    // MARK: - Node Fills

    private func nodeFill(isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some ShapeStyle {
        if !isUnlocked {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Theme.sandMid.opacity(0.6), Theme.sandLight.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        if isCompleted {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Theme.mistyGreen.opacity(0.6), Theme.leafGreen.opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        if isCurrent {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.white, Theme.warmIvory],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [Theme.warmIvory, Theme.sandLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private func nodeBorder(isCompleted: Bool, isCurrent: Bool, isUnlocked: Bool) -> some ShapeStyle {
        if isCurrent {
            return AnyShapeStyle(
                AngularGradient(
                    colors: [Theme.tangerine, Theme.amber, Theme.tangerine],
                    center: .center
                )
            )
        }
        if isCompleted {
            return AnyShapeStyle(Theme.leafGreen.opacity(0.5))
        }
        if isUnlocked {
            return AnyShapeStyle(Theme.earthBrown.opacity(0.15))
        }
        return AnyShapeStyle(Theme.earthBrown.opacity(0.08))
    }

    // MARK: - Premium Background

    private var premiumBackground: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Theme.warmIvory, location: 0),
                    .init(color: Theme.sandLight, location: 0.3),
                    .init(color: Theme.mistyGreen.opacity(0.15).blended(with: Theme.warmIvory), location: 0.6),
                    .init(color: Theme.sandLight, location: 0.85),
                    .init(color: Theme.warmIvory, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            subtleTexture
                .ignoresSafeArea()
        }
    }

    private var subtleTexture: some View {
        Canvas { context, size in
            for i in 0..<12 {
                let seed = Double(i) * 97.3
                let x = (seed.truncatingRemainder(dividingBy: size.width))
                let y = Double(i) / 12.0 * size.height
                let leafSize: CGFloat = CGFloat(14 + (i % 5) * 4)
                let rect = CGRect(x: x - leafSize / 2, y: y - leafSize / 2, width: leafSize, height: leafSize)
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(Theme.leafGreen.opacity(0.025))
                )
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Header & Footer

    private var pathHeader: some View {
        VStack(spacing: 14) {
            AsyncImage(url: URL(string: Theme.bicoMascotURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.tangerine)
                }
            }
            .frame(width: 52, height: 52)

            Text("Your Journey")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.deepTeal)

            let total = 43
            let done = progressService.completedLevelCount
            progressBar(done: done, total: total)
        }
    }

    private func progressBar(done: Int, total: Int) -> some View {
        HStack(spacing: 10) {
            let progress = Double(done) / Double(total)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Theme.earthBrown.opacity(0.08))
                    .frame(width: 120, height: 5)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Theme.leafGreen, Theme.softTeal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(5, 120 * progress), height: 5)
            }

            Text("\(done)/\(total)")
                .font(.caption2.weight(.semibold).monospacedDigit())
                .foregroundStyle(Theme.earthBrown.opacity(0.5))
        }
    }

    private var summitFooter: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.amber.opacity(0.15), Color.clear],
                            center: .center,
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)

                Image(systemName: "flag.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(Theme.amber)
            }

            Text("The Summit")
                .font(.headline.weight(.bold))
                .foregroundStyle(Theme.deepTeal)

            Text("Master all 43 levels to conquer Portuguese verbs")
                .font(.caption)
                .foregroundStyle(Theme.earthBrown.opacity(0.5))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Zone Label

    private func zoneLabelView(for zone: ForestZone) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Theme.leafGreen.opacity(0.2), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            HStack(spacing: 6) {
                Image(systemName: zone.icon)
                    .font(.system(size: 10))
                Text(zone.rawValue)
                    .font(.system(size: 10, weight: .bold))
                    .textCase(.uppercase)
                    .tracking(1)
            }
            .foregroundStyle(Theme.deepTeal.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Theme.softTeal.opacity(0.08), in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(Theme.softTeal.opacity(0.15), lineWidth: 0.5)
            )

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Theme.leafGreen.opacity(0.2), Color.clear],
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

private extension Color {
    func blended(with other: Color) -> Color {
        Color(
            red: 0.5,
            green: 0.5,
            blue: 0.5
        )
    }
}
