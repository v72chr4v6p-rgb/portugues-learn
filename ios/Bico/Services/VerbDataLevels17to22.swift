import Foundation

extension VerbDataService {
    static func buildLevels17to22() -> [Level] {
        let l17 = Level(level: 17, tense: "Pretérito Perfeito", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "Spoke in the past", conjugations: .init(br: ["eu": "falei", "voce": "falou", "nos": "falamos", "voces": "falaram", "eles": "falaram"], pt: ["eu": "falei", "tu": "falaste", "ele": "falou", "nos": "falámos", "vos": "falastes", "eles": "falaram"]), level: 17),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "Ate in the past", conjugations: .init(br: ["eu": "comi", "voce": "comeu", "nos": "comemos", "voces": "comeram", "eles": "comeram"], pt: ["eu": "comi", "tu": "comeste", "ele": "comeu", "nos": "comemos", "vos": "comestes", "eles": "comeram"]), level: 17),
            Verb(infinitive: "Partir", translation: "To leave", irregular: false, context: "Left in the past", conjugations: .init(br: ["eu": "parti", "voce": "partiu", "nos": "partimos", "voces": "partiram", "eles": "partiram"], pt: ["eu": "parti", "tu": "partiste", "ele": "partiu", "nos": "partimos", "vos": "partistes", "eles": "partiram"]), level: 17),
            Verb(infinitive: "Trabalhar", translation: "To work", irregular: false, context: "Worked in the past", conjugations: .init(br: ["eu": "trabalhei", "voce": "trabalhou", "nos": "trabalhamos", "voces": "trabalharam", "eles": "trabalharam"], pt: ["eu": "trabalhei", "tu": "trabalhaste", "ele": "trabalhou", "nos": "trabalhámos", "vos": "trabalhastes", "eles": "trabalharam"]), level: 17),
            Verb(infinitive: "Estudar", translation: "To study", irregular: false, context: "Studied in the past", conjugations: .init(br: ["eu": "estudei", "voce": "estudou", "nos": "estudamos", "voces": "estudaram", "eles": "estudaram"], pt: ["eu": "estudei", "tu": "estudaste", "ele": "estudou", "nos": "estudámos", "vos": "estudastes", "eles": "estudaram"]), level: 17)
        ])

        let l18 = Level(level: 18, tense: "Pretérito Perfeito", verbs: [
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "Was (permanent)", conjugations: .init(br: ["eu": "fui", "voce": "foi", "nos": "fomos", "voces": "foram", "eles": "foram"], pt: ["eu": "fui", "tu": "foste", "ele": "foi", "nos": "fomos", "vos": "fostes", "eles": "foram"]), level: 18),
            Verb(infinitive: "Estar", translation: "To be", irregular: true, context: "Was (temporary)", conjugations: .init(br: ["eu": "estive", "voce": "esteve", "nos": "estivemos", "voces": "estiveram", "eles": "estiveram"], pt: ["eu": "estive", "tu": "estiveste", "ele": "esteve", "nos": "estivemos", "vos": "estivestes", "eles": "estiveram"]), level: 18),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Had", conjugations: .init(br: ["eu": "tive", "voce": "teve", "nos": "tivemos", "voces": "tiveram", "eles": "tiveram"], pt: ["eu": "tive", "tu": "tiveste", "ele": "teve", "nos": "tivemos", "vos": "tivestes", "eles": "tiveram"]), level: 18),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "Went", conjugations: .init(br: ["eu": "fui", "voce": "foi", "nos": "fomos", "voces": "foram", "eles": "foram"], pt: ["eu": "fui", "tu": "foste", "ele": "foi", "nos": "fomos", "vos": "fostes", "eles": "foram"]), level: 18)
        ])

        let l19 = Level(level: 19, tense: "Pretérito Perfeito", verbs: [
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Did/made", conjugations: .init(br: ["eu": "fiz", "voce": "fez", "nos": "fizemos", "voces": "fizeram", "eles": "fizeram"], pt: ["eu": "fiz", "tu": "fizeste", "ele": "fez", "nos": "fizemos", "vos": "fizestes", "eles": "fizeram"]), level: 19),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "Said", conjugations: .init(br: ["eu": "disse", "voce": "disse", "nos": "dissemos", "voces": "disseram", "eles": "disseram"], pt: ["eu": "disse", "tu": "disseste", "ele": "disse", "nos": "dissemos", "vos": "dissestes", "eles": "disseram"]), level: 19),
            Verb(infinitive: "Trazer", translation: "To bring", irregular: true, context: "Brought", conjugations: .init(br: ["eu": "trouxe", "voce": "trouxe", "nos": "trouxemos", "voces": "trouxeram", "eles": "trouxeram"], pt: ["eu": "trouxe", "tu": "trouxeste", "ele": "trouxe", "nos": "trouxemos", "vos": "trouxestes", "eles": "trouxeram"]), level: 19),
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "Could", conjugations: .init(br: ["eu": "pude", "voce": "pôde", "nos": "pudemos", "voces": "puderam", "eles": "puderam"], pt: ["eu": "pude", "tu": "pudeste", "ele": "pôde", "nos": "pudemos", "vos": "pudestes", "eles": "puderam"]), level: 19),
            Verb(infinitive: "Saber", translation: "To know", irregular: true, context: "Found out", conjugations: .init(br: ["eu": "soube", "voce": "soube", "nos": "soubemos", "voces": "souberam", "eles": "souberam"], pt: ["eu": "soube", "tu": "soubeste", "ele": "soube", "nos": "soubemos", "vos": "soubestes", "eles": "souberam"]), level: 19)
        ])

        let l20 = Level(level: 20, tense: "Pretérito Perfeito", verbs: [
            Verb(infinitive: "Dar", translation: "To give", irregular: true, context: "Gave", conjugations: .init(br: ["eu": "dei", "voce": "deu", "nos": "demos", "voces": "deram", "eles": "deram"], pt: ["eu": "dei", "tu": "deste", "ele": "deu", "nos": "demos", "vos": "destes", "eles": "deram"]), level: 20),
            Verb(infinitive: "Ver", translation: "To see", irregular: true, context: "Saw", conjugations: .init(br: ["eu": "vi", "voce": "viu", "nos": "vimos", "voces": "viram", "eles": "viram"], pt: ["eu": "vi", "tu": "viste", "ele": "viu", "nos": "vimos", "vos": "vistes", "eles": "viram"]), level: 20),
            Verb(infinitive: "Vir", translation: "To come", irregular: true, context: "Came", conjugations: .init(br: ["eu": "vim", "voce": "veio", "nos": "viemos", "voces": "vieram", "eles": "vieram"], pt: ["eu": "vim", "tu": "vieste", "ele": "veio", "nos": "viemos", "vos": "viestes", "eles": "vieram"]), level: 20),
            Verb(infinitive: "Pôr", translation: "To put", irregular: true, context: "Put/placed", conjugations: .init(br: ["eu": "pus", "voce": "pôs", "nos": "pusemos", "voces": "puseram", "eles": "puseram"], pt: ["eu": "pus", "tu": "puseste", "ele": "pôs", "nos": "pusemos", "vos": "pusestes", "eles": "puseram"]), level: 20),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "Wanted", conjugations: .init(br: ["eu": "quis", "voce": "quis", "nos": "quisemos", "voces": "quiseram", "eles": "quiseram"], pt: ["eu": "quis", "tu": "quiseste", "ele": "quis", "nos": "quisemos", "vos": "quisestes", "eles": "quiseram"]), level: 20)
        ])

        let l21 = Level(level: 21, tense: "Pretérito Perfeito", verbs: [
            Verb(infinitive: "Comprar", translation: "To buy", irregular: false, context: "Bought", conjugations: .init(br: ["eu": "comprei", "voce": "comprou", "nos": "compramos", "voces": "compraram", "eles": "compraram"], pt: ["eu": "comprei", "tu": "compraste", "ele": "comprou", "nos": "comprámos", "vos": "comprastes", "eles": "compraram"]), level: 21),
            Verb(infinitive: "Vender", translation: "To sell", irregular: false, context: "Sold", conjugations: .init(br: ["eu": "vendi", "voce": "vendeu", "nos": "vendemos", "voces": "venderam", "eles": "venderam"], pt: ["eu": "vendi", "tu": "vendeste", "ele": "vendeu", "nos": "vendemos", "vos": "vendestes", "eles": "venderam"]), level: 21),
            Verb(infinitive: "Abrir", translation: "To open", irregular: false, context: "Opened", conjugations: .init(br: ["eu": "abri", "voce": "abriu", "nos": "abrimos", "voces": "abriram", "eles": "abriram"], pt: ["eu": "abri", "tu": "abriste", "ele": "abriu", "nos": "abrimos", "vos": "abristes", "eles": "abriram"]), level: 21),
            Verb(infinitive: "Escrever", translation: "To write", irregular: false, context: "Wrote", conjugations: .init(br: ["eu": "escrevi", "voce": "escreveu", "nos": "escrevemos", "voces": "escreveram", "eles": "escreveram"], pt: ["eu": "escrevi", "tu": "escreveste", "ele": "escreveu", "nos": "escrevemos", "vos": "escrevestes", "eles": "escreveram"]), level: 21),
            Verb(infinitive: "Decidir", translation: "To decide", irregular: false, context: "Decided", conjugations: .init(br: ["eu": "decidi", "voce": "decidiu", "nos": "decidimos", "voces": "decidiram", "eles": "decidiram"], pt: ["eu": "decidi", "tu": "decidiste", "ele": "decidiu", "nos": "decidimos", "vos": "decidistes", "eles": "decidiram"]), level: 21)
        ])

        let l22 = Level(level: 22, tense: "Pretérito Perfeito", verbs: [
            Verb(infinitive: "Pedir", translation: "To ask for", irregular: true, context: "Asked for", conjugations: .init(br: ["eu": "pedi", "voce": "pediu", "nos": "pedimos", "voces": "pediram", "eles": "pediram"], pt: ["eu": "pedi", "tu": "pediste", "ele": "pediu", "nos": "pedimos", "vos": "pedistes", "eles": "pediram"]), level: 22),
            Verb(infinitive: "Ouvir", translation: "To hear", irregular: true, context: "Heard", conjugations: .init(br: ["eu": "ouvi", "voce": "ouviu", "nos": "ouvimos", "voces": "ouviram", "eles": "ouviram"], pt: ["eu": "ouvi", "tu": "ouviste", "ele": "ouviu", "nos": "ouvimos", "vos": "ouvistes", "eles": "ouviram"]), level: 22),
            Verb(infinitive: "Dormir", translation: "To sleep", irregular: true, context: "Slept", conjugations: .init(br: ["eu": "dormi", "voce": "dormiu", "nos": "dormimos", "voces": "dormiram", "eles": "dormiram"], pt: ["eu": "dormi", "tu": "dormiste", "ele": "dormiu", "nos": "dormimos", "vos": "dormistes", "eles": "dormiram"]), level: 22),
            Verb(infinitive: "Sentir", translation: "To feel", irregular: true, context: "Felt", conjugations: .init(br: ["eu": "senti", "voce": "sentiu", "nos": "sentimos", "voces": "sentiram", "eles": "sentiram"], pt: ["eu": "senti", "tu": "sentiste", "ele": "sentiu", "nos": "sentimos", "vos": "sentistes", "eles": "sentiram"]), level: 22),
            Verb(infinitive: "Conseguir", translation: "To achieve", irregular: true, context: "Managed to", conjugations: .init(br: ["eu": "consegui", "voce": "conseguiu", "nos": "conseguimos", "voces": "conseguiram", "eles": "conseguiram"], pt: ["eu": "consegui", "tu": "conseguiste", "ele": "conseguiu", "nos": "conseguimos", "vos": "conseguistes", "eles": "conseguiram"]), level: 22)
        ])

        return [l17, l18, l19, l20, l21, l22]
    }
}
