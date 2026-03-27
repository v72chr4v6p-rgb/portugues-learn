import Foundation

extension VerbDataService {
    static func buildLevels27to32() -> [Level] {
        let l27 = Level(level: 27, tense: "Futuro", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "Will speak", conjugations: .init(br: ["eu": "falarei", "voce": "falará", "nos": "falaremos", "voces": "falarão", "eles": "falarão"], pt: ["eu": "falarei", "tu": "falarás", "ele": "falará", "nos": "falaremos", "vos": "falareis", "eles": "falarão"]), level: 27),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "Will eat", conjugations: .init(br: ["eu": "comerei", "voce": "comerá", "nos": "comeremos", "voces": "comerão", "eles": "comerão"], pt: ["eu": "comerei", "tu": "comerás", "ele": "comerá", "nos": "comeremos", "vos": "comereis", "eles": "comerão"]), level: 27),
            Verb(infinitive: "Partir", translation: "To leave", irregular: false, context: "Will leave", conjugations: .init(br: ["eu": "partirei", "voce": "partirá", "nos": "partiremos", "voces": "partirão", "eles": "partirão"], pt: ["eu": "partirei", "tu": "partirás", "ele": "partirá", "nos": "partiremos", "vos": "partireis", "eles": "partirão"]), level: 27),
            Verb(infinitive: "Trabalhar", translation: "To work", irregular: false, context: "Will work", conjugations: .init(br: ["eu": "trabalharei", "voce": "trabalhará", "nos": "trabalharemos", "voces": "trabalharão", "eles": "trabalharão"], pt: ["eu": "trabalharei", "tu": "trabalharás", "ele": "trabalhará", "nos": "trabalharemos", "vos": "trabalhareis", "eles": "trabalharão"]), level: 27),
            Verb(infinitive: "Viajar", translation: "To travel", irregular: false, context: "Will travel", conjugations: .init(br: ["eu": "viajarei", "voce": "viajará", "nos": "viajaremos", "voces": "viajarão", "eles": "viajarão"], pt: ["eu": "viajarei", "tu": "viajarás", "ele": "viajará", "nos": "viajaremos", "vos": "viajareis", "eles": "viajarão"]), level: 27)
        ])

        let l28 = Level(level: 28, tense: "Futuro", verbs: [
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "Will be", conjugations: .init(br: ["eu": "serei", "voce": "será", "nos": "seremos", "voces": "serão", "eles": "serão"], pt: ["eu": "serei", "tu": "serás", "ele": "será", "nos": "seremos", "vos": "sereis", "eles": "serão"]), level: 28),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Will have", conjugations: .init(br: ["eu": "terei", "voce": "terá", "nos": "teremos", "voces": "terão", "eles": "terão"], pt: ["eu": "terei", "tu": "terás", "ele": "terá", "nos": "teremos", "vos": "tereis", "eles": "terão"]), level: 28),
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Will do", conjugations: .init(br: ["eu": "farei", "voce": "fará", "nos": "faremos", "voces": "farão", "eles": "farão"], pt: ["eu": "farei", "tu": "farás", "ele": "fará", "nos": "faremos", "vos": "fareis", "eles": "farão"]), level: 28),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "Will say", conjugations: .init(br: ["eu": "direi", "voce": "dirá", "nos": "diremos", "voces": "dirão", "eles": "dirão"], pt: ["eu": "direi", "tu": "dirás", "ele": "dirá", "nos": "diremos", "vos": "direis", "eles": "dirão"]), level: 28),
            Verb(infinitive: "Trazer", translation: "To bring", irregular: true, context: "Will bring", conjugations: .init(br: ["eu": "trarei", "voce": "trará", "nos": "traremos", "voces": "trarão", "eles": "trarão"], pt: ["eu": "trarei", "tu": "trarás", "ele": "trará", "nos": "traremos", "vos": "trareis", "eles": "trarão"]), level: 28)
        ])

        let l29 = Level(level: 29, tense: "Futuro", verbs: [
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "Will be able", conjugations: .init(br: ["eu": "poderei", "voce": "poderá", "nos": "poderemos", "voces": "poderão", "eles": "poderão"], pt: ["eu": "poderei", "tu": "poderás", "ele": "poderá", "nos": "poderemos", "vos": "podereis", "eles": "poderão"]), level: 29),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "Will want", conjugations: .init(br: ["eu": "quererei", "voce": "quererá", "nos": "quereremos", "voces": "quererão", "eles": "quererão"], pt: ["eu": "quererei", "tu": "quererás", "ele": "quererá", "nos": "quereremos", "vos": "querereis", "eles": "quererão"]), level: 29),
            Verb(infinitive: "Saber", translation: "To know", irregular: true, context: "Will know", conjugations: .init(br: ["eu": "saberei", "voce": "saberá", "nos": "saberemos", "voces": "saberão", "eles": "saberão"], pt: ["eu": "saberei", "tu": "saberás", "ele": "saberá", "nos": "saberemos", "vos": "sabereis", "eles": "saberão"]), level: 29),
            Verb(infinitive: "Ver", translation: "To see", irregular: true, context: "Will see", conjugations: .init(br: ["eu": "verei", "voce": "verá", "nos": "veremos", "voces": "verão", "eles": "verão"], pt: ["eu": "verei", "tu": "verás", "ele": "verá", "nos": "veremos", "vos": "vereis", "eles": "verão"]), level: 29),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "Will go", conjugations: .init(br: ["eu": "irei", "voce": "irá", "nos": "iremos", "voces": "irão", "eles": "irão"], pt: ["eu": "irei", "tu": "irás", "ele": "irá", "nos": "iremos", "vos": "ireis", "eles": "irão"]), level: 29)
        ])

        let l30 = Level(level: 30, tense: "Condicional", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "Would speak", conjugations: .init(br: ["eu": "falaria", "voce": "falaria", "nos": "falaríamos", "voces": "falariam", "eles": "falariam"], pt: ["eu": "falaria", "tu": "falarias", "ele": "falaria", "nos": "falaríamos", "vos": "falaríeis", "eles": "falariam"]), level: 30),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "Would eat", conjugations: .init(br: ["eu": "comeria", "voce": "comeria", "nos": "comeríamos", "voces": "comeriam", "eles": "comeriam"], pt: ["eu": "comeria", "tu": "comerias", "ele": "comeria", "nos": "comeríamos", "vos": "comeríeis", "eles": "comeriam"]), level: 30),
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "Would be", conjugations: .init(br: ["eu": "seria", "voce": "seria", "nos": "seríamos", "voces": "seriam", "eles": "seriam"], pt: ["eu": "seria", "tu": "serias", "ele": "seria", "nos": "seríamos", "vos": "seríeis", "eles": "seriam"]), level: 30),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Would have", conjugations: .init(br: ["eu": "teria", "voce": "teria", "nos": "teríamos", "voces": "teriam", "eles": "teriam"], pt: ["eu": "teria", "tu": "terias", "ele": "teria", "nos": "teríamos", "vos": "teríeis", "eles": "teriam"]), level: 30),
            Verb(infinitive: "Gostar", translation: "To like", irregular: false, context: "Would like", conjugations: .init(br: ["eu": "gostaria", "voce": "gostaria", "nos": "gostaríamos", "voces": "gostariam", "eles": "gostariam"], pt: ["eu": "gostaria", "tu": "gostarias", "ele": "gostaria", "nos": "gostaríamos", "vos": "gostaríeis", "eles": "gostariam"]), level: 30)
        ])

        let l31 = Level(level: 31, tense: "Condicional", verbs: [
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "Could", conjugations: .init(br: ["eu": "poderia", "voce": "poderia", "nos": "poderíamos", "voces": "poderiam", "eles": "poderiam"], pt: ["eu": "poderia", "tu": "poderias", "ele": "poderia", "nos": "poderíamos", "vos": "poderíeis", "eles": "poderiam"]), level: 31),
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Would do", conjugations: .init(br: ["eu": "faria", "voce": "faria", "nos": "faríamos", "voces": "fariam", "eles": "fariam"], pt: ["eu": "faria", "tu": "farias", "ele": "faria", "nos": "faríamos", "vos": "faríeis", "eles": "fariam"]), level: 31),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "Would say", conjugations: .init(br: ["eu": "diria", "voce": "diria", "nos": "diríamos", "voces": "diriam", "eles": "diriam"], pt: ["eu": "diria", "tu": "dirias", "ele": "diria", "nos": "diríamos", "vos": "diríeis", "eles": "diriam"]), level: 31),
            Verb(infinitive: "Trazer", translation: "To bring", irregular: true, context: "Would bring", conjugations: .init(br: ["eu": "traria", "voce": "traria", "nos": "traríamos", "voces": "trariam", "eles": "trariam"], pt: ["eu": "traria", "tu": "trarias", "ele": "traria", "nos": "traríamos", "vos": "traríeis", "eles": "trariam"]), level: 31),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "Would want", conjugations: .init(br: ["eu": "quereria", "voce": "quereria", "nos": "quereríamos", "voces": "quereriam", "eles": "quereriam"], pt: ["eu": "quereria", "tu": "quererias", "ele": "quereria", "nos": "quereríamos", "vos": "quereríeis", "eles": "quereriam"]), level: 31)
        ])

        let l32 = Level(level: 32, tense: "Infinitivo Pessoal", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "Personal infinitive", conjugations: .init(br: ["eu": "falar", "voce": "falar", "nos": "falarmos", "voces": "falarem", "eles": "falarem"], pt: ["eu": "falar", "tu": "falares", "ele": "falar", "nos": "falarmos", "vos": "falardes", "eles": "falarem"]), level: 32),
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "Personal infinitive", conjugations: .init(br: ["eu": "ser", "voce": "ser", "nos": "sermos", "voces": "serem", "eles": "serem"], pt: ["eu": "ser", "tu": "seres", "ele": "ser", "nos": "sermos", "vos": "serdes", "eles": "serem"]), level: 32),
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Personal infinitive", conjugations: .init(br: ["eu": "fazer", "voce": "fazer", "nos": "fazermos", "voces": "fazerem", "eles": "fazerem"], pt: ["eu": "fazer", "tu": "fazeres", "ele": "fazer", "nos": "fazermos", "vos": "fazerdes", "eles": "fazerem"]), level: 32),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Personal infinitive", conjugations: .init(br: ["eu": "ter", "voce": "ter", "nos": "termos", "voces": "terem", "eles": "terem"], pt: ["eu": "ter", "tu": "teres", "ele": "ter", "nos": "termos", "vos": "terdes", "eles": "terem"]), level: 32),
            Verb(infinitive: "Saber", translation: "To know", irregular: true, context: "Personal infinitive", conjugations: .init(br: ["eu": "saber", "voce": "saber", "nos": "sabermos", "voces": "saberem", "eles": "saberem"], pt: ["eu": "saber", "tu": "saberes", "ele": "saber", "nos": "sabermos", "vos": "saberdes", "eles": "saberem"]), level: 32)
        ])

        return [l27, l28, l29, l30, l31, l32]
    }
}
