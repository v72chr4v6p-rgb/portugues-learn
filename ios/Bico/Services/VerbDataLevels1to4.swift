import Foundation

extension VerbDataService {
    static func buildLevels1to4() -> [Level] {
        let l1 = Level(level: 1, tense: "Presente", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "General conversation", conjugations: .init(br: ["eu": "falo", "voce": "fala", "nos": "falamos", "voces": "falam", "eles": "falam"], pt: ["eu": "falo", "tu": "falas", "ele": "fala", "nos": "falamos", "vos": "falais", "eles": "falam"]), level: 1),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "Food and meals", conjugations: .init(br: ["eu": "como", "voce": "come", "nos": "comemos", "voces": "comem", "eles": "comem"], pt: ["eu": "como", "tu": "comes", "ele": "come", "nos": "comemos", "vos": "comeis", "eles": "comem"]), level: 1),
            Verb(infinitive: "Morar", translation: "To live/reside", irregular: false, context: "Where you live", conjugations: .init(br: ["eu": "moro", "voce": "mora", "nos": "moramos", "voces": "moram", "eles": "moram"], pt: ["eu": "moro", "tu": "moras", "ele": "mora", "nos": "moramos", "vos": "morais", "eles": "moram"]), level: 1),
            Verb(infinitive: "Trabalhar", translation: "To work", irregular: false, context: "Jobs and professions", conjugations: .init(br: ["eu": "trabalho", "voce": "trabalha", "nos": "trabalhamos", "voces": "trabalham", "eles": "trabalham"], pt: ["eu": "trabalho", "tu": "trabalhas", "ele": "trabalha", "nos": "trabalhamos", "vos": "trabalhais", "eles": "trabalham"]), level: 1),
            Verb(infinitive: "Andar", translation: "To walk", irregular: false, context: "Movement on foot", conjugations: .init(br: ["eu": "ando", "voce": "anda", "nos": "andamos", "voces": "andam", "eles": "andam"], pt: ["eu": "ando", "tu": "andas", "ele": "anda", "nos": "andamos", "vos": "andais", "eles": "andam"]), level: 1),
            Verb(infinitive: "Chamar", translation: "To call", irregular: false, context: "Names and calling", conjugations: .init(br: ["eu": "chamo", "voce": "chama", "nos": "chamamos", "voces": "chamam", "eles": "chamam"], pt: ["eu": "chamo", "tu": "chamas", "ele": "chama", "nos": "chamamos", "vos": "chamais", "eles": "chamam"]), level: 1)
        ])

        let l2 = Level(level: 2, tense: "Presente", verbs: [
            Verb(infinitive: "Ser", translation: "To be (permanent)", irregular: true, context: "Identity and characteristics", conjugations: .init(br: ["eu": "sou", "voce": "é", "nos": "somos", "voces": "são", "eles": "são"], pt: ["eu": "sou", "tu": "és", "ele": "é", "nos": "somos", "vos": "sois", "eles": "são"]), level: 2),
            Verb(infinitive: "Estar", translation: "To be (temporary)", irregular: true, context: "States and locations", conjugations: .init(br: ["eu": "estou", "voce": "está", "nos": "estamos", "voces": "estão", "eles": "estão"], pt: ["eu": "estou", "tu": "estás", "ele": "está", "nos": "estamos", "vos": "estais", "eles": "estão"]), level: 2),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Possession and obligations", conjugations: .init(br: ["eu": "tenho", "voce": "tem", "nos": "temos", "voces": "têm", "eles": "têm"], pt: ["eu": "tenho", "tu": "tens", "ele": "tem", "nos": "temos", "vos": "tendes", "eles": "têm"]), level: 2),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "Movement and future plans", conjugations: .init(br: ["eu": "vou", "voce": "vai", "nos": "vamos", "voces": "vão", "eles": "vão"], pt: ["eu": "vou", "tu": "vais", "ele": "vai", "nos": "vamos", "vos": "ides", "eles": "vão"]), level: 2),
            Verb(infinitive: "Haver", translation: "To exist/there is", irregular: true, context: "Existence", conjugations: .init(br: ["eu": "hei", "voce": "há", "nos": "havemos", "voces": "hão", "eles": "hão"], pt: ["eu": "hei", "tu": "hás", "ele": "há", "nos": "havemos", "vos": "haveis", "eles": "hão"]), level: 2)
        ])

        let l3 = Level(level: 3, tense: "Presente", verbs: [
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Actions and creation", conjugations: .init(br: ["eu": "faço", "voce": "faz", "nos": "fazemos", "voces": "fazem", "eles": "fazem"], pt: ["eu": "faço", "tu": "fazes", "ele": "faz", "nos": "fazemos", "vos": "fazeis", "eles": "fazem"]), level: 3),
            Verb(infinitive: "Poder", translation: "To be able/can", irregular: true, context: "Ability and permission", conjugations: .init(br: ["eu": "posso", "voce": "pode", "nos": "podemos", "voces": "podem", "eles": "podem"], pt: ["eu": "posso", "tu": "podes", "ele": "pode", "nos": "podemos", "vos": "podeis", "eles": "podem"]), level: 3),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "Desires and wishes", conjugations: .init(br: ["eu": "quero", "voce": "quer", "nos": "queremos", "voces": "querem", "eles": "querem"], pt: ["eu": "quero", "tu": "queres", "ele": "quer", "nos": "queremos", "vos": "quereis", "eles": "querem"]), level: 3),
            Verb(infinitive: "Saber", translation: "To know (facts)", irregular: true, context: "Knowledge and skills", conjugations: .init(br: ["eu": "sei", "voce": "sabe", "nos": "sabemos", "voces": "sabem", "eles": "sabem"], pt: ["eu": "sei", "tu": "sabes", "ele": "sabe", "nos": "sabemos", "vos": "sabeis", "eles": "sabem"]), level: 3),
            Verb(infinitive: "Dever", translation: "To must/owe", irregular: false, context: "Obligation", conjugations: .init(br: ["eu": "devo", "voce": "deve", "nos": "devemos", "voces": "devem", "eles": "devem"], pt: ["eu": "devo", "tu": "deves", "ele": "deve", "nos": "devemos", "vos": "deveis", "eles": "devem"]), level: 3)
        ])

        let l4 = Level(level: 4, tense: "Presente", verbs: [
            Verb(infinitive: "Dizer", translation: "To say/tell", irregular: true, context: "Communication", conjugations: .init(br: ["eu": "digo", "voce": "diz", "nos": "dizemos", "voces": "dizem", "eles": "dizem"], pt: ["eu": "digo", "tu": "dizes", "ele": "diz", "nos": "dizemos", "vos": "dizeis", "eles": "dizem"]), level: 4),
            Verb(infinitive: "Ver", translation: "To see", irregular: true, context: "Sight and perception", conjugations: .init(br: ["eu": "vejo", "voce": "vê", "nos": "vemos", "voces": "veem", "eles": "veem"], pt: ["eu": "vejo", "tu": "vês", "ele": "vê", "nos": "vemos", "vos": "vedes", "eles": "veem"]), level: 4),
            Verb(infinitive: "Dar", translation: "To give", irregular: true, context: "Giving and offering", conjugations: .init(br: ["eu": "dou", "voce": "dá", "nos": "damos", "voces": "dão", "eles": "dão"], pt: ["eu": "dou", "tu": "dás", "ele": "dá", "nos": "damos", "vos": "dais", "eles": "dão"]), level: 4),
            Verb(infinitive: "Vir", translation: "To come", irregular: true, context: "Arrival and movement", conjugations: .init(br: ["eu": "venho", "voce": "vem", "nos": "vimos", "voces": "vêm", "eles": "vêm"], pt: ["eu": "venho", "tu": "vens", "ele": "vem", "nos": "vimos", "vos": "vindes", "eles": "vêm"]), level: 4),
            Verb(infinitive: "Pôr", translation: "To put/place", irregular: true, context: "Placing objects", conjugations: .init(br: ["eu": "ponho", "voce": "põe", "nos": "pomos", "voces": "põem", "eles": "põem"], pt: ["eu": "ponho", "tu": "pões", "ele": "põe", "nos": "pomos", "vos": "pondes", "eles": "põem"]), level: 4)
        ])

        return [l1, l2, l3, l4]
    }
}
