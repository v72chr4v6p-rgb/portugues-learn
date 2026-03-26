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
    @State private var particlePhase: Bool = false

    private let forestBgURL = "https://r2-pub.rork.com/generated-images/32865e6b-8ef7-4997-bd5f-6234f3e2ea07.png"

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ZStack {
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
                }
                .background(jungleBackground)
                .onAppear {
                    guard !appeared else { return }
                    appeared = true
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                        pulseActive = true
                    }
                    withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                        particlePhase = true
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
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("The Path")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
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

    // MARK: - Jungle Background

    private var jungleBackground: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.04, green: 0.12, blue: 0.06), location: 0),
                    .init(color: Color(red: 0.06, green: 0.16, blue: 0.08), location: 0.15),
                    .init(color: Color(red: 0.05, green: 0.14, blue: 0.07), location: 0.4),
                    .init(color: Color(red: 0.03, green: 0.10, blue: 0.05), location: 0.7),
                    .init(color: Color(red: 0.02, green: 0.08, blue: 0.04), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            canopyOverlay
                .ignoresSafeArea()

            floatingParticles
                .ignoresSafeArea()
        }
    }

    private var canopyOverlay: some View {
        Canvas { context, size in
            for i in 0..<20 {
                let seed = Double(i) * 137.5
                let x = seed.truncatingRemainder(dividingBy: size.width)
                let y = Double(i) / 20.0 * size.height
                let leafW = CGFloat(25 + (i % 7) * 8)
                let leafH = CGFloat(10 + (i % 5) * 5)
                let rotation = Angle.degrees(Double(i * 37 % 360))

                var transform = CGAffineTransform.identity
                transform = transform.translatedBy(x: x, y: y)
                transform = transform.rotated(by: rotation.radians)
                transform = transform.translatedBy(x: -leafW/2, y: -leafH/2)

                let rect = CGRect(x: 0, y: 0, width: leafW, height: leafH)
                let path = Path(ellipseIn: rect).applying(transform)

                let alpha = 0.03 + Double(i % 4) * 0.01
                context.fill(path, with: .color(Pico.tropicalGreen.opacity(alpha)))
            }

            for i in 0..<8 {
                let x = Double(i) * size.width / 8.0 + 20
                let startY = 0.0
                let endY = Double(40 + (i % 4) * 30)
                let vineWidth: CGFloat = 1.5

                var path = Path()
                path.move(to: CGPoint(x: x, y: startY))
                let ctrlX = x + Double((i % 2 == 0) ? 12 : -12)
                path.addQuadCurve(
                    to: CGPoint(x: x + Double((i % 2 == 0) ? 5 : -5), y: endY),
                    control: CGPoint(x: ctrlX, y: endY * 0.6)
                )

                context.stroke(
                    path,
                    with: .color(Pico.vineGreen.opacity(0.08)),
                    style: StrokeStyle(lineWidth: vineWidth, lineCap: .round)
                )
            }
        }
        .allowsHitTesting(false)
    }

    private var floatingParticles: some View {
        Canvas { context, size in
            let baseOffset = particlePhase ? 8.0 : -8.0
            for i in 0..<15 {
                let seed = Double(i) * 97.3
                let x = seed.truncatingRemainder(dividingBy: size.width)
                let y = (Double(i) / 15.0 * size.height) + baseOffset * sin(Double(i) * 0.5)
                let dotSize: CGFloat = CGFloat(2 + i % 3)

                let alpha = 0.08 + Double(i % 4) * 0.03
                let color = i % 3 == 0
                    ? Pico.amber.opacity(alpha)
                    : Pico.leafGreen.opacity(alpha * 0.7)

                let rect = CGRect(x: x - dotSize/2, y: y - dotSize/2, width: dotSize, height: dotSize)
                context.fill(Path(ellipseIn: rect), with: .color(color))
            }
        }
        .allowsHitTesting(false)
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
                                        Pico.amber.opacity(pulseActive ? 0.3 : 0.12),
                                        Pico.leafGreen.opacity(pulseActive ? 0.12 : 0.04),
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
                            color: isCurrent ? Pico.amber.opacity(0.4) : (isCompleted ? Pico.leafGreen.opacity(0.3) : Color.black.opacity(0.3)),
                            radius: isCurrent ? 16 : (isCompleted ? 8 : 4),
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
        .opacity(!isUnlocked ? 0.5 : 1)
    }

    private func completedTree(index: Int) -> some View {
        HStack(spacing: 3) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 9))
                .foregroundStyle(Pico.tropicalGreen.opacity(0.7))
                .rotationEffect(.degrees(Double(index % 3) * 15 - 15))
            Image(systemName: "tree.fill")
                .font(.system(size: 14))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Pico.tropicalGreen, Pico.leafGreen],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            Image(systemName: "leaf.fill")
                .font(.system(size: 9))
                .foregroundStyle(Pico.tropicalGreen.opacity(0.7))
                .rotationEffect(.degrees(Double(index % 3) * -15 + 15))
        }
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
                    .foregroundStyle(.white.opacity(0.25))
            } else {
                Text("\(level.level)")
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .foregroundStyle(isCurrent ? Pico.amber : .white)
            }
        }
    }

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
                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
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
                    .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
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
                    with: .color(.white.opacity(0.08)),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 7])
                )
            }
        }
        .frame(height: 20)
        .allowsHitTesting(false)
    }

    // MARK: - Mascot

    private var mascotBadge: some View {
        AsyncImage(url: URL(string: Pico.bicoMascotURL)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "bird.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Pico.amber)
            }
        }
        .frame(width: 40, height: 40)
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        .offset(x: 16, y: 2)
        .offset(y: pulseActive ? -3 : 3)
        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: pulseActive)
    }

    // MARK: - Node Fills

    private func nodeFill(isUnlocked: Bool, isCompleted: Bool, isCurrent: Bool) -> some ShapeStyle {
        if !isUnlocked {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.12, green: 0.18, blue: 0.12),
                        Color(red: 0.08, green: 0.14, blue: 0.08)
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
                        Color(red: 0.12, green: 0.32, blue: 0.14),
                        Color(red: 0.08, green: 0.24, blue: 0.10)
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
                        Color(red: 0.16, green: 0.28, blue: 0.14),
                        Color(red: 0.10, green: 0.22, blue: 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.14, green: 0.22, blue: 0.12),
                    Color(red: 0.10, green: 0.18, blue: 0.10)
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
            return AnyShapeStyle(.white.opacity(0.15))
        }
        return AnyShapeStyle(.white.opacity(0.06))
    }

    // MARK: - Header & Footer

    private var pathHeader: some View {
        VStack(spacing: 14) {
            AsyncImage(url: URL(string: Pico.bicoMascotURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.title2)
                        .foregroundStyle(Pico.amber)
                }
            }
            .frame(width: 56, height: 56)
            .shadow(color: .black.opacity(0.3), radius: 6, y: 3)

            Text("Your Journey")
                .font(.system(.title3, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)

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
                    .fill(.white.opacity(0.1))
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
                .foregroundStyle(.white.opacity(0.5))
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
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)

            Text("Master all 43 levels to conquer Portuguese verbs")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.white.opacity(0.4))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Zone Label

    private func zoneLabelView(for zone: ForestZone) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Pico.leafGreen.opacity(0.3), Color.clear],
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
            .foregroundStyle(.white.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial.opacity(0.3), in: Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(.white.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Pico.leafGreen.opacity(0.3), Color.clear],
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
