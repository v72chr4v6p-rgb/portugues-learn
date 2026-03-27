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

                                nodeWithTrees(
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
                .background(pistachioBackground)
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("The Path")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.darkText)
                }
            }
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

    // MARK: - Pistachio Background

    private var pistachioBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Pico.pistachioLight, location: 0),
                .init(color: Pico.pistachio, location: 0.3),
                .init(color: Pico.pistachio, location: 0.7),
                .init(color: Pico.pistachioDark.opacity(0.6), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Node with Trees on Sides

    private func nodeWithTrees(level: Level, index: Int, isUnlocked: Bool, isCompleted: Bool, isCracked: Bool, isCurrent: Bool) -> some View {
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
            HStack(spacing: 0) {
                sideLeaves(index: index, side: .left)
                    .frame(width: 44)
                    .opacity(isCompleted ? 1.0 : (isUnlocked ? 0.3 : 0.12))

                VStack(spacing: 0) {
                    ZStack {
                        if isCurrent {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Pico.amber.opacity(pulseActive ? 0.25 : 0.1),
                                            Pico.leafGreen.opacity(pulseActive ? 0.1 : 0.03),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: nodeSize * 0.3,
                                        endRadius: nodeSize * 0.9
                                    )
                                )
                                .frame(width: nodeSize * 1.8, height: nodeSize * 1.8)
                                .allowsHitTesting(false)
                        }

                        Circle()
                            .fill(nodeFill(isUnlocked: isUnlocked, isCompleted: isCompleted, isCurrent: isCurrent))
                            .frame(width: nodeSize, height: nodeSize)
                            .overlay {
                                Circle()
                                    .strokeBorder(
                                        nodeBorder(isCompleted: isCompleted, isCurrent: isCurrent, isUnlocked: isUnlocked),
                                        lineWidth: isCurrent ? 2.5 : (isCompleted ? 2 : 1)
                                    )
                            }
                            .shadow(
                                color: isCurrent ? Pico.amber.opacity(0.3) : (isCompleted ? Pico.leafGreen.opacity(0.2) : Pico.deepForestGreen.opacity(0.15)),
                                radius: isCurrent ? 12 : (isCompleted ? 6 : 3),
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
                }
                .offset(x: xOffset)

                sideLeaves(index: index, side: .right)
                    .frame(width: 44)
                    .opacity(isCompleted ? 1.0 : (isUnlocked ? 0.3 : 0.12))
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, 8)
        .opacity(!isUnlocked ? 0.5 : 1)
    }

    private enum TreeSide { case left, right }

    private func sideLeaves(index: Int, side: TreeSide) -> some View {
        let baseRotation = side == .left ? -25.0 : 25.0
        let variation = Double(index % 4) * 8
        let leafCount = (index % 3) + 1

        return VStack(spacing: 2) {
            ForEach(0..<leafCount, id: \.self) { leafIdx in
                let leafRotation = baseRotation + variation + Double(leafIdx) * (side == .left ? 12 : -12)
                let leafSize: CGFloat = leafIdx == 0 ? 14 : (leafIdx == 1 ? 11 : 9)
                let leafOpacity = 1.0 - Double(leafIdx) * 0.2
                let leafSymbol = leafIdx % 2 == 0 ? "leaf.fill" : "leaf"

                Image(systemName: leafSymbol)
                    .font(.system(size: leafSize))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Pico.leafGreen.opacity(leafOpacity),
                                Pico.tropicalGreen.opacity(leafOpacity * 0.8)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .rotationEffect(.degrees(leafRotation))
                    .scaleEffect(x: side == .left ? 1 : -1, y: 1)
            }
        }
        .offset(
            x: side == .left ? -4 : 4,
            y: CGFloat(index % 2 == 0 ? -6 : 2)
        )
    }

    private func nodeContent(level: Level, isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some View {
        Group {
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Pico.leafGreen)
            } else if !isUnlocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.3))
            } else {
                Text("\(level.level)")
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .foregroundStyle(isCurrent ? Pico.amber : Pico.plaster)
                    .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
            }
        }
    }

    private func nodeLabel(level: Level, isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some View {
        VStack(spacing: 3) {
            Text(level.tense)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(
                    isUnlocked
                        ? (isCurrent ? Pico.amber : Pico.darkText)
                        : Pico.darkText.opacity(0.35)
                )
                .lineLimit(1)

            if level.isSpecial {
                HStack(spacing: 3) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 8))
                    Text("Special")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                }
                .foregroundStyle(Pico.amber)
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
                    with: .color(Pico.leafGreen.opacity(0.5)),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
                context.stroke(
                    path,
                    with: .color(Pico.tropicalGreen.opacity(0.15)),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
            } else {
                context.stroke(
                    path,
                    with: .color(Pico.deepForestGreen.opacity(0.2)),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 7])
                )
            }
        }
        .frame(height: 20)
        .allowsHitTesting(false)
    }

    // MARK: - Node Fills

    private func nodeFill(isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some ShapeStyle {
        if !isUnlocked {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.55, green: 0.60, blue: 0.52),
                        Color(red: 0.48, green: 0.54, blue: 0.46)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        if isCompleted {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.22, green: 0.44, blue: 0.26),
                        Color(red: 0.16, green: 0.36, blue: 0.20)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        if isCurrent {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.20, green: 0.38, blue: 0.22),
                        Color(red: 0.14, green: 0.30, blue: 0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.38, blue: 0.24),
                    Color(red: 0.18, green: 0.32, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private func nodeBorder(isCompleted: Bool, isCurrent: Bool, isUnlocked: Bool) -> some ShapeStyle {
        if isCurrent {
            return AnyShapeStyle(
                AngularGradient(
                    colors: [Pico.amber, Pico.gold, Pico.amber],
                    center: .center
                )
            )
        }
        if isCompleted {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Pico.leafGreen.opacity(0.7), Pico.tropicalGreen.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        if isUnlocked {
            return AnyShapeStyle(Pico.deepForestGreen.opacity(0.25))
        }
        return AnyShapeStyle(Pico.deepForestGreen.opacity(0.1))
    }

    // MARK: - Header & Footer

    private var pathHeader: some View {
        VStack(spacing: 14) {
            AsyncImage(url: URL(string: Pico.kingfisherMascotURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.title2)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
            .frame(width: 56, height: 56)
            .shadow(color: Pico.deepForestGreen.opacity(0.15), radius: 6, y: 3)

            Text("Your Journey")
                .font(.system(.title3, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.darkText)

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
                    .fill(Pico.deepForestGreen.opacity(0.12))
                    .frame(width: 120, height: 5)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Pico.leafGreen, Pico.tropicalGreen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(5, 120 * progress), height: 5)
                    .shadow(color: Pico.leafGreen.opacity(0.4), radius: 4)
            }

            Text("\(done)/\(total)")
                .font(.system(.caption2, design: .rounded, weight: .semibold).monospacedDigit())
                .foregroundStyle(Pico.darkTextSecondary)
        }
    }

    private var summitFooter: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Pico.amber.opacity(0.2), Color.clear],
                            center: .center,
                            startRadius: 5,
                            endRadius: 45
                        )
                    )
                    .frame(width: 90, height: 90)

                Image(systemName: "flag.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Pico.amber)
                    .shadow(color: Pico.amber.opacity(0.5), radius: 6)
            }

            Text("The Summit")
                .font(.system(.headline, design: .serif, weight: .bold))
                .foregroundStyle(Pico.darkText)

            Text("Master all 43 levels to conquer Portuguese verbs")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Pico.darkTextSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Zone Label

    private func zoneLabelView(for zone: ForestZone) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Pico.deepForestGreen.opacity(0.2), Color.clear],
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
            .foregroundStyle(Pico.darkText)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Pico.pistachioLight.opacity(0.9), in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(Pico.deepForestGreen.opacity(0.15), lineWidth: 0.5)
            )
            .shadow(color: Pico.deepForestGreen.opacity(0.06), radius: 4, y: 2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Pico.deepForestGreen.opacity(0.2), Color.clear],
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
