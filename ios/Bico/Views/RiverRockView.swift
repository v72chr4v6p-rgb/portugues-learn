import SwiftUI

struct RiverRockView: View {
    let level: Level
    let isUnlocked: Bool
    let isCompleted: Bool
    let isCracked: Bool
    let showBico: Bool
    let offset: CGFloat
    let action: () -> Void

    @State private var bicoHover = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                if showBico {
                    bicoIndicator
                }

                ZStack {
                    rockShape

                    if isCracked && !isCompleted {
                        crackOverlay
                    }

                    VStack(spacing: 2) {
                        Text("\(level.level)")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundStyle(levelNumberColor)

                        Text(level.tense)
                            .font(.system(.caption2, weight: .medium))
                            .foregroundStyle(tenseColor)
                            .lineLimit(1)
                    }
                }
                .frame(width: rockSize, height: rockSize)

                if level.isSpecial {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundStyle(Theme.tangerine)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .offset(x: offset)
        .padding(.vertical, 8)
        .onAppear {
            if showBico {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    bicoHover = true
                }
            }
        }
    }

    private var bicoIndicator: some View {
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
        .frame(width: 36, height: 36)
        .offset(y: bicoHover ? -4 : 2)
    }

    private var rockShape: some View {
        Ellipse()
            .fill(rockFill)
            .shadow(color: .black.opacity(isUnlocked ? 0.15 : 0.05), radius: isUnlocked ? 6 : 2, y: 3)
            .overlay(
                Ellipse()
                    .strokeBorder(rockBorder, lineWidth: isCompleted ? 3 : 1)
            )
    }

    private var crackOverlay: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: rockSize * 0.35, y: rockSize * 0.2))
                path.addLine(to: CGPoint(x: rockSize * 0.45, y: rockSize * 0.4))
                path.addLine(to: CGPoint(x: rockSize * 0.38, y: rockSize * 0.55))
                path.addLine(to: CGPoint(x: rockSize * 0.5, y: rockSize * 0.75))
            }
            .stroke(Color.red.opacity(0.5), lineWidth: 1.5)
        }
    }

    private var rockSize: CGFloat {
        level.isSpecial ? 80 : 68
    }

    private var rockFill: some ShapeStyle {
        if !isUnlocked {
            return AnyShapeStyle(Color(.systemGray4))
        }
        if isCompleted {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Theme.slateRock, Theme.slateRock.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        if isCracked {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(.systemGray3), Color(.systemGray4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [Theme.slateRock, Theme.sage.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var rockBorder: some ShapeStyle {
        if isCompleted {
            return AnyShapeStyle(Theme.tangerine)
        }
        if !isUnlocked {
            return AnyShapeStyle(Color.clear)
        }
        return AnyShapeStyle(Theme.sage.opacity(0.4))
    }

    private var levelNumberColor: Color {
        if !isUnlocked { return .secondary }
        if isCompleted { return Theme.tangerine }
        return .primary
    }

    private var tenseColor: Color {
        if !isUnlocked { return Color(.tertiaryLabel) }
        return .secondary
    }
}
