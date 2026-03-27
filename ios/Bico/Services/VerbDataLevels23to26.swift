import Foundation

extension VerbDataService {
    static func buildLevels23to26() -> [Level] {
        let l23 = Level(level: 23, tense: "Pretérito Imperfeito", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "Used to speak", conjugations: .init(br: ["eu": "falava", "voce": "falava", "nos": "falávamos", "voces": "falavam", "eles": "falavam"], pt: ["eu": "falava", "tu": "falavas", "ele": "falava", "nos": "falávamos", "vos": "faláveis", "eles": "falavam"]), level: 23),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "Used to eat", conjugations: .init(br: ["eu": "comia", "voce": "comia", "nos": "comíamos", "voces": "comiam", "eles": "comiam"], pt: ["eu": "comia", "tu": "comias", "ele": "comia", "nos": "comíamos", "vos": "comíeis", "eles": "comiam"]), level: 23),
            Verb(infinitive: "Morar", translation: "To live", irregular: false, context: "Used to live", conjugations: .init(br: ["eu": "morava", "voce": "morava", "nos": "morávamos", "voces": "moravam", "eles": "moravam"], pt: ["eu": "morava", "tu": "moravas", "ele": "morava", "nos": "morávamos", "vos": "moráveis", "eles": "moravam"]), level: 23),
            Verb(infinitive: "Trabalhar", translation: "To work", irregular: false, context: "Used to work", conjugations: .init(br: ["eu": "trabalhava", "voce": "trabalhava", "nos": "trabalhávamos", "voces": "trabalhavam", "eles": "trabalhavam"], pt: ["eu": "trabalhava", "tu": "trabalhavas", "ele": "trabalhava", "nos": "trabalhávamos", "vos": "trabalháveis", "eles": "trabalhavam"]), level: 23),
            Verb(infinitive: "Estudar", translation: "To study", irregular: false, context: "Used to study", conjugations: .init(br: ["eu": "estudava", "voce": "estudava", "nos": "estudávamos", "voces": "estudavam", "eles": "estudavam"], pt: ["eu": "estudava", "tu": "estudavas", "ele": "estudava", "nos": "estudávamos", "vos": "estudáveis", "eles": "estudavam"]), level: 23)
        ])

        let l24 = Level(level: 24, tense: "Pretérito Imperfeito", verbs: [
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "Used to be", conjugations: .init(br: ["eu": "era", "voce": "era", "nos": "éramos", "voces": "eram", "eles": "eram"], pt: ["eu": "era", "tu": "eras", "ele": "era", "nos": "éramos", "vos": "éreis", "eles": "eram"]), level: 24),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Used to have", conjugations: .init(br: ["eu": "tinha", "voce": "tinha", "nos": "tínhamos", "voces": "tinham", "eles": "tinham"], pt: ["eu": "tinha", "tu": "tinhas", "ele": "tinha", "nos": "tínhamos", "vos": "tínheis", "eles": "tinham"]), level: 24),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "Used to go", conjugations: .init(br: ["eu": "ia", "voce": "ia", "nos": "íamos", "voces": "iam", "eles": "iam"], pt: ["eu": "ia", "tu": "ias", "ele": "ia", "nos": "íamos", "vos": "íeis", "eles": "iam"]), level: 24),
            Verb(infinitive: "Vir", translation: "To come", irregular: true, context: "Used to come", conjugations: .init(br: ["eu": "vinha", "voce": "vinha", "nos": "vínhamos", "voces": "vinham", "eles": "vinham"], pt: ["eu": "vinha", "tu": "vinhas", "ele": "vinha", "nos": "vínhamos", "vos": "vínheis", "eles": "vinham"]), level: 24),
            Verb(infinitive: "Pôr", translation: "To put", irregular: true, context: "Used to put", conjugations: .init(br: ["eu": "punha", "voce": "punha", "nos": "púnhamos", "voces": "punham", "eles": "punham"], pt: ["eu": "punha", "tu": "punhas", "ele": "punha", "nos": "púnhamos", "vos": "púnheis", "eles": "punham"]), level: 24)
        ])

        let l25 = Level(level: 25, tense: "Pretérito Imperfeito", verbs: [
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Used to do", conjugations: .init(br: ["eu": "fazia", "voce": "fazia", "nos": "fazíamos", "voces": "faziam", "eles": "faziam"], pt: ["eu": "fazia", "tu": "fazias", "ele": "fazia", "nos": "fazíamos", "vos": "fazíeis", "eles": "faziam"]), level: 25),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "Used to say", conjugations: .init(br: ["eu": "dizia", "voce": "dizia", "nos": "dizíamos", "voces": "diziam", "eles": "diziam"], pt: ["eu": "dizia", "tu": "dizias", "ele": "dizia", "nos": "dizíamos", "vos": "dizíeis", "eles": "diziam"]), level: 25),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "Used to want", conjugations: .init(br: ["eu": "queria", "voce": "queria", "nos": "queríamos", "voces": "queriam", "eles": "queriam"], pt: ["eu": "queria", "tu": "querias", "ele": "queria", "nos": "queríamos", "vos": "queríeis", "eles": "queriam"]), level: 25),
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "Used to be able", conjugations: .init(br: ["eu": "podia", "voce": "podia", "nos": "podíamos", "voces": "podiam", "eles": "podiam"], pt: ["eu": "podia", "tu": "podias", "ele": "podia", "nos": "podíamos", "vos": "podíeis", "eles": "podiam"]), level: 25),
            Verb(infinitive: "Saber", translation: "To know", irregular: true, context: "Used to know", conjugations: .init(br: ["eu": "sabia", "voce": "sabia", "nos": "sabíamos", "voces": "sabiam", "eles": "sabiam"], pt: ["eu": "sabia", "tu": "sabias", "ele": "sabia", "nos": "sabíamos", "vos": "sabíeis", "eles": "sabiam"]), level: 25)
        ])

        let l26 = Level(level: 26, tense: "Pretérito Imperfeito", verbs: [
            Verb(infinitive: "Dormir", translation: "To sleep", irregular: true, context: "Used to sleep", conjugations: .init(br: ["eu": "dormia", "voce": "dormia", "nos": "dormíamos", "voces": "dormiam", "eles": "dormiam"], pt: ["eu": "dormia", "tu": "dormias", "ele": "dormia", "nos": "dormíamos", "vos": "dormíeis", "eles": "dormiam"]), level: 26),
            Verb(infinitive: "Ler", translation: "To read", irregular: true, context: "Used to read", conjugations: .init(br: ["eu": "lia", "voce": "lia", "nos": "líamos", "voces": "liam", "eles": "liam"], pt: ["eu": "lia", "tu": "lias", "ele": "lia", "nos": "líamos", "vos": "líeis", "eles": "liam"]), level: 26),
            Verb(infinitive: "Ver", translation: "To see", irregular: true, context: "Used to see", conjugations: .init(br: ["eu": "via", "voce": "via", "nos": "víamos", "voces": "viam", "eles": "viam"], pt: ["eu": "via", "tu": "vias", "ele": "via", "nos": "víamos", "vos": "víeis", "eles": "viam"]), level: 26),
            Verb(infinitive: "Dar", translation: "To give", irregular: true, context: "Used to give", conjugations: .init(br: ["eu": "dava", "voce": "dava", "nos": "dávamos", "voces": "davam", "eles": "davam"], pt: ["eu": "dava", "tu": "davas", "ele": "dava", "nos": "dávamos", "vos": "dáveis", "eles": "davam"]), level: 26),
            Verb(infinitive: "Gostar", translation: "To like", irregular: false, context: "Used to like", conjugations: .init(br: ["eu": "gostava", "voce": "gostava", "nos": "gostávamos", "voces": "gostavam", "eles": "gostavam"], pt: ["eu": "gostava", "tu": "gostavas", "ele": "gostava", "nos": "gostávamos", "vos": "gostáveis", "eles": "gostavam"]), level: 26)
        ])

        return [l23, l24, l25, l26]
    }
}
