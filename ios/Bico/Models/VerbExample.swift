import Foundation

nonisolated struct VerbExample: Sendable, Identifiable {
    let id: String
    let portuguese: String
    let english: String
    let highlightedForm: String

    init(portuguese: String, english: String, highlightedForm: String = "") {
        self.id = portuguese
        self.portuguese = portuguese
        self.english = english
        self.highlightedForm = highlightedForm
    }
}

nonisolated struct VerbExampleSet: Sendable {
    let commonMistake: String
    let mistakeExplanation: String
    let examples: [VerbExample]

    static let empty = VerbExampleSet(commonMistake: "", mistakeExplanation: "", examples: [])
}

enum VerbExampleData {
    static func examples(for infinitive: String) -> VerbExampleSet {
        switch infinitive.lowercased() {
        case "falar":
            return VerbExampleSet(
                commonMistake: "Eu fala (wrong) vs Eu falo (correct)",
                mistakeExplanation: "The 'eu' form always ends in -o for present tense -AR verbs.",
                examples: [
                    VerbExample(portuguese: "Eu falo português todos os dias.", english: "I speak Portuguese every day.", highlightedForm: "falo"),
                    VerbExample(portuguese: "Ela fala muito rápido.", english: "She speaks very fast.", highlightedForm: "fala"),
                    VerbExample(portuguese: "Nós falamos sobre o filme.", english: "We talked about the movie.", highlightedForm: "falamos")
                ]
            )
        case "ser":
            return VerbExampleSet(
                commonMistake: "Confusing SER with ESTAR",
                mistakeExplanation: "Use SER for permanent traits (nationality, profession). Use ESTAR for temporary states (mood, location).",
                examples: [
                    VerbExample(portuguese: "Eu sou brasileiro.", english: "I am Brazilian.", highlightedForm: "sou"),
                    VerbExample(portuguese: "Ela é médica.", english: "She is a doctor.", highlightedForm: "é"),
                    VerbExample(portuguese: "Nós somos amigos.", english: "We are friends.", highlightedForm: "somos")
                ]
            )
        case "estar":
            return VerbExampleSet(
                commonMistake: "Confusing ESTAR with SER",
                mistakeExplanation: "ESTAR is for temporary states and locations. 'Estou feliz' (I am happy right now), not 'Sou feliz' (unless it's your general disposition).",
                examples: [
                    VerbExample(portuguese: "Eu estou cansado.", english: "I am tired.", highlightedForm: "estou"),
                    VerbExample(portuguese: "Ela está em casa.", english: "She is at home.", highlightedForm: "está"),
                    VerbExample(portuguese: "Vocês estão prontos?", english: "Are you all ready?", highlightedForm: "estão")
                ]
            )
        case "ter":
            return VerbExampleSet(
                commonMistake: "Forgetting the accent: tem vs têm",
                mistakeExplanation: "'Tem' is singular (ele/ela/você), 'têm' (with circumflex) is plural (eles/vocês).",
                examples: [
                    VerbExample(portuguese: "Eu tenho dois irmãos.", english: "I have two brothers.", highlightedForm: "tenho"),
                    VerbExample(portuguese: "Ela tem uma casa grande.", english: "She has a big house.", highlightedForm: "tem"),
                    VerbExample(portuguese: "Nós temos que estudar.", english: "We have to study.", highlightedForm: "temos")
                ]
            )
        case "ir":
            return VerbExampleSet(
                commonMistake: "Using 'ir' without the preposition 'a' or 'para'",
                mistakeExplanation: "'Ir a' = go to (briefly). 'Ir para' = go to (stay). 'Vou a Lisboa' vs 'Vou para Lisboa'.",
                examples: [
                    VerbExample(portuguese: "Eu vou ao mercado.", english: "I go to the market.", highlightedForm: "vou"),
                    VerbExample(portuguese: "Nós vamos viajar amanhã.", english: "We are going to travel tomorrow.", highlightedForm: "vamos"),
                    VerbExample(portuguese: "Eles vão para a praia.", english: "They go to the beach.", highlightedForm: "vão")
                ]
            )
        case "fazer":
            return VerbExampleSet(
                commonMistake: "Eu fazo (wrong) vs Eu faço (correct)",
                mistakeExplanation: "The 'eu' form is irregular: faço (with cedilla), not fazo.",
                examples: [
                    VerbExample(portuguese: "Eu faço exercício de manhã.", english: "I exercise in the morning.", highlightedForm: "faço"),
                    VerbExample(portuguese: "O que você faz?", english: "What do you do?", highlightedForm: "faz"),
                    VerbExample(portuguese: "Nós fazemos o jantar juntos.", english: "We make dinner together.", highlightedForm: "fazemos")
                ]
            )
        case "poder":
            return VerbExampleSet(
                commonMistake: "Eu podo (wrong) vs Eu posso (correct)",
                mistakeExplanation: "The 'eu' form has a complete stem change: posso, not podo.",
                examples: [
                    VerbExample(portuguese: "Eu posso ajudar você.", english: "I can help you.", highlightedForm: "posso"),
                    VerbExample(portuguese: "Você pode repetir?", english: "Can you repeat?", highlightedForm: "pode"),
                    VerbExample(portuguese: "Nós podemos ir amanhã.", english: "We can go tomorrow.", highlightedForm: "podemos")
                ]
            )
        case "querer":
            return VerbExampleSet(
                commonMistake: "Mixing up 'querer' + infinitive vs 'querer que' + subjunctive",
                mistakeExplanation: "Same subject: 'Eu quero ir' (I want to go). Different subjects: 'Eu quero que ele vá' (I want him to go).",
                examples: [
                    VerbExample(portuguese: "Eu quero aprender português.", english: "I want to learn Portuguese.", highlightedForm: "quero"),
                    VerbExample(portuguese: "Ela quer um café.", english: "She wants a coffee.", highlightedForm: "quer"),
                    VerbExample(portuguese: "Vocês querem sair?", english: "Do you all want to go out?", highlightedForm: "querem")
                ]
            )
        case "saber":
            return VerbExampleSet(
                commonMistake: "Confusing SABER with CONHECER",
                mistakeExplanation: "SABER = know facts/skills. CONHECER = know people/places. 'Sei falar' (I know how to speak) vs 'Conheço Lisboa' (I know Lisbon).",
                examples: [
                    VerbExample(portuguese: "Eu sei falar três línguas.", english: "I know how to speak three languages.", highlightedForm: "sei"),
                    VerbExample(portuguese: "Você sabe onde fica?", english: "Do you know where it is?", highlightedForm: "sabe"),
                    VerbExample(portuguese: "Nós sabemos a verdade.", english: "We know the truth.", highlightedForm: "sabemos")
                ]
            )
        case "comer":
            return VerbExampleSet(
                commonMistake: "Using wrong endings: comamos (subjunctive) vs comemos (present)",
                mistakeExplanation: "Present: comemos. Subjunctive: comamos. Watch the vowel change.",
                examples: [
                    VerbExample(portuguese: "Eu como arroz e feijão.", english: "I eat rice and beans.", highlightedForm: "como"),
                    VerbExample(portuguese: "Ela come muito pouco.", english: "She eats very little.", highlightedForm: "come"),
                    VerbExample(portuguese: "Nós comemos juntos.", english: "We eat together.", highlightedForm: "comemos")
                ]
            )
        case "dizer":
            return VerbExampleSet(
                commonMistake: "Eu dizo (wrong) vs Eu digo (correct)",
                mistakeExplanation: "The 'eu' form changes the stem completely: digo.",
                examples: [
                    VerbExample(portuguese: "Eu sempre digo a verdade.", english: "I always tell the truth.", highlightedForm: "digo"),
                    VerbExample(portuguese: "O que ele diz?", english: "What does he say?", highlightedForm: "diz"),
                    VerbExample(portuguese: "Eles dizem que vai chover.", english: "They say it's going to rain.", highlightedForm: "dizem")
                ]
            )
        case "ver":
            return VerbExampleSet(
                commonMistake: "Confusing 'vê' (sees) with 'vê' (imperative: see!)",
                mistakeExplanation: "Context matters. 'Ele vê' = He sees. 'Vê isto!' = See this!",
                examples: [
                    VerbExample(portuguese: "Eu vejo o mar daqui.", english: "I see the sea from here.", highlightedForm: "vejo"),
                    VerbExample(portuguese: "Ela vê televisão à noite.", english: "She watches TV at night.", highlightedForm: "vê"),
                    VerbExample(portuguese: "Vocês veem aquele prédio?", english: "Do you all see that building?", highlightedForm: "veem")
                ]
            )
        case "dar":
            return VerbExampleSet(
                commonMistake: "Forgetting idiomatic uses of 'dar'",
                mistakeExplanation: "'Dar' has many idiomatic uses: 'dar para' (to be possible), 'dar-se bem' (to get along).",
                examples: [
                    VerbExample(portuguese: "Eu dou aulas de inglês.", english: "I give English classes.", highlightedForm: "dou"),
                    VerbExample(portuguese: "Ela dá um presente.", english: "She gives a gift.", highlightedForm: "dá"),
                    VerbExample(portuguese: "Não dá para ir hoje.", english: "It's not possible to go today.", highlightedForm: "dá")
                ]
            )
        case "vir":
            return VerbExampleSet(
                commonMistake: "Confusing VIR (to come) with VER (to see)",
                mistakeExplanation: "VIR: venho, vem, vimos. VER: vejo, vê, vemos. Different stems!",
                examples: [
                    VerbExample(portuguese: "Eu venho aqui todos os dias.", english: "I come here every day.", highlightedForm: "venho"),
                    VerbExample(portuguese: "Ela vem de Portugal.", english: "She comes from Portugal.", highlightedForm: "vem"),
                    VerbExample(portuguese: "Eles vêm amanhã.", english: "They come tomorrow.", highlightedForm: "vêm")
                ]
            )
        case "morar":
            return VerbExampleSet(
                commonMistake: "Confusing MORAR (to reside) with VIVER (to live/exist)",
                mistakeExplanation: "MORAR = reside at a specific place. VIVER = live (general life). 'Moro em São Paulo' vs 'Vivo feliz'.",
                examples: [
                    VerbExample(portuguese: "Eu moro no Brasil.", english: "I live in Brazil.", highlightedForm: "moro"),
                    VerbExample(portuguese: "Ela mora perto da praia.", english: "She lives near the beach.", highlightedForm: "mora"),
                    VerbExample(portuguese: "Vocês moram aqui?", english: "Do you all live here?", highlightedForm: "moram")
                ]
            )
        case "trabalhar":
            return VerbExampleSet(
                commonMistake: "Spelling: trabalhar has 'lh' not 'll'",
                mistakeExplanation: "Portuguese uses 'lh' (like 'lli' in million) where Spanish uses 'll'.",
                examples: [
                    VerbExample(portuguese: "Eu trabalho de segunda a sexta.", english: "I work Monday to Friday.", highlightedForm: "trabalho"),
                    VerbExample(portuguese: "Ela trabalha num hospital.", english: "She works in a hospital.", highlightedForm: "trabalha"),
                    VerbExample(portuguese: "Nós trabalhamos juntos.", english: "We work together.", highlightedForm: "trabalhamos")
                ]
            )
        case "estudar":
            return VerbExampleSet(
                commonMistake: "Forgetting 'estudar para' (study for) vs 'estudar' (study in general)",
                mistakeExplanation: "Use 'para' when studying for something specific: 'Estudo para o exame'.",
                examples: [
                    VerbExample(portuguese: "Eu estudo português.", english: "I study Portuguese.", highlightedForm: "estudo"),
                    VerbExample(portuguese: "Ela estuda medicina.", english: "She studies medicine.", highlightedForm: "estuda"),
                    VerbExample(portuguese: "Nós estudamos para a prova.", english: "We study for the test.", highlightedForm: "estudamos")
                ]
            )
        case "gostar":
            return VerbExampleSet(
                commonMistake: "Forgetting 'de' after gostar",
                mistakeExplanation: "Always 'gostar DE': 'Gosto de música' (not 'Gosto música').",
                examples: [
                    VerbExample(portuguese: "Eu gosto de café.", english: "I like coffee.", highlightedForm: "gosto"),
                    VerbExample(portuguese: "Ela gosta de dançar.", english: "She likes to dance.", highlightedForm: "gosta"),
                    VerbExample(portuguese: "Vocês gostam do Brasil?", english: "Do you all like Brazil?", highlightedForm: "gostam")
                ]
            )
        case "dormir":
            return VerbExampleSet(
                commonMistake: "Eu dormo (correct) — the 'o' changes to 'u' in eu form",
                mistakeExplanation: "Dormir is irregular in eu: durmo (not dormo). The stem vowel changes o→u.",
                examples: [
                    VerbExample(portuguese: "Eu durmo oito horas por noite.", english: "I sleep eight hours per night.", highlightedForm: "durmo"),
                    VerbExample(portuguese: "Ela dorme cedo.", english: "She sleeps early.", highlightedForm: "dorme"),
                    VerbExample(portuguese: "As crianças dormem bem.", english: "The children sleep well.", highlightedForm: "dormem")
                ]
            )
        case "pôr":
            return VerbExampleSet(
                commonMistake: "Forgetting the circumflex: pôr (to put) vs por (for/by)",
                mistakeExplanation: "PÔR (verb, with accent) vs POR (preposition, no accent). The accent matters!",
                examples: [
                    VerbExample(portuguese: "Eu ponho a mesa.", english: "I set the table.", highlightedForm: "ponho"),
                    VerbExample(portuguese: "Ela põe o livro na estante.", english: "She puts the book on the shelf.", highlightedForm: "põe"),
                    VerbExample(portuguese: "Nós pomos tudo no lugar.", english: "We put everything in place.", highlightedForm: "pomos")
                ]
            )
        default:
            return .empty
        }
    }
}
