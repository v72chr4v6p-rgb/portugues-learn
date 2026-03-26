import SwiftUI

struct CultureView: View {
    let dialect: Dialect
    @Environment(SpeechService.self) private var speechService
    @State private var expandedSection: String?

    private var content: [CultureSection] {
        dialect == .brazilian ? brazilianContent : europeanContent
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Pico.spacingL) {
                    headerCard
                    phrasesOfTheDay
                    ForEach(content) { section in
                        cultureCard(section)
                    }
                    etiquetteSection
                }
                .padding(.horizontal, Pico.spacingXL)
                .padding(.vertical, Pico.spacingL)
                .padding(.bottom, 80)
            }
            .background(Pico.plaster.ignoresSafeArea())
            .navigationTitle("Cultura")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Cultura")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
        }
    }

    private var headerCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                Text(dialect.flag)
                    .font(.system(size: 44))

                VStack(alignment: .leading, spacing: 4) {
                    Text(dialect == .brazilian ? "Cultura Brasileira" : "Cultura Portuguesa")
                        .font(.system(.title3, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                    Text(dialect == .brazilian
                         ? "Discover the vibrant culture behind Brazilian Portuguese"
                         : "Explore the rich heritage of European Portuguese")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .picoCard()
    }

    private var phrasesOfTheDay: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "quote.opening")
                    .font(.caption)
                    .foregroundStyle(Pico.terracotta)
                Text("Useful Phrases")
                    .font(.system(.headline, design: .serif, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(Pico.deepForestGreen)
            }

            let phrases = dialect == .brazilian ? brazilianPhrases : europeanPhrases
            ForEach(phrases, id: \.portuguese) { phrase in
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(phrase.portuguese)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.deepForestGreen)
                        Text(phrase.english)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                        if !phrase.context.isEmpty {
                            Text(phrase.context)
                                .font(.system(.caption2, design: .rounded))
                                .foregroundStyle(Pico.terracotta.opacity(0.8))
                        }
                    }
                    Spacer()
                    Button {
                        speechService.speak(phrase.portuguese, dialect: dialect)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.caption)
                            .foregroundStyle(Pico.deepForestGreen)
                            .frame(width: 32, height: 32)
                            .background(Pico.deepForestGreen.opacity(0.06), in: Circle())
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Pico.cardSurface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                        )
                )
            }
        }
    }

    private func cultureCard(_ section: CultureSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expandedSection = expandedSection == section.id ? nil : section.id
                }
                HapticService.selection()
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(section.color.opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: section.icon)
                            .font(.title3)
                            .foregroundStyle(section.color)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(section.title)
                            .font(.system(.headline, design: .serif, weight: .bold))
                            .tracking(-0.3)
                            .foregroundStyle(Pico.deepForestGreen)
                        Text(section.subtitle)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                    }

                    Spacer()

                    Image(systemName: expandedSection == section.id ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.3))
                }
                .padding(Pico.spacingM)
            }
            .buttonStyle(.plain)

            if expandedSection == section.id {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(section.facts, id: \.self) { fact in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "leaf.fill")
                                .font(.caption2)
                                .foregroundStyle(Pico.leafGreen)
                                .padding(.top, 3)
                            Text(fact)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(Pico.deepForestGreen.opacity(0.7))
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(.horizontal, Pico.spacingM)
                .padding(.bottom, Pico.spacingM)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                .fill(Pico.cardSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                        .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                )
        )
        .clipShape(.rect(cornerRadius: Pico.cardRadius, style: .continuous))
    }

    private var etiquetteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "hand.wave.fill")
                    .font(.caption)
                    .foregroundStyle(Pico.amber)
                Text("Social Etiquette")
                    .font(.system(.headline, design: .serif, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(Pico.deepForestGreen)
            }

            let tips = dialect == .brazilian ? brazilianEtiquette : europeanEtiquette
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Pico.leafGreen)
                        .padding(.top, 2)
                    Text(tip)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.7))
                        .lineSpacing(2)
                }
            }
        }
        .picoCard()
    }
}

struct CulturePhrase {
    let portuguese: String
    let english: String
    let context: String
}

struct CultureSection: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let facts: [String]
}

private let brazilianPhrases: [CulturePhrase] = [
    CulturePhrase(portuguese: "Tudo bem?", english: "How's everything?", context: "Most common Brazilian greeting"),
    CulturePhrase(portuguese: "Beleza!", english: "Cool! / Alright!", context: "Informal agreement or greeting"),
    CulturePhrase(portuguese: "Fica à vontade", english: "Make yourself at home", context: "Said when welcoming guests"),
    CulturePhrase(portuguese: "Saudade", english: "Deep longing/missing", context: "Untranslatable — a core Brazilian concept"),
    CulturePhrase(portuguese: "Valeu!", english: "Thanks!", context: "Very casual, used among friends"),
    CulturePhrase(portuguese: "Com licença", english: "Excuse me", context: "Polite way to get someone's attention")
]

private let europeanPhrases: [CulturePhrase] = [
    CulturePhrase(portuguese: "Está bom?", english: "Is everything good?", context: "Common Portuguese greeting"),
    CulturePhrase(portuguese: "Pois", english: "Indeed / Right", context: "Used constantly in conversation as filler"),
    CulturePhrase(portuguese: "Faz favor", english: "Please / Excuse me", context: "Polite way to get attention or make a request"),
    CulturePhrase(portuguese: "Saudade", english: "Deep longing/missing", context: "Central to Portuguese identity and fado music"),
    CulturePhrase(portuguese: "Fixe!", english: "Cool!", context: "Informal, similar to 'legal' in Brazil"),
    CulturePhrase(portuguese: "Ora pois", english: "Well then", context: "Classic Portuguese expression")
]

private let brazilianContent: [CultureSection] = [
    CultureSection(id: "br-music", title: "Music & Dance", subtitle: "Samba, Bossa Nova & more", icon: "music.note.list", color: Pico.terracotta, facts: [
        "Samba originated in Bahia from African rhythms and is the heartbeat of Carnival.",
        "Bossa Nova, born in 1950s Rio, blends samba with jazz — 'The Girl from Ipanema' is one of the most recorded songs ever.",
        "Forró is the beloved dance music of Brazil's Northeast, played with accordion, triangle, and zabumba drum.",
        "MPB (Música Popular Brasileira) is a broad genre mixing folk, rock, and traditional sounds — artists like Caetano Veloso and Gilberto Gil are icons.",
        "Funk carioca and sertanejo are the most popular contemporary genres in Brazil today."
    ]),
    CultureSection(id: "br-food", title: "Food & Drink", subtitle: "Feijoada, açaí & cafézinho", icon: "fork.knife", color: Pico.leafGreen, facts: [
        "Feijoada, a black bean stew with pork, is considered Brazil's national dish — traditionally served on Wednesdays and Saturdays.",
        "Pão de queijo (cheese bread) from Minas Gerais is a beloved snack made with tapioca flour and cheese.",
        "Açaí bowls originated with indigenous Amazonian peoples and are now popular worldwide.",
        "Cafézinho (little coffee) is offered everywhere as a sign of hospitality — served strong, hot, and sweet.",
        "Brigadeiro, a chocolate truffle made with condensed milk, is the quintessential Brazilian party treat."
    ]),
    CultureSection(id: "br-festivals", title: "Festivals & Traditions", subtitle: "Carnival, Festa Junina & São João", icon: "sparkles", color: Pico.amber, facts: [
        "Carnival is the world's largest festival — Rio's Sambódromo parade features thousands of dancers and elaborate floats.",
        "Festa Junina (June Festival) celebrates harvest time with bonfires, forró dancing, and traditional foods like pamonha and quentão.",
        "Réveillon at Copacabana beach in Rio draws millions who wear white for good luck and offer flowers to Iemanjá.",
        "Each region has unique celebrations: Bumba meu Boi in Maranhão, Círio de Nazaré in Belém, and Oktoberfest in Blumenau."
    ]),
    CultureSection(id: "br-language", title: "Language Quirks", subtitle: "Gírias, diminutivos & jeitinho", icon: "textformat.abc", color: Pico.deepForestGreen, facts: [
        "Brazilians love diminutives: 'um pouquinho' (a little bit), 'rapidinho' (real quick), 'obrigadinho' (little thanks).",
        "Gírias (slang) vary hugely by region: 'mano' in São Paulo, 'brother' in the South, 'véi' in the Northeast.",
        "The 'jeitinho brasileiro' refers to the creative, flexible way Brazilians find solutions — reflected in language and culture.",
        "Brazilians often drop 'não é?' to 'né?' at the end of sentences, similar to 'right?' in English.",
        "'Gerúndio' (the -ando/-endo/-indo form) is used much more in Brazil than in Portugal."
    ])
]

private let europeanContent: [CultureSection] = [
    CultureSection(id: "pt-music", title: "Music & Fado", subtitle: "The soul of Portugal", icon: "music.note.list", color: Pico.terracotta, facts: [
        "Fado is Portugal's iconic music genre, born in Lisbon's Alfama district — it's a UNESCO Intangible Cultural Heritage.",
        "Amália Rodrigues, the 'Queen of Fado,' brought Portuguese music to the world stage in the 20th century.",
        "Modern fado artists like Mariza and Ana Moura blend traditional fado with contemporary sounds.",
        "The Portuguese guitar (guitarra portuguesa) has 12 strings and a distinctive pear shape — it's the soul of fado.",
        "Beyond fado, Portugal has a thriving electronic music scene and hosts festivals like NOS Alive and Super Bock Super Rock."
    ]),
    CultureSection(id: "pt-food", title: "Food & Drink", subtitle: "Bacalhau, pastéis & vinho", icon: "fork.knife", color: Pico.leafGreen, facts: [
        "The Portuguese say there are 365 ways to cook bacalhau (salt cod) — one for every day of the year.",
        "Pastel de nata (custard tart) from Belém is Portugal's most famous pastry — the original recipe remains a closely guarded secret.",
        "Portugal is one of the world's top wine producers — Port wine from the Douro Valley is world-renowned.",
        "A francesinha is Porto's beloved sandwich — layers of meat covered in melted cheese and a spicy beer sauce.",
        "Portuguese cuisine is simple but deeply flavourful, relying on olive oil, garlic, and fresh seafood."
    ]),
    CultureSection(id: "pt-history", title: "History & Heritage", subtitle: "Explorers, azulejos & saudade", icon: "building.columns.fill", color: Pico.amber, facts: [
        "Portugal launched the Age of Discovery — navigators like Vasco da Gama and Ferdinand Magellan changed the world map.",
        "Azulejos (painted ceramic tiles) cover buildings throughout Portugal and tell stories of history, religion, and daily life.",
        "The Carnation Revolution of 1974 peacefully ended decades of dictatorship — soldiers placed carnations in their rifle barrels.",
        "Saudade — a deep emotional longing — is considered untranslatable and central to Portuguese identity and literature.",
        "Portugal's Manueline architecture, seen in Belém Tower and Jerónimos Monastery, is a unique ornate style found nowhere else."
    ]),
    CultureSection(id: "pt-language", title: "Language Quirks", subtitle: "Tu vs você, pronoun placement & more", icon: "textformat.abc", color: Pico.deepForestGreen, facts: [
        "In Portugal, 'tu' is standard for informal 'you' — using 'você' can sound distant or even rude in casual settings.",
        "European Portuguese has more complex pronoun placement rules: 'Diz-me' (Tell me) vs Brazilian 'Me diz.'",
        "Portuguese people often swallow vowels and compress syllables, making EP sound quite different from BP to new learners.",
        "The expression 'Pois' is used constantly — it can mean 'yes,' 'right,' 'indeed,' or simply fill a pause.",
        "European Portuguese preserves the 'vós' form in some northern dialects, though it's largely fallen out of use elsewhere."
    ])
]

private let brazilianEtiquette: [String] = [
    "Greetings involve a kiss on each cheek (or one in São Paulo) between men and women, and women and women.",
    "Brazilians are warm and physically expressive — expect hugs, pats on the back, and close conversational distance.",
    "Being 15-30 minutes late to social gatherings is normal and expected — arriving exactly on time can seem eager.",
    "When entering a room, greet everyone individually — a general wave is considered cold.",
    "'Obrigado' (male speaker) vs 'Obrigada' (female speaker) — the ending matches the speaker's gender, not the listener's."
]

private let europeanEtiquette: [String] = [
    "The Portuguese greet with two kisses on the cheek (right cheek first) among friends and family.",
    "Use 'Senhor/Senhora' with older people or in formal settings — first names are reserved for closer relationships.",
    "Punctuality is more valued in Portugal than in Brazil, especially for business meetings.",
    "The Portuguese tend to be more reserved initially but become warm and generous once a relationship is established.",
    "'Obrigado' (male speaker) vs 'Obrigada' (female speaker) — same rule as in Brazil, the ending matches the speaker's gender."
]
