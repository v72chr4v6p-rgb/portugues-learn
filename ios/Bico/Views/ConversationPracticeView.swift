import SwiftUI

struct ConversationPracticeView: View {
    let dialect: Dialect
    @Environment(VerbDataService.self) private var verbDataService
    @Environment(SpeechService.self) private var speechService
    @Environment(EngagementService.self) private var engagementService
    @State private var currentScenario: Int = 0
    @State private var userAnswer: String = ""
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool = false
    @State private var score: Int = 0
    @State private var isComplete: Bool = false
    @State private var selectedDifficulty: Difficulty = .beginner
    @Environment(\.dismiss) private var dismiss

    private var scenarios: [ConversationScenario] {
        let all = dialect == .brazilian ? brazilianScenarios : europeanScenarios
        return Array(all.filter { $0.difficulty == selectedDifficulty }.prefix(8))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Pico.plaster.ignoresSafeArea()

                if isComplete {
                    completionView
                } else if scenarios.isEmpty {
                    setupView
                } else if !showResult && currentScenario == 0 && userAnswer.isEmpty {
                    setupView
                } else {
                    scenarioView
                }
            }
            .navigationTitle("A Conversa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("A Conversa")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
        }
    }

    private var setupView: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Pico.deepForestGreen.opacity(0.08))
                            .frame(width: 90, height: 90)
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Pico.deepForestGreen)
                    }

                    Text("Conversation Practice")
                        .font(.system(.title2, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)

                    Text(dialect == .brazilian
                         ? "Practice real-world Brazilian Portuguese conversations"
                         : "Practice real-world European Portuguese conversations")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Difficulty")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(Pico.deepForestGreen)

                    ForEach(Difficulty.allCases, id: \.self) { diff in
                        Button {
                            selectedDifficulty = diff
                            HapticService.selection()
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: diff.icon)
                                    .font(.title3)
                                    .foregroundStyle(diff.color)
                                    .frame(width: 36)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(diff.title)
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundStyle(Pico.deepForestGreen)
                                    Text(diff.subtitle)
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                                }

                                Spacer()

                                if selectedDifficulty == diff {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(Pico.leafGreen)
                                }
                            }
                            .picoCard()
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4)) {
                        startSession()
                    }
                    HapticService.heavyTap()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Practice")
                            .font(.system(.headline, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 16))
                    .shadow(color: Pico.deepForestGreen.opacity(0.2), radius: 8, y: 4)
                }
            }
            .padding(.horizontal, Pico.spacingXL)
            .padding(.bottom, 40)
        }
    }

    private var scenarioView: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Pico.earthBrown.opacity(0.08)).frame(height: 6)
                    Capsule().fill(Pico.primaryGradient)
                        .frame(width: scenarios.isEmpty ? 0 : geo.size.width * CGFloat(currentScenario) / CGFloat(scenarios.count), height: 6)
                        .animation(.spring, value: currentScenario)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 20)
            .padding(.top, 8)

            HStack {
                Text("\(currentScenario + 1)/\(scenarios.count)")
                    .font(.system(.caption, design: .rounded, weight: .semibold).monospacedDigit())
                    .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.caption).foregroundStyle(Pico.gold)
                    Text("\(score)").font(.system(.caption, design: .rounded, weight: .bold).monospacedDigit())
                        .foregroundStyle(Pico.deepForestGreen)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

            if currentScenario < scenarios.count {
                let scenario = scenarios[currentScenario]
                VStack(spacing: 16) {
                    Text(scenario.situation)
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(Pico.deepForestGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Pico.deepForestGreen.opacity(0.08), in: Capsule())

                    VStack(spacing: 8) {
                        Image(systemName: "person.wave.2.fill")
                            .font(.title2)
                            .foregroundStyle(Pico.deepForestGreen.opacity(0.3))

                        Text(scenario.prompt)
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .foregroundStyle(Pico.deepForestGreen)
                            .multilineTextAlignment(.center)

                        Button {
                            speechService.speak(scenario.prompt, dialect: dialect)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.body)
                                .foregroundStyle(Pico.deepForestGreen)
                                .frame(width: 40, height: 40)
                                .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                        }
                    }

                    Text(scenario.instruction)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                        .fill(Pico.cardSurface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Pico.cardRadius, style: .continuous)
                                .strokeBorder(Pico.cardLightStroke, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
            }

            Spacer()

            VStack(spacing: 12) {
                TextField("Type your response...", text: $userAnswer)
                    .font(.system(.title3, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Pico.cardSurface, in: .rect(cornerRadius: 14))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 20)
                    .disabled(showResult)
                    .onSubmit { if !showResult && !userAnswer.isEmpty { checkAnswer() } }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Pico.portugueseChars, id: \.self) { char in
                            Button {
                                userAnswer += char
                                HapticService.lightTap()
                            } label: {
                                Text(char)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .foregroundStyle(Pico.deepForestGreen)
                                    .frame(width: 38, height: 38)
                                    .background(Pico.cardSurface, in: .rect(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .disabled(showResult)
                        }
                    }
                }
                .contentMargins(.horizontal, 20)

                if showResult {
                    resultBanner
                } else {
                    Button {
                        checkAnswer()
                    } label: {
                        Text("Check")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                userAnswer.isEmpty
                                ? AnyShapeStyle(Pico.earthBrown.opacity(0.2))
                                : AnyShapeStyle(Pico.primaryGradient),
                                in: .rect(cornerRadius: 14)
                            )
                    }
                    .disabled(userAnswer.isEmpty)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 20)
            .animation(.spring(response: 0.35), value: showResult)
        }
    }

    private var resultBanner: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "info.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? Pico.leafGreen : Pico.terracotta)

                VStack(alignment: .leading, spacing: 2) {
                    Text(isCorrect ? "Correct!" : "Good try!")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Pico.deepForestGreen)
                    if currentScenario < scenarios.count {
                        Text("Answer: \(scenarios[currentScenario].answer)")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(isCorrect ? Pico.leafGreen : Pico.terracotta)
                    }
                }
                Spacer()

                if currentScenario < scenarios.count {
                    Button {
                        speechService.speak(scenarios[currentScenario].answer, dialect: dialect)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title3)
                            .foregroundStyle(Pico.deepForestGreen)
                            .frame(width: 44, height: 44)
                            .background(Pico.deepForestGreen.opacity(0.08), in: Circle())
                    }
                }
            }
            .picoCard()

            Button {
                advance()
            } label: {
                Text(currentScenario + 1 >= scenarios.count ? "Finish" : "Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var completionView: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 56))
                .foregroundStyle(Pico.leafGreen)
                .symbolEffect(.bounce, value: isComplete)

            Text("Conversation Done!")
                .font(.system(.title, design: .serif, weight: .bold))
                .tracking(-0.3)
                .foregroundStyle(Pico.deepForestGreen)

            Text("+\(score) XP")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Pico.gold)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Pico.primaryGradient, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .sensoryFeedback(.success, trigger: isComplete)
    }

    private func startSession() {
        currentScenario = 0
        score = 0
        userAnswer = ""
        showResult = false
        isCorrect = false
        isComplete = false
        if !scenarios.isEmpty {
            showResult = false
        }
    }

    private func checkAnswer() {
        guard currentScenario < scenarios.count else { return }
        let scenario = scenarios[currentScenario]
        let answer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = scenario.answer.lowercased()
        let acceptables = scenario.alternates.map { $0.lowercased() } + [correct]
        isCorrect = acceptables.contains(answer)
        showResult = true

        if isCorrect {
            score += 15
            engagementService.awardXP(15, source: "conversation")
            HapticService.success()
        } else {
            score += 3
            engagementService.awardXP(3, source: "conversation")
            HapticService.error()
        }
    }

    private func advance() {
        currentScenario += 1
        userAnswer = ""
        showResult = false
        isCorrect = false
        if currentScenario >= scenarios.count {
            engagementService.recordSession()
            isComplete = true
        }
    }
}

enum Difficulty: String, CaseIterable {
    case beginner, intermediate, advanced

    var title: String {
        switch self {
        case .beginner: "Beginner"
        case .intermediate: "Intermediate"
        case .advanced: "Advanced"
        }
    }

    var subtitle: String {
        switch self {
        case .beginner: "Simple greetings & responses"
        case .intermediate: "Daily situations & questions"
        case .advanced: "Complex sentences & expressions"
        }
    }

    var icon: String {
        switch self {
        case .beginner: "leaf.fill"
        case .intermediate: "tree.fill"
        case .advanced: "mountain.2.fill"
        }
    }

    var color: Color {
        switch self {
        case .beginner: Pico.leafGreen
        case .intermediate: Pico.amber
        case .advanced: Pico.terracotta
        }
    }
}

struct ConversationScenario {
    let situation: String
    let prompt: String
    let instruction: String
    let answer: String
    let alternates: [String]
    let difficulty: Difficulty
}

private let brazilianScenarios: [ConversationScenario] = [
    ConversationScenario(situation: "At a café", prompt: "Bom dia! O que você quer tomar?", instruction: "Say you want a coffee, please", answer: "Eu quero um café, por favor", alternates: ["Quero um café, por favor", "Um café, por favor"], difficulty: .beginner),
    ConversationScenario(situation: "Meeting someone", prompt: "Oi! Como você se chama?", instruction: "Say your name (use 'Ana')", answer: "Eu me chamo Ana", alternates: ["Me chamo Ana", "Meu nome é Ana"], difficulty: .beginner),
    ConversationScenario(situation: "Greeting", prompt: "Tudo bem?", instruction: "Say everything is fine, thanks", answer: "Tudo bem, obrigado", alternates: ["Tudo bem, obrigada", "Tudo bom", "Tudo bem"], difficulty: .beginner),
    ConversationScenario(situation: "Asking directions", prompt: "Onde fica o supermercado?", instruction: "Say it's on the right", answer: "Fica à direita", alternates: ["É à direita", "Está à direita"], difficulty: .beginner),
    ConversationScenario(situation: "Restaurant", prompt: "Você já escolheu?", instruction: "Say you want the chicken, please", answer: "Eu quero o frango, por favor", alternates: ["Quero o frango, por favor", "Vou querer o frango"], difficulty: .beginner),
    ConversationScenario(situation: "At the store", prompt: "Posso ajudar?", instruction: "Say you are looking for a book", answer: "Estou procurando um livro", alternates: ["Eu estou procurando um livro", "Procuro um livro"], difficulty: .beginner),
    ConversationScenario(situation: "Taxi", prompt: "Para onde vai?", instruction: "Say you're going to the airport", answer: "Vou para o aeroporto", alternates: ["Eu vou para o aeroporto", "Para o aeroporto, por favor"], difficulty: .beginner),
    ConversationScenario(situation: "Phone call", prompt: "Alô, quem fala?", instruction: "Say it's you (use 'João')", answer: "É o João", alternates: ["Sou o João", "Aqui é o João"], difficulty: .beginner),

    ConversationScenario(situation: "Making plans", prompt: "O que você vai fazer amanhã?", instruction: "Say you're going to study Portuguese", answer: "Vou estudar português", alternates: ["Eu vou estudar português", "Amanhã vou estudar português"], difficulty: .intermediate),
    ConversationScenario(situation: "At work", prompt: "Você pode me ajudar com isso?", instruction: "Say yes, of course", answer: "Sim, claro", alternates: ["Claro que sim", "Posso sim", "Sim, com certeza"], difficulty: .intermediate),
    ConversationScenario(situation: "Doctor's office", prompt: "O que você está sentindo?", instruction: "Say you have a headache", answer: "Estou com dor de cabeça", alternates: ["Eu estou com dor de cabeça", "Tenho dor de cabeça"], difficulty: .intermediate),
    ConversationScenario(situation: "Shopping", prompt: "Quanto custa?", instruction: "Say it's too expensive", answer: "É muito caro", alternates: ["Está muito caro", "Muito caro"], difficulty: .intermediate),
    ConversationScenario(situation: "At a party", prompt: "Você conhece todo mundo aqui?", instruction: "Say you only know Maria", answer: "Só conheço a Maria", alternates: ["Eu só conheço a Maria", "Conheço só a Maria"], difficulty: .intermediate),
    ConversationScenario(situation: "Travel", prompt: "Quanto tempo você ficou no Brasil?", instruction: "Say you stayed for two weeks", answer: "Fiquei duas semanas", alternates: ["Eu fiquei duas semanas", "Fiquei por duas semanas"], difficulty: .intermediate),
    ConversationScenario(situation: "Restaurant", prompt: "Como estava a comida?", instruction: "Say the food was delicious", answer: "A comida estava deliciosa", alternates: ["Estava deliciosa", "Foi deliciosa"], difficulty: .intermediate),
    ConversationScenario(situation: "At home", prompt: "Quem cozinhou hoje?", instruction: "Say your mother cooked", answer: "Minha mãe cozinhou", alternates: ["A minha mãe cozinhou", "Foi minha mãe que cozinhou"], difficulty: .intermediate),

    ConversationScenario(situation: "Job interview", prompt: "Por que você quer trabalhar aqui?", instruction: "Say because you believe in the company", answer: "Porque eu acredito na empresa", alternates: ["Porque acredito na empresa", "Eu acredito no trabalho da empresa"], difficulty: .advanced),
    ConversationScenario(situation: "Debate", prompt: "O que você acha sobre isso?", instruction: "Say you think it depends on the situation", answer: "Acho que depende da situação", alternates: ["Eu acho que depende da situação", "Depende da situação"], difficulty: .advanced),
    ConversationScenario(situation: "Giving advice", prompt: "Estou muito estressado.", instruction: "Say he should rest more", answer: "Você deveria descansar mais", alternates: ["Deveria descansar mais", "Você precisa descansar mais"], difficulty: .advanced),
    ConversationScenario(situation: "Hypothetical", prompt: "Se você pudesse viajar para qualquer lugar...", instruction: "Say you would go to Portugal", answer: "Eu iria para Portugal", alternates: ["Iria para Portugal", "Eu viajaria para Portugal"], difficulty: .advanced),
    ConversationScenario(situation: "Past experience", prompt: "Conte sobre sua infância.", instruction: "Say when you were young you lived in the countryside", answer: "Quando eu era jovem, morava no interior", alternates: ["Quando era jovem, eu morava no interior", "Eu morava no interior quando era jovem"], difficulty: .advanced),
    ConversationScenario(situation: "Expressing doubt", prompt: "Ela disse que vai chegar cedo.", instruction: "Say you doubt she will arrive on time", answer: "Duvido que ela chegue a tempo", alternates: ["Eu duvido que ela chegue a tempo"], difficulty: .advanced),
    ConversationScenario(situation: "Polite request", prompt: "Preciso de uma informação.", instruction: "Say you could help if he wants", answer: "Eu poderia ajudar, se quiser", alternates: ["Posso ajudar se quiser", "Poderia ajudar, se você quiser"], difficulty: .advanced),
    ConversationScenario(situation: "Explaining", prompt: "Por que você aprendeu português?", instruction: "Say you always wanted to understand the culture", answer: "Sempre quis entender a cultura", alternates: ["Eu sempre quis entender a cultura", "Porque sempre quis entender a cultura"], difficulty: .advanced),
]

private let europeanScenarios: [ConversationScenario] = [
    ConversationScenario(situation: "At a café", prompt: "Bom dia! O que deseja?", instruction: "Say you want a coffee, please", answer: "Quero um café, por favor", alternates: ["Eu quero um café, por favor", "Um café, se faz favor"], difficulty: .beginner),
    ConversationScenario(situation: "Meeting someone", prompt: "Olá! Como te chamas?", instruction: "Say your name (use 'Ana')", answer: "Chamo-me Ana", alternates: ["O meu nome é Ana", "Eu chamo-me Ana"], difficulty: .beginner),
    ConversationScenario(situation: "Greeting", prompt: "Está bom?", instruction: "Say everything is fine, thanks", answer: "Está tudo bem, obrigado", alternates: ["Está tudo bem, obrigada", "Tudo bem", "Está bom, obrigado"], difficulty: .beginner),
    ConversationScenario(situation: "Asking directions", prompt: "Onde fica o supermercado?", instruction: "Say it's on the right", answer: "Fica à direita", alternates: ["É à direita", "Está à direita"], difficulty: .beginner),
    ConversationScenario(situation: "Restaurant", prompt: "Já escolheu?", instruction: "Say you want the fish, please", answer: "Quero o peixe, se faz favor", alternates: ["Eu quero o peixe, por favor", "O peixe, se faz favor"], difficulty: .beginner),
    ConversationScenario(situation: "At the store", prompt: "Posso ajudar?", instruction: "Say you are looking for a book", answer: "Estou à procura de um livro", alternates: ["Procuro um livro", "Estou a procurar um livro"], difficulty: .beginner),
    ConversationScenario(situation: "Taxi", prompt: "Para onde vai?", instruction: "Say you're going to the airport", answer: "Vou para o aeroporto", alternates: ["Para o aeroporto, se faz favor"], difficulty: .beginner),
    ConversationScenario(situation: "Phone call", prompt: "Estou? Quem fala?", instruction: "Say it's you (use 'João')", answer: "É o João", alternates: ["Fala o João", "Aqui é o João"], difficulty: .beginner),

    ConversationScenario(situation: "Making plans", prompt: "O que vais fazer amanhã?", instruction: "Say you're going to study Portuguese", answer: "Vou estudar português", alternates: ["Amanhã vou estudar português"], difficulty: .intermediate),
    ConversationScenario(situation: "At work", prompt: "Podes ajudar-me com isto?", instruction: "Say yes, of course", answer: "Sim, claro", alternates: ["Claro que sim", "Posso sim", "Com certeza"], difficulty: .intermediate),
    ConversationScenario(situation: "Doctor's office", prompt: "O que é que sente?", instruction: "Say you have a headache", answer: "Tenho dores de cabeça", alternates: ["Estou com dores de cabeça", "Dói-me a cabeça"], difficulty: .intermediate),
    ConversationScenario(situation: "Shopping", prompt: "Quanto custa?", instruction: "Say it's too expensive", answer: "É muito caro", alternates: ["Está muito caro", "Muito caro"], difficulty: .intermediate),
    ConversationScenario(situation: "At a party", prompt: "Conheces toda a gente aqui?", instruction: "Say you only know Maria", answer: "Só conheço a Maria", alternates: ["Eu só conheço a Maria"], difficulty: .intermediate),
    ConversationScenario(situation: "Travel", prompt: "Quanto tempo ficaste em Portugal?", instruction: "Say you stayed for two weeks", answer: "Fiquei duas semanas", alternates: ["Eu fiquei duas semanas", "Fiquei por duas semanas"], difficulty: .intermediate),
    ConversationScenario(situation: "Restaurant", prompt: "Como estava a comida?", instruction: "Say the food was delicious", answer: "A comida estava deliciosa", alternates: ["Estava deliciosa", "Foi deliciosa"], difficulty: .intermediate),
    ConversationScenario(situation: "At home", prompt: "Quem cozinhou hoje?", instruction: "Say your mother cooked", answer: "A minha mãe cozinhou", alternates: ["Cozinhou a minha mãe", "Foi a minha mãe que cozinhou"], difficulty: .intermediate),

    ConversationScenario(situation: "Job interview", prompt: "Porque é que queres trabalhar aqui?", instruction: "Say because you believe in the company", answer: "Porque acredito na empresa", alternates: ["Porque eu acredito na empresa"], difficulty: .advanced),
    ConversationScenario(situation: "Debate", prompt: "O que achas sobre isso?", instruction: "Say you think it depends on the situation", answer: "Acho que depende da situação", alternates: ["Penso que depende da situação", "Depende da situação"], difficulty: .advanced),
    ConversationScenario(situation: "Giving advice", prompt: "Estou muito stressado.", instruction: "Say he should rest more", answer: "Devias descansar mais", alternates: ["Deverias descansar mais", "Precisas de descansar mais"], difficulty: .advanced),
    ConversationScenario(situation: "Hypothetical", prompt: "Se pudesses viajar para qualquer lugar...", instruction: "Say you would go to Brazil", answer: "Iria para o Brasil", alternates: ["Eu iria para o Brasil", "Viajaria para o Brasil"], difficulty: .advanced),
    ConversationScenario(situation: "Past experience", prompt: "Conta sobre a tua infância.", instruction: "Say when you were young you lived in the countryside", answer: "Quando era jovem, morava no campo", alternates: ["Quando eu era jovem, vivia no campo", "Vivia no campo quando era jovem"], difficulty: .advanced),
    ConversationScenario(situation: "Expressing doubt", prompt: "Ela disse que vai chegar cedo.", instruction: "Say you doubt she will arrive on time", answer: "Duvido que ela chegue a tempo", alternates: ["Eu duvido que chegue a tempo"], difficulty: .advanced),
    ConversationScenario(situation: "Polite request", prompt: "Preciso de uma informação.", instruction: "Say you could help if he wants", answer: "Posso ajudar, se quiseres", alternates: ["Poderia ajudar, se quiseres", "Eu posso ajudar se quiseres"], difficulty: .advanced),
    ConversationScenario(situation: "Explaining", prompt: "Porque é que aprendeste português?", instruction: "Say you always wanted to understand the culture", answer: "Sempre quis compreender a cultura", alternates: ["Sempre quis entender a cultura", "Porque sempre quis compreender a cultura"], difficulty: .advanced),
]
