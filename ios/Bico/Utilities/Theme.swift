import SwiftUI

enum Theme {
    static let tangerine = Color(red: 1.0, green: 0.42, blue: 0.0)
    static let sage = Color(red: 0.61, green: 0.686, blue: 0.533)
    static let slateRock = Color(red: 0.82, green: 0.85, blue: 0.81)
    static let forestDark = Color(red: 0.15, green: 0.22, blue: 0.15)
    static let warmWhite = Color(red: 0.99, green: 0.97, blue: 0.95)
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.92)
    static let ember = Color(red: 1.0, green: 0.55, blue: 0.2)
    static let deepOrange = Color(red: 0.85, green: 0.3, blue: 0.0)
    static let mint = Color(red: 0.4, green: 0.78, blue: 0.65)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)

    static let mossGreen = Color(red: 0.35, green: 0.5, blue: 0.3)
    static let softGold = Color(red: 1.0, green: 0.88, blue: 0.4)
    static let deepForest = Color(red: 0.06, green: 0.1, blue: 0.08)
    static let midForest = Color(red: 0.08, green: 0.14, blue: 0.1)
    static let amber = Color(red: 1.0, green: 0.65, blue: 0.15)
    static let mutedSage = Color(red: 0.45, green: 0.55, blue: 0.4)
    static let lockedTint = Color(red: 0.3, green: 0.35, blue: 0.3)

    static let forestBgURL = "https://r2-pub.rork.com/generated-images/32865e6b-8ef7-4997-bd5f-6234f3e2ea07.png"
    static let bicoMascotURL = "https://r2-pub.rork.com/generated-images/9e1b1cd7-66b8-4ed8-aa1e-270a03ec6135.png"

    static let jungleCanopy = Color(red: 0.1, green: 0.28, blue: 0.12)
    static let jungleFloor = Color(red: 0.04, green: 0.12, blue: 0.06)
    static let tropicalGreen = Color(red: 0.18, green: 0.55, blue: 0.22)
    static let vineGreen = Color(red: 0.3, green: 0.65, blue: 0.25)
    static let jungleMist = Color(red: 0.35, green: 0.6, blue: 0.4)

    static let sandLight = Color(red: 0.96, green: 0.94, blue: 0.88)
    static let sandMid = Color(red: 0.92, green: 0.89, blue: 0.82)
    static let warmIvory = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let softTeal = Color(red: 0.38, green: 0.62, blue: 0.56)
    static let leafGreen = Color(red: 0.28, green: 0.56, blue: 0.34)
    static let earthBrown = Color(red: 0.52, green: 0.42, blue: 0.32)
    static let deepTeal = Color(red: 0.16, green: 0.36, blue: 0.32)
    static let mistyGreen = Color(red: 0.82, green: 0.88, blue: 0.78)

    static let portugueseChars: [String] = ["á", "é", "í", "ó", "ú", "â", "ê", "ô", "ã", "õ", "ç"]

    static let tangerineGradient = LinearGradient(
        colors: [tangerine, ember],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let successGradient = LinearGradient(
        colors: [Color.green, mint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let glowGradient = RadialGradient(
        colors: [tangerine.opacity(0.5), amber.opacity(0.25), Color.clear],
        center: .center,
        startRadius: 10,
        endRadius: 60
    )
}
