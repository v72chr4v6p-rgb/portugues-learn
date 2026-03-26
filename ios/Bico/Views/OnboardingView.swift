import SwiftUI

struct OnboardingView: View {
    let onDialectSelected: (Dialect) -> Void
    @State private var appeared = false
    @State private var selectedOption: Dialect?
    @State private var mascotBounce: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.02, green: 0.08, blue: 0.04), location: 0),
                    .init(color: Theme.jungleCanopy.opacity(0.6), location: 0.3),
                    .init(color: Theme.deepForest, location: 0.6),
                    .init(color: Color(red: 0.03, green: 0.06, blue: 0.03), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                mascotSection
                    .padding(.bottom, 24)

                titleSection
                    .padding(.bottom, 36)

                dialectCards
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

                continueButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                Text("You can change this later in Settings")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.bottom, 40)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.5)) {
                mascotBounce = true
            }
        }
    }

    private var mascotSection: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Theme.tropicalGreen.opacity(0.15), Color.clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)

            AsyncImage(url: URL(string: Theme.bicoMascotURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Theme.tangerine)
                }
            }
            .frame(width: 100, height: 100)
            .offset(y: mascotBounce ? -4 : 4)
        }
        .scaleEffect(appeared ? 1.0 : 0.3)
        .opacity(appeared ? 1.0 : 0.0)
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("Olá!")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.tangerine)

            Text("Welcome to Bico")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)

            Text("Choose your Portuguese dialect to begin")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .opacity(appeared ? 1.0 : 0.0)
        .offset(y: appeared ? 0 : 20)
    }

    private var dialectCards: some View {
        VStack(spacing: 16) {
            ForEach(Dialect.allCases, id: \.self) { dialect in
                JungleDialectCard(
                    dialect: dialect,
                    isSelected: selectedOption == dialect,
                    action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedOption = dialect
                        }
                        HapticService.selection()
                    }
                )
            }
        }
        .opacity(appeared ? 1.0 : 0.0)
        .offset(y: appeared ? 0 : 30)
    }

    private var continueButton: some View {
        Button {
            guard let dialect = selectedOption else { return }
            HapticService.heavyTap()
            onDialectSelected(dialect)
        } label: {
            Text("Continue")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    selectedOption != nil
                        ? AnyShapeStyle(Theme.tangerineGradient)
                        : AnyShapeStyle(Color.white.opacity(0.1)),
                    in: .rect(cornerRadius: 16)
                )
        }
        .disabled(selectedOption == nil)
        .opacity(appeared ? 1.0 : 0.0)
        .offset(y: appeared ? 0 : 20)
    }
}

struct JungleDialectCard: View {
    let dialect: Dialect
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(dialect.flag)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(dialect.displayName)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(dialect.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))

                    Text(dialect.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.35))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Theme.tangerine : Color.white.opacity(0.3))
                    .contentTransition(.symbolEffect(.replace))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Theme.tangerine.opacity(0.12) : Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Theme.tangerine : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
