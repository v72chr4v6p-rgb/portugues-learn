import Foundation

enum LessonContentService {
    static func lessons(for level: Level, dialect: Dialect) -> [LessonPage] {
        switch level.level {
        case 1: return level1Lessons(dialect: dialect)
        case 2: return level2Lessons(dialect: dialect)
        case 3: return level3Lessons(dialect: dialect)
        case 4: return level4Lessons(dialect: dialect)
        case 5, 6: return regularVerbLessons(level: level, dialect: dialect)
        default: return genericLessons(level: level, dialect: dialect)
        }
    }

    private static func level1Lessons(dialect: Dialect) -> [LessonPage] {
        let pronounRows: [[String]]
        if dialect == .brazilian {
            pronounRows = [
                ["Eu", "I", ""],
                ["Você", "You", "Informal"],
                ["Ele/Ela", "He/She", ""],
                ["Nós", "We", ""],
                ["A gente", "We", "Colloquial"],
                ["Vocês", "You (plural)", ""],
                ["Eles/Elas", "They", ""]
            ]
        } else {
            pronounRows = [
                ["Eu", "I", ""],
                ["Tu", "You", "Informal"],
                ["Ele/Ela", "He/She", ""],
                ["Você", "You", "Formal"],
                ["Nós", "We", ""],
                ["Vós", "You (plural)", "Formal/Regional"],
                ["Eles/Elas", "They", ""]
            ]
        }

        let arEndingRows: [[String]]
        if dialect == .brazilian {
            arEndingRows = [
                ["Eu", "-o"],
                ["Você/Ele/Ela", "-a"],
                ["Nós", "-amos"],
                ["Vocês/Eles", "-am"]
            ]
        } else {
            arEndingRows = [
                ["Eu", "-o"],
                ["Tu", "-as"],
                ["Ele/Ela", "-a"],
                ["Nós", "-amos"],
                ["Vós", "-ais"],
                ["Eles/Elas", "-am"]
            ]
        }

        return [
            LessonPage(id: "1-intro", title: "Introduction to Portuguese Verbs", icon: "book.fill", blocks: [
                .heading("Welcome to Portuguese Verbs"),
                .paragraph("Portuguese verbs change their endings based on who performs the action and when it happens. This process is called conjugation."),
                .paragraph("Every Portuguese verb in its base form (the infinitive) ends in one of three patterns:"),
                .bullets([
                    "Falar is an -AR verb (to speak)",
                    "Comer is an -ER verb (to eat)",
                    "Partir is an -IR verb (to leave)"
                ]),
                .tip("The infinitive is the \"dictionary form\" of the verb — it's what you look up. In English, it's the \"to\" form: to speak, to eat, to leave."),
                .paragraph("Each verb type follows its own set of ending patterns. Once you learn the pattern for -AR verbs, you can conjugate hundreds of them!"),
                .highlight("In this level, you'll master your first regular verbs in the Present Tense.")
            ]),

            LessonPage(id: "1-types", title: "Verb Types + Endings", icon: "textformat.abc", blocks: [
                .heading("Verb Types + Endings"),
                .paragraph("Verbs are grouped by their endings (the last two letters). There are only 3 possible endings in Portuguese: -AR, -ER, and -IR. Each verb type follows a different set of rules."),
                .paragraph("For example:"),
                .bullets([
                    "Falar is an -AR verb",
                    "Comer is an -ER verb",
                    "Partir is an -IR verb"
                ]),
                .subheading("Why does this matter?"),
                .paragraph("When you conjugate a verb, you remove the -AR/-ER/-IR ending and replace it with a new ending that matches the subject. Each verb type has its own set of replacement endings."),
                .question("What type of verb is \"morar\"?"),
                .tip("Look at the last two letters: mor-AR. It's an -AR verb! Most common Portuguese verbs are -AR verbs.")
            ]),

            LessonPage(id: "1-pronouns", title: "Pronouns", icon: "person.2.fill", blocks: [
                .heading("Subject Pronouns"),
                .paragraph("Subject pronouns tell us who is performing the action. In Portuguese, verbs change their endings for each pronoun, so you often don't even need to say the pronoun — the verb form tells you who's speaking."),
                .paragraph(dialect == .brazilian
                    ? "Here are the Brazilian Portuguese subject pronouns:"
                    : "Here are the European Portuguese subject pronouns:"),
                .table(
                    headers: ["Portuguese", "English", "Notes"],
                    rows: pronounRows
                ),
                .tip(dialect == .brazilian
                    ? "In Brazil, \"você\" is standard for \"you.\" \"Tu\" is used in some regions but often with \"você\" conjugation."
                    : "In Portugal, \"tu\" is the standard informal \"you.\" \"Você\" is more formal and uses the third-person conjugation.")
            ]),

            LessonPage(id: "1-conjugation", title: "Conjugating -AR Verbs", icon: "text.badge.checkmark", blocks: [
                .heading("Conjugating -AR Verbs in the Present Tense"),
                .paragraph("Let's conjugate \"falar\" (to speak), a regular -AR verb in the Present Tense."),
                .paragraph("First, here are the -AR endings for the Present Tense:"),
                .table(
                    headers: ["Pronoun", "-AR endings"],
                    rows: arEndingRows
                ),
                .subheading("Now conjugate Falar"),
                .steps([
                    "Take the infinitive: falar",
                    "Remove the -AR ending → fal-",
                    "Add the Present Tense -AR endings"
                ]),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "falo"], ["Você", "fala"], ["Nós", "falamos"], ["Vocês", "falam"]]
                        : [["Eu", "falo"], ["Tu", "falas"], ["Ele/Ela", "fala"], ["Nós", "falamos"], ["Vós", "falais"], ["Eles", "falam"]]
                ),
                .tip("This same pattern works for ALL regular -AR verbs. Learn it once, use it everywhere!")
            ]),

            LessonPage(id: "1-vocab", title: "Level Vocabulary", icon: "list.bullet.rectangle.portrait", blocks: [
                .heading("Verbs in This Level"),
                .paragraph("Here are the verbs you'll practice in this level:"),
                .table(
                    headers: ["Verb", "Translation", "Type"],
                    rows: [
                        ["Falar", "To speak", "Regular -AR"],
                        ["Comer", "To eat", "Regular -ER"],
                        ["Morar", "To live/reside", "Regular -AR"],
                        ["Trabalhar", "To work", "Regular -AR"]
                    ]
                ),
                .subheading("Context"),
                .bullets([
                    "Falar — Used for general conversation and language ability",
                    "Comer — Used for food and meals",
                    "Morar — Used when talking about where you live",
                    "Trabalhar — Used for jobs and professions"
                ]),
                .highlight("Now practice conjugating these verbs with each pronoun!")
            ])
        ]
    }

    private static func level2Lessons(dialect: Dialect) -> [LessonPage] {
        return [
            LessonPage(id: "2-intro", title: "Irregular Verbs", icon: "exclamationmark.triangle.fill", blocks: [
                .heading("Introduction to Irregular Verbs"),
                .paragraph("Some of the most common Portuguese verbs don't follow the regular conjugation patterns. These are called irregular verbs."),
                .paragraph("The good news? Because they're so common, you'll hear and use them constantly, making them easier to memorize through practice."),
                .tip("Don't try to find patterns in irregular verbs — just memorize them through repetition. They'll become second nature quickly.")
            ]),

            LessonPage(id: "2-servsestsar", title: "Ser vs Estar", icon: "arrow.left.arrow.right", blocks: [
                .heading("Ser vs Estar"),
                .paragraph("Portuguese has two verbs for \"to be\" — and knowing when to use each one is essential."),
                .subheading("SER — Permanent/Essential"),
                .bullets([
                    "Identity: Eu sou brasileiro (I am Brazilian)",
                    "Profession: Ela é médica (She is a doctor)",
                    "Origin: Nós somos de Lisboa (We are from Lisbon)",
                    "Characteristics: O livro é interessante (The book is interesting)"
                ]),
                .subheading("ESTAR — Temporary/State"),
                .bullets([
                    "Location: Eu estou em casa (I am at home)",
                    "Mood: Ela está feliz (She is happy)",
                    "Health: Nós estamos doentes (We are sick)",
                    "Condition: A porta está aberta (The door is open)"
                ]),
                .tip("Think of SER as \"what something IS\" and ESTAR as \"how something IS right now.\"")
            ]),

            LessonPage(id: "2-conjugation", title: "Conjugation Tables", icon: "tablecells", blocks: [
                .heading("Key Irregular Verbs"),
                .subheading("Ser (To be — permanent)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "sou"], ["Você", "é"], ["Nós", "somos"], ["Vocês", "são"]]
                        : [["Eu", "sou"], ["Tu", "és"], ["Ele/Ela", "é"], ["Nós", "somos"], ["Vós", "sois"], ["Eles", "são"]]
                ),
                .subheading("Estar (To be — temporary)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "estou"], ["Você", "está"], ["Nós", "estamos"], ["Vocês", "estão"]]
                        : [["Eu", "estou"], ["Tu", "estás"], ["Ele/Ela", "está"], ["Nós", "estamos"], ["Vós", "estais"], ["Eles", "estão"]]
                ),
                .subheading("Ter (To have)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "tenho"], ["Você", "tem"], ["Nós", "temos"], ["Vocês", "têm"]]
                        : [["Eu", "tenho"], ["Tu", "tens"], ["Ele/Ela", "tem"], ["Nós", "temos"], ["Vós", "tendes"], ["Eles", "têm"]]
                ),
                .subheading("Ir (To go)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "vou"], ["Você", "vai"], ["Nós", "vamos"], ["Vocês", "vão"]]
                        : [["Eu", "vou"], ["Tu", "vais"], ["Ele/Ela", "vai"], ["Nós", "vamos"], ["Vós", "ides"], ["Eles", "vão"]]
                )
            ]),

            LessonPage(id: "2-vocab", title: "Level Vocabulary", icon: "list.bullet.rectangle.portrait", blocks: [
                .heading("Verbs in This Level"),
                .table(
                    headers: ["Verb", "Translation", "Type"],
                    rows: [
                        ["Ser", "To be (permanent)", "Irregular"],
                        ["Estar", "To be (temporary)", "Irregular"],
                        ["Ter", "To have", "Irregular"],
                        ["Ir", "To go", "Irregular"]
                    ]
                ),
                .highlight("These four verbs are among the most used in Portuguese. Master them and you'll understand a huge portion of everyday speech!")
            ])
        ]
    }

    private static func level3Lessons(dialect: Dialect) -> [LessonPage] {
        return [
            LessonPage(id: "3-intro", title: "Power Verbs", icon: "bolt.fill", blocks: [
                .heading("Essential Power Verbs"),
                .paragraph("These four irregular verbs are incredibly versatile. They appear in countless expressions and are essential for fluency."),
                .bullets([
                    "Fazer — To do/make (actions and creation)",
                    "Poder — To be able/can (ability and permission)",
                    "Querer — To want (desires and wishes)",
                    "Saber — To know (facts and skills)"
                ]),
                .tip("\"Saber\" means to know facts or how to do something. For knowing people or places, Portuguese uses \"conhecer.\"")
            ]),

            LessonPage(id: "3-conjugation", title: "Conjugation Tables", icon: "tablecells", blocks: [
                .heading("Conjugation Patterns"),
                .subheading("Fazer (To do/make)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "faço"], ["Você", "faz"], ["Nós", "fazemos"], ["Vocês", "fazem"]]
                        : [["Eu", "faço"], ["Tu", "fazes"], ["Ele/Ela", "faz"], ["Nós", "fazemos"], ["Vós", "fazeis"], ["Eles", "fazem"]]
                ),
                .subheading("Poder (To be able/can)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "posso"], ["Você", "pode"], ["Nós", "podemos"], ["Vocês", "podem"]]
                        : [["Eu", "posso"], ["Tu", "podes"], ["Ele/Ela", "pode"], ["Nós", "podemos"], ["Vós", "podeis"], ["Eles", "podem"]]
                ),
                .subheading("Querer (To want)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "quero"], ["Você", "quer"], ["Nós", "queremos"], ["Vocês", "querem"]]
                        : [["Eu", "quero"], ["Tu", "queres"], ["Ele/Ela", "quer"], ["Nós", "queremos"], ["Vós", "quereis"], ["Eles", "querem"]]
                ),
                .subheading("Saber (To know)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "sei"], ["Você", "sabe"], ["Nós", "sabemos"], ["Vocês", "sabem"]]
                        : [["Eu", "sei"], ["Tu", "sabes"], ["Ele/Ela", "sabe"], ["Nós", "sabemos"], ["Vós", "sabeis"], ["Eles", "sabem"]]
                )
            ]),

            LessonPage(id: "3-vocab", title: "Level Vocabulary", icon: "list.bullet.rectangle.portrait", blocks: [
                .heading("Verbs in This Level"),
                .table(
                    headers: ["Verb", "Translation", "Type"],
                    rows: [
                        ["Fazer", "To do/make", "Irregular"],
                        ["Poder", "To be able/can", "Irregular"],
                        ["Querer", "To want", "Irregular"],
                        ["Saber", "To know (facts)", "Irregular"]
                    ]
                ),
                .highlight("Notice how \"eu\" forms often have unique changes (faço, posso, sei) while other forms are more predictable.")
            ])
        ]
    }

    private static func level4Lessons(dialect: Dialect) -> [LessonPage] {
        return [
            LessonPage(id: "4-intro", title: "Communication Verbs", icon: "bubble.left.and.bubble.right.fill", blocks: [
                .heading("Verbs of Communication & Movement"),
                .paragraph("This level covers four essential irregular verbs used in everyday conversation."),
                .bullets([
                    "Dizer — To say/tell",
                    "Ver — To see",
                    "Dar — To give",
                    "Vir — To come"
                ]),
                .tip("Don't confuse \"vir\" (to come) with \"ir\" (to go). They sound similar but have very different conjugations!")
            ]),

            LessonPage(id: "4-conjugation", title: "Conjugation Tables", icon: "tablecells", blocks: [
                .heading("Conjugation Patterns"),
                .subheading("Dizer (To say/tell)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "digo"], ["Você", "diz"], ["Nós", "dizemos"], ["Vocês", "dizem"]]
                        : [["Eu", "digo"], ["Tu", "dizes"], ["Ele/Ela", "diz"], ["Nós", "dizemos"], ["Vós", "dizeis"], ["Eles", "dizem"]]
                ),
                .subheading("Ver (To see)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "vejo"], ["Você", "vê"], ["Nós", "vemos"], ["Vocês", "veem"]]
                        : [["Eu", "vejo"], ["Tu", "vês"], ["Ele/Ela", "vê"], ["Nós", "vemos"], ["Vós", "vedes"], ["Eles", "veem"]]
                ),
                .subheading("Dar (To give)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "dou"], ["Você", "dá"], ["Nós", "damos"], ["Vocês", "dão"]]
                        : [["Eu", "dou"], ["Tu", "dás"], ["Ele/Ela", "dá"], ["Nós", "damos"], ["Vós", "dais"], ["Eles", "dão"]]
                ),
                .subheading("Vir (To come)"),
                .table(
                    headers: ["Pronoun", "Conjugation"],
                    rows: dialect == .brazilian
                        ? [["Eu", "venho"], ["Você", "vem"], ["Nós", "vimos"], ["Vocês", "vêm"]]
                        : [["Eu", "venho"], ["Tu", "vens"], ["Ele/Ela", "vem"], ["Nós", "vimos"], ["Vós", "vindes"], ["Eles", "vêm"]]
                )
            ]),

            LessonPage(id: "4-vocab", title: "Level Vocabulary", icon: "list.bullet.rectangle.portrait", blocks: [
                .heading("Verbs in This Level"),
                .table(
                    headers: ["Verb", "Translation", "Type"],
                    rows: [
                        ["Dizer", "To say/tell", "Irregular"],
                        ["Ver", "To see", "Irregular"],
                        ["Dar", "To give", "Irregular"],
                        ["Vir", "To come", "Irregular"]
                    ]
                )
            ])
        ]
    }

    private static func regularVerbLessons(level: Level, dialect: Dialect) -> [LessonPage] {
        let verbRows = level.verbs.map { [$0.infinitive, $0.translation, $0.irregular ? "Irregular" : "Regular"] }
        let verbEnding = level.verbs.first.map { v -> String in
            let inf = v.infinitive.lowercased()
            if inf.hasSuffix("ar") { return "-AR" }
            if inf.hasSuffix("er") { return "-ER" }
            if inf.hasSuffix("ir") { return "-IR" }
            return ""
        } ?? ""

        var pages: [LessonPage] = [
            LessonPage(id: "\(level.level)-intro", title: "Introduction", icon: "book.fill", blocks: [
                .heading("More \(level.tense) Verbs"),
                .paragraph("In this level, you'll practice conjugating more verbs in the \(level.tense). These verbs are commonly used in everyday Portuguese."),
                .paragraph("Remember the conjugation steps:"),
                .steps([
                    "Take the infinitive form of the verb",
                    "Remove the \(verbEnding) ending to get the stem",
                    "Add the correct ending for the pronoun"
                ]),
                .tip("Regular verbs always follow the same pattern. Once you know the endings, you can conjugate any regular verb!")
            ])
        ]

        for verb in level.verbs {
            let conjugations = verb.conjugations.forDialect(dialect)
            let rows = conjugations.sorted(by: { $0.key < $1.key }).compactMap { key, value -> [String]? in
                guard let pronoun = Pronoun(rawValue: key) else { return nil }
                return [pronoun.displayName, value]
            }
            pages.append(LessonPage(id: "\(level.level)-\(verb.infinitive.lowercased())", title: verb.infinitive, icon: "text.badge.checkmark", blocks: [
                .heading("Conjugating \(verb.infinitive)"),
                .paragraph("\(verb.infinitive) means \"\(verb.translation.lowercased())\". \(verb.context)."),
                .table(headers: ["Pronoun", "Conjugation"], rows: rows),
                verb.irregular ? .tip("This is an irregular verb — memorize its unique forms!") : .tip("This is a regular verb — it follows the standard pattern.")
            ]))
        }

        pages.append(LessonPage(id: "\(level.level)-vocab", title: "Level Vocabulary", icon: "list.bullet.rectangle.portrait", blocks: [
            .heading("Verbs in This Level"),
            .table(headers: ["Verb", "Translation", "Type"], rows: verbRows),
            .highlight("Practice each verb with every pronoun to build your conjugation speed!")
        ]))

        return pages
    }

    private static func genericLessons(level: Level, dialect: Dialect) -> [LessonPage] {
        var pages: [LessonPage] = []

        pages.append(tenseIntroPage(level: level, dialect: dialect))

        if level.verbs.count > 1 {
            pages.append(conjugationOverviewPage(level: level, dialect: dialect))
        }

        for verb in level.verbs {
            let conjugations = verb.conjugations.forDialect(dialect)
            let rows = conjugations.sorted(by: { $0.key < $1.key }).compactMap { key, value -> [String]? in
                guard let pronoun = Pronoun(rawValue: key) else { return nil }
                return [pronoun.displayName, value]
            }
            pages.append(LessonPage(id: "\(level.level)-\(verb.infinitive.lowercased())", title: verb.infinitive, icon: "text.badge.checkmark", blocks: [
                .heading("\(verb.infinitive) — \(level.tense)"),
                .paragraph("\(verb.infinitive) (\(verb.translation.lowercased())). \(verb.context)."),
                .table(headers: ["Pronoun", "\(level.tense)"], rows: rows),
                verb.irregular ? .tip("Irregular verb — pay attention to the stem changes.") : .tip("Regular verb — follows the standard \(level.tense) pattern.")
            ]))
        }

        pages.append(LessonPage(id: "\(level.level)-vocab", title: "Vocabulary", icon: "list.bullet.rectangle.portrait", blocks: [
            .heading("Verbs in This Level"),
            .table(
                headers: ["Verb", "Translation", "Type"],
                rows: level.verbs.map { [$0.infinitive, $0.translation, $0.irregular ? "Irregular" : "Regular"] }
            ),
            .highlight("Now practice these verbs!")
        ]))

        return pages
    }

    private static let tenseDescriptions: [String: (title: String, description: String, usage: [String], dialectNote: (br: String, pt: String)?)] = [
        "Presente": (
            title: "The Present Tense",
            description: "The Present Tense (Presente) is used for actions happening now, habitual actions, and general truths.",
            usage: ["Habitual actions: Eu falo português (I speak Portuguese)", "Current states: Ela mora em Lisboa (She lives in Lisbon)", "General truths: A Terra gira (The Earth spins)"],
            dialectNote: nil
        ),
        "Presente Contínuo": (
            title: "The Present Continuous",
            description: "The Present Continuous describes actions happening right now, at this very moment.",
            usage: ["Current actions: I am speaking", "Temporary situations: She is living in Brazil"],
            dialectNote: (br: "In Brazil, use estar + gerund (-ando, -endo, -indo): Estou falando.", pt: "In Portugal, use estar + a + infinitive: Estou a falar.")
        ),
        "Reflexivos": (
            title: "Reflexive Verbs",
            description: "Reflexive verbs indicate that the subject performs an action on themselves. They use reflexive pronouns (me, te, se, nos, vos, se).",
            usage: ["Vestir-se — to get dressed (dress oneself)", "Lavar-se — to wash oneself", "Sentar-se — to sit down"],
            dialectNote: (br: "In Brazil, the pronoun usually goes before the verb: Eu me visto.", pt: "In Portugal, the pronoun goes after the verb with a hyphen: Visto-me.")
        ),
        "Pretérito Perfeito": (
            title: "The Simple Past (Pretérito Perfeito)",
            description: "The Pretérito Perfeito is used for completed actions in the past — things that happened once and are finished.",
            usage: ["Single completed action: Eu falei com ela (I spoke with her)", "Sequential events: Ele chegou e sentou (He arrived and sat down)"],
            dialectNote: nil
        ),
        "Pretérito Imperfeito": (
            title: "The Imperfect Past (Pretérito Imperfeito)",
            description: "The Imperfeito describes ongoing, habitual, or repeated actions in the past. Think of it as \"used to\" or \"was doing.\"",
            usage: ["Habitual past: Eu falava com ela todos os dias (I used to speak with her every day)", "Background description: O sol brilhava (The sun was shining)", "Past states: Ele era jovem (He was young)"],
            dialectNote: nil
        ),
        "Futuro": (
            title: "The Future Tense",
            description: "The Futuro Simples expresses actions that will happen in the future. It's formed by adding endings to the full infinitive.",
            usage: ["Predictions: Amanhã chovará (Tomorrow it will rain)", "Promises: Eu falarei com ele (I will speak with him)"],
            dialectNote: (br: "In spoken Brazilian Portuguese, \"ir + infinitive\" is much more common: Eu vou falar.", pt: "The simple future is used in formal writing and some spoken contexts.")
        ),
        "Condicional": (
            title: "The Conditional",
            description: "The Conditional expresses hypothetical situations, polite requests, and what would happen under certain conditions.",
            usage: ["Hypothetical: Eu falaria se pudesse (I would speak if I could)", "Polite requests: Você poderia ajudar? (Could you help?)", "Wishes: Eu gostaria de ir (I would like to go)"],
            dialectNote: nil
        ),
        "Infinitivo Pessoal": (
            title: "The Personal Infinitive",
            description: "The Personal Infinitive (Infinitivo Pessoal) is unique to Portuguese! It's an infinitive that conjugates — it has different forms for different subjects.",
            usage: ["After prepositions: Para nós falarmos (For us to speak)", "When subjects differ: É importante eles saberem (It's important for them to know)"],
            dialectNote: nil
        ),
        "Presente do Subjuntivo": (
            title: "The Present Subjunctive",
            description: "The Subjunctive mood expresses wishes, doubts, emotions, possibilities, and hypothetical situations. It's triggered by certain expressions.",
            usage: ["Wishes: Espero que ele fale (I hope he speaks)", "Doubt: Duvido que ela saiba (I doubt she knows)", "Emotion: Fico feliz que vocês venham (I'm happy you're coming)"],
            dialectNote: nil
        ),
        "Futuro do Subjuntivo": (
            title: "The Future Subjunctive",
            description: "The Future Subjunctive is unique to Portuguese (and a few other Romance languages). It expresses future uncertainty or conditions.",
            usage: ["Conditions: Quando eu falar (When I speak)", "Uncertainty: Se ele vier (If he comes)", "General: Quem quiser (Whoever wants to)"],
            dialectNote: nil
        ),
        "Imperfeito do Subjuntivo": (
            title: "The Imperfect Subjunctive",
            description: "The Imperfect Subjunctive is used for past hypothetical situations, wishes about the past, and polite suggestions.",
            usage: ["Past hypothetical: Se eu falasse (If I spoke)", "Wishes: Queria que ele viesse (I wished he would come)", "Conditions: Se pudesse, iria (If I could, I would go)"],
            dialectNote: nil
        ),
        "Imperativo": (
            title: "The Imperative",
            description: "The Imperative mood is used for commands, instructions, and requests. It tells someone to do something.",
            usage: ["Commands: Fale! (Speak!)", "Instructions: Abra o livro (Open the book)", "Requests: Por favor, venha aqui (Please, come here)"],
            dialectNote: (br: "In Brazil, imperative forms often use the \"você\" conjugation.", pt: "In Portugal, commands to \"tu\" use a specific imperative form, often matching the present tense without the -s.")
        ),
        "Revisão Final": (
            title: "Final Review",
            description: "Congratulations on reaching the summit! This final review covers the most important verbs across all tenses you've learned.",
            usage: ["Review all tense patterns", "Test your mastery of irregular verbs", "Solidify your conjugation skills"],
            dialectNote: nil
        )
    ]

    private static func tenseIntroPage(level: Level, dialect: Dialect) -> LessonPage {
        let info = tenseDescriptions[level.tense]

        var blocks: [ContentBlock] = [
            .heading(info?.title ?? level.tense),
            .paragraph(info?.description ?? "Learn to conjugate verbs in the \(level.tense)."),
            .subheading("When to Use It"),
            .bullets(info?.usage ?? ["Practice conjugating in this tense"])
        ]

        if let note = info?.dialectNote {
            let dialectText = dialect == .brazilian ? note.br : note.pt
            blocks.append(.tip(dialectText))
        }

        return LessonPage(id: "\(level.level)-intro", title: "Introduction", icon: "book.fill", blocks: blocks)
    }

    private static func conjugationOverviewPage(level: Level, dialect: Dialect) -> LessonPage {
        var blocks: [ContentBlock] = [
            .heading("Conjugation Overview")
        ]

        for verb in level.verbs.prefix(3) {
            let conjugations = verb.conjugations.forDialect(dialect)
            let rows = conjugations.sorted(by: { $0.key < $1.key }).compactMap { key, value -> [String]? in
                guard let pronoun = Pronoun(rawValue: key) else { return nil }
                return [pronoun.displayName, value]
            }
            blocks.append(.subheading("\(verb.infinitive) (\(verb.translation))"))
            blocks.append(.table(headers: ["Pronoun", "\(level.tense)"], rows: rows))
        }

        return LessonPage(id: "\(level.level)-overview", title: "Conjugation Overview", icon: "tablecells", blocks: blocks)
    }
}
