import SwiftUI

nonisolated enum AppearanceMode: String, CaseIterable, Sendable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }

    var icon: String {
        switch self {
        case .system: "circle.lefthalf.filled"
        case .light: "sun.max.fill"
        case .dark: "moon.fill"
        }
    }
}

enum Pico {

    // MARK: - Background
    static let plaster = Color(red: 0.957, green: 0.953, blue: 0.937) // #F4F3EF
    static let cardSurface = Color(red: 0.918, green: 0.906, blue: 0.878) // #EAE7E0

    // MARK: - Dark Mode variants
    static let plasterDark = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let cardSurfaceDark = Color(red: 0.16, green: 0.16, blue: 0.18)

    // MARK: - Primary Palette
    static let deepForestGreen = Color(red: 0.169, green: 0.298, blue: 0.231) // #2B4C3B
    static let leafGreen = Color(red: 0.353, green: 0.545, blue: 0.369) // #5A8B5E

    // MARK: - Accent (rare, high-value only)
    static let terracotta = Color(red: 0.851, green: 0.361, blue: 0.255) // #D95C41

    // MARK: - Supporting
    static let warmIvory = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let sandMid = Color(red: 0.92, green: 0.89, blue: 0.82)
    static let earthBrown = Color(red: 0.52, green: 0.42, blue: 0.32)
    static let softTeal = Color(red: 0.38, green: 0.62, blue: 0.56)
    static let deepTeal = Color(red: 0.16, green: 0.36, blue: 0.32)
    static let mistyGreen = Color(red: 0.82, green: 0.88, blue: 0.78)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let amber = Color(red: 1.0, green: 0.65, blue: 0.15)

    // MARK: - Legacy aliases (bridge for existing views)
    static let tangerine = terracotta
    static let sage = leafGreen
    static let mint = Color(red: 0.4, green: 0.78, blue: 0.65)
    static let ember = Color(red: 1.0, green: 0.55, blue: 0.2)
    static let deepOrange = Color(red: 0.85, green: 0.3, blue: 0.0)
    static let mossGreen = Color(red: 0.35, green: 0.5, blue: 0.3)
    static let softGold = Color(red: 1.0, green: 0.88, blue: 0.4)
    static let coral = Color(red: 1.0, green: 0.38, blue: 0.35)
    static let sky = Color(red: 0.35, green: 0.68, blue: 0.95)
    static let lavender = Color(red: 0.65, green: 0.55, blue: 0.85)
    static let lockedTint = Color(red: 0.3, green: 0.35, blue: 0.3)
    static let slateRock = Color(red: 0.82, green: 0.85, blue: 0.81)
    static let sandLight = Color(red: 0.96, green: 0.94, blue: 0.88)
    static let cream = plaster

    // MARK: - Forest path legacy
    static let deepForest = Color(red: 0.06, green: 0.1, blue: 0.08)
    static let midForest = Color(red: 0.08, green: 0.14, blue: 0.1)
    static let jungleCanopy = Color(red: 0.1, green: 0.28, blue: 0.12)
    static let jungleFloor = Color(red: 0.04, green: 0.12, blue: 0.06)
    static let tropicalGreen = Color(red: 0.18, green: 0.55, blue: 0.22)
    static let vineGreen = Color(red: 0.3, green: 0.65, blue: 0.25)
    static let jungleMist = Color(red: 0.35, green: 0.6, blue: 0.4)
    static let warmWhite = Color(red: 0.99, green: 0.97, blue: 0.95)
    static let mutedSage = Color(red: 0.45, green: 0.55, blue: 0.4)

    // MARK: - Path Colors
    static let pistachio = Color(red: 0.82, green: 0.88, blue: 0.78) // soft pistachio for path bg
    static let pistachioDark = Color(red: 0.72, green: 0.80, blue: 0.68)
    static let pistachioLight = Color(red: 0.88, green: 0.92, blue: 0.84)

    // MARK: - High Contrast Text
    static let darkText = Color(red: 0.10, green: 0.10, blue: 0.10)
    static let darkTextSecondary = Color(red: 0.25, green: 0.25, blue: 0.25)
    static let lightText = Color(red: 0.94, green: 0.94, blue: 0.94)
    static let lightTextSecondary = Color(red: 0.72, green: 0.72, blue: 0.72)

    // MARK: - Mascot & Backgrounds
    static let forestBgURL = "https://r2-pub.rork.com/generated-images/32865e6b-8ef7-4997-bd5f-6234f3e2ea07.png"
    static let kingfisherMascotURL = "https://r2-pub.rork.com/generated-images/2b35f4b3-ef9f-4520-8599-92f35c52bd5a.png"
    static let bicoMascotURL = "https://r2-pub.rork.com/generated-images/89a0eb3c-d924-4112-84c8-4bb576bc21be.png"
    static let monsteraHeaderURL = "https://r2-pub.rork.com/generated-images/23dd5673-14a7-4123-b34e-22fd5a777693.png"
    static let leafVeinTextureURL = "https://r2-pub.rork.com/generated-images/b7759818-d0cc-48d7-abfd-19f6d17dac3f.png"
    static let stoneArchTextureURL = "https://r2-pub.rork.com/generated-images/c8879eec-1612-4197-9656-91b31e12291a.png"
    static var enchantedForestPathURL = ""

    // MARK: - Spacing
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32

    // MARK: - Corner Radius
    static let cardRadius: CGFloat = 28

    // MARK: - Typography Helpers
    static let portugueseChars: [String] = ["á", "é", "í", "ó", "ú", "â", "ê", "ô", "ã", "õ", "ç"]

    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [deepForestGreen, leafGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        colors: [leafGreen, mint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let tangerineGradient = LinearGradient(
        colors: [terracotta, ember],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let glowGradient = RadialGradient(
        colors: [terracotta.opacity(0.5), amber.opacity(0.25), Color.clear],
        center: .center,
        startRadius: 10,
        endRadius: 60
    )

    static let premiumDark = LinearGradient(
        stops: [
            .init(color: Color(red: 0.08, green: 0.06, blue: 0.12), location: 0),
            .init(color: Color(red: 0.05, green: 0.08, blue: 0.06), location: 0.5),
            .init(color: Color(red: 0.04, green: 0.04, blue: 0.08), location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let premiumLight = LinearGradient(
        stops: [
            .init(color: plaster, location: 0),
            .init(color: plaster.opacity(0.95), location: 0.5),
            .init(color: cardSurface.opacity(0.3), location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Card light-hit stroke
    static let cardLightStroke = LinearGradient(
        stops: [
            .init(color: Color.white.opacity(0.6), location: 0),
            .init(color: Color.clear, location: 0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Keep Theme alias for existing code
typealias Theme = Pico

// MARK: - View Modifiers

struct PicoCard: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(Pico.spacingM)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(colorScheme == .dark ? Pico.cardSurfaceDark : Pico.cardSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(
                                colorScheme == .dark
                                    ? AnyShapeStyle(Color.white.opacity(0.08))
                                    : AnyShapeStyle(Pico.cardLightStroke),
                                lineWidth: 1
                            )
                    )
            )
    }
}

struct PremiumCard: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(Pico.spacingM)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(colorScheme == .dark ? Pico.cardSurfaceDark : Pico.cardSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(
                                colorScheme == .dark
                                    ? AnyShapeStyle(Color.white.opacity(0.08))
                                    : AnyShapeStyle(Pico.cardLightStroke),
                                lineWidth: 1
                            )
                    )
            )
    }
}

struct GlowButton: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.35), radius: 12, y: 6)
    }
}

struct AdaptiveBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background((colorScheme == .dark ? Pico.plasterDark : Pico.plaster).ignoresSafeArea())
    }
}

extension View {
    func picoCard() -> some View {
        modifier(PicoCard())
    }

    func premiumCard() -> some View {
        modifier(PremiumCard())
    }

    func glowButton(color: Color = Pico.terracotta) -> some View {
        modifier(GlowButton(color: color))
    }

    func adaptiveBackground() -> some View {
        modifier(AdaptiveBackground())
    }
}

extension Pico {
    static func adaptiveText(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? lightText : darkText
    }

    static func adaptiveTextSecondary(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? lightTextSecondary : darkTextSecondary
    }

    static func adaptivePlaster(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? plasterDark : plaster
    }

    static func adaptiveCard(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? cardSurfaceDark : cardSurface
    }
}
