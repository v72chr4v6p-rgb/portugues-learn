import SwiftUI

struct OnboardingView: View {
    let onDialectSelected: (Dialect) -> Void
    @State private var appeared = false
    @State private var selectedOption: Dialect?
    @State private var mascotBounce: Bool = false

    var body: some View {
        ZStack {
            Pico.plaster
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                mascotSection
                    .padding(.bottom, 24)

                titleSection
                    .padding(.bottom, 36)

                dialectCards
                    .padding(.horizontal, Pico.spacingXL)
                    .padding(.bottom, Pico.spacingXL)

                continueButton
                    .padding(.horizontal, Pico.spacingXL)
                    .padding(.bottom, Pico.spacingM)

                Text("You can change this later in Settings")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.4))
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
                        colors: [Pico.leafGreen.opacity(0.1), Color.clear],
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)

            AsyncImage(url: URL(string: Pico.kingfisherMascotURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "bird.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Pico.deepForestGreen)
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
                .font(.system(.largeTitle, design: .serif, weight: .bold))
                .tracking(-0.5)
                .foregroundStyle(Pico.deepForestGreen)

            Text("Welcome to Pico")
                .font(.system(.title2, design: .serif, weight: .semibold))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.8))

            Text("Choose your Portuguese dialect to begin")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .opacity(appeared ? 1.0 : 0.0)
        .offset(y: appeared ? 0 : 20)
    }

    private var dialectCards: some View {
        VStack(spacing: 16) {
            ForEach(Dialect.allCases, id: \.self) { dialect in
                PicoDialectCard(
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
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Pico.plaster)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    selectedOption != nil
                        ? AnyShapeStyle(Pico.primaryGradient)
                        : AnyShapeStyle(Pico.deepForestGreen.opacity(0.15)),
                    in: .rect(cornerRadius: Pico.cardRadius)
                )
        }
        .disabled(selectedOption == nil)
        .opacity(appeared ? 1.0 : 0.0)
        .offset(y: appeared ? 0 : 20)
    }
}

struct PicoDialectCard: View {
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
                        .font(.system(.headline, design: .serif))
                        .foregroundStyle(Pico.deepForestGreen)

                    Text(dialect.subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.6))

                    Text(dialect.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.35))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Pico.leafGreen : Pico.deepForestGreen.opacity(0.2))
                    .contentTransition(.symbolEffect(.replace))
            }
            .padding(Pico.spacingM)
            .background(
                RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                    .fill(isSelected ? Pico.leafGreen.opacity(0.08) : Pico.cardSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                            .strokeBorder(
                                isSelected
                                    ? AnyShapeStyle(Pico.leafGreen.opacity(0.4))
                                    : AnyShapeStyle(Pico.cardLightStroke),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
