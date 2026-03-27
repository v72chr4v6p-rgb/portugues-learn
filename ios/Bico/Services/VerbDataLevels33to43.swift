import Foundation

extension VerbDataService {
    static func buildLevels33to43() -> [Level] {
        var result: [Level] = []
        result.append(contentsOf: buildSubjuntivo())
        result.append(contentsOf: buildImperativoAndFinal())
        return result
    }

    private static func buildSubjuntivo() -> [Level] {
        let l33 = Level(level: 33, tense: "Presente do Subjuntivo", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "That I speak", conjugations: .init(br: ["eu": "fale", "voce": "fale", "nos": "falemos", "voces": "falem", "eles": "falem"], pt: ["eu": "fale", "tu": "fales", "ele": "fale", "nos": "falemos", "vos": "faleis", "eles": "falem"]), level: 33),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "That I eat", conjugations: .init(br: ["eu": "coma", "voce": "coma", "nos": "comamos", "voces": "comam", "eles": "comam"], pt: ["eu": "coma", "tu": "comas", "ele": "coma", "nos": "comamos", "vos": "comais", "eles": "comam"]), level: 33),
            Verb(infinitive: "Partir", translation: "To leave", irregular: false, context: "That I leave", conjugations: .init(br: ["eu": "parta", "voce": "parta", "nos": "partamos", "voces": "partam", "eles": "partam"], pt: ["eu": "parta", "tu": "partas", "ele": "parta", "nos": "partamos", "vos": "partais", "eles": "partam"]), level: 33),
            Verb(infinitive: "Trabalhar", translation: "To work", irregular: false, context: "That I work", conjugations: .init(br: ["eu": "trabalhe", "voce": "trabalhe", "nos": "trabalhemos", "voces": "trabalhem", "eles": "trabalhem"], pt: ["eu": "trabalhe", "tu": "trabalhes", "ele": "trabalhe", "nos": "trabalhemos", "vos": "trabalheis", "eles": "trabalhem"]), level: 33),
            Verb(infinitive: "Escrever", translation: "To write", irregular: false, context: "That I write", conjugations: .init(br: ["eu": "escreva", "voce": "escreva", "nos": "escrevamos", "voces": "escrevam", "eles": "escrevam"], pt: ["eu": "escreva", "tu": "escrevas", "ele": "escreva", "nos": "escrevamos", "vos": "escrevais", "eles": "escrevam"]), level: 33)
        ])

        let l34 = Level(level: 34, tense: "Presente do Subjuntivo", verbs: [
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "That I be", conjugations: .init(br: ["eu": "seja", "voce": "seja", "nos": "sejamos", "voces": "sejam", "eles": "sejam"], pt: ["eu": "seja", "tu": "sejas", "ele": "seja", "nos": "sejamos", "vos": "sejais", "eles": "sejam"]), level: 34),
            Verb(infinitive: "Estar", translation: "To be", irregular: true, context: "That I be (state)", conjugations: .init(br: ["eu": "esteja", "voce": "esteja", "nos": "estejamos", "voces": "estejam", "eles": "estejam"], pt: ["eu": "esteja", "tu": "estejas", "ele": "esteja", "nos": "estejamos", "vos": "estejais", "eles": "estejam"]), level: 34),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "That I have", conjugations: .init(br: ["eu": "tenha", "voce": "tenha", "nos": "tenhamos", "voces": "tenham", "eles": "tenham"], pt: ["eu": "tenha", "tu": "tenhas", "ele": "tenha", "nos": "tenhamos", "vos": "tenhais", "eles": "tenham"]), level: 34),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "That I go", conjugations: .init(br: ["eu": "vá", "voce": "vá", "nos": "vamos", "voces": "vão", "eles": "vão"], pt: ["eu": "vá", "tu": "vás", "ele": "vá", "nos": "vamos", "vos": "vades", "eles": "vão"]), level: 34),
            Verb(infinitive: "Haver", translation: "To exist", irregular: true, context: "That there be", conjugations: .init(br: ["eu": "haja", "voce": "haja", "nos": "hajamos", "voces": "hajam", "eles": "hajam"], pt: ["eu": "haja", "tu": "hajas", "ele": "haja", "nos": "hajamos", "vos": "hajais", "eles": "hajam"]), level: 34)
        ])

        let l35 = Level(level: 35, tense: "Presente do Subjuntivo", verbs: [
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "That I do", conjugations: .init(br: ["eu": "faça", "voce": "faça", "nos": "façamos", "voces": "façam", "eles": "façam"], pt: ["eu": "faça", "tu": "faças", "ele": "faça", "nos": "façamos", "vos": "façais", "eles": "façam"]), level: 35),
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "That I can", conjugations: .init(br: ["eu": "possa", "voce": "possa", "nos": "possamos", "voces": "possam", "eles": "possam"], pt: ["eu": "possa", "tu": "possas", "ele": "possa", "nos": "possamos", "vos": "possais", "eles": "possam"]), level: 35),
            Verb(infinitive: "Saber", translation: "To know", irregular: true, context: "That I know", conjugations: .init(br: ["eu": "saiba", "voce": "saiba", "nos": "saibamos", "voces": "saibam", "eles": "saibam"], pt: ["eu": "saiba", "tu": "saibas", "ele": "saiba", "nos": "saibamos", "vos": "saibais", "eles": "saibam"]), level: 35),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "That I want", conjugations: .init(br: ["eu": "queira", "voce": "queira", "nos": "queiramos", "voces": "queiram", "eles": "queiram"], pt: ["eu": "queira", "tu": "queiras", "ele": "queira", "nos": "queiramos", "vos": "queirais", "eles": "queiram"]), level: 35),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "That I say", conjugations: .init(br: ["eu": "diga", "voce": "diga", "nos": "digamos", "voces": "digam", "eles": "digam"], pt: ["eu": "diga", "tu": "digas", "ele": "diga", "nos": "digamos", "vos": "digais", "eles": "digam"]), level: 35)
        ])

        let l36 = Level(level: 36, tense: "Presente do Subjuntivo", verbs: [
            Verb(infinitive: "Dar", translation: "To give", irregular: true, context: "That I give", conjugations: .init(br: ["eu": "dê", "voce": "dê", "nos": "demos", "voces": "deem", "eles": "deem"], pt: ["eu": "dê", "tu": "dês", "ele": "dê", "nos": "demos", "vos": "deis", "eles": "deem"]), level: 36),
            Verb(infinitive: "Ver", translation: "To see", irregular: true, context: "That I see", conjugations: .init(br: ["eu": "veja", "voce": "veja", "nos": "vejamos", "voces": "vejam", "eles": "vejam"], pt: ["eu": "veja", "tu": "vejas", "ele": "veja", "nos": "vejamos", "vos": "vejais", "eles": "vejam"]), level: 36),
            Verb(infinitive: "Vir", translation: "To come", irregular: true, context: "That I come", conjugations: .init(br: ["eu": "venha", "voce": "venha", "nos": "venhamos", "voces": "venham", "eles": "venham"], pt: ["eu": "venha", "tu": "venhas", "ele": "venha", "nos": "venhamos", "vos": "venhais", "eles": "venham"]), level: 36),
            Verb(infinitive: "Pôr", translation: "To put", irregular: true, context: "That I put", conjugations: .init(br: ["eu": "ponha", "voce": "ponha", "nos": "ponhamos", "voces": "ponham", "eles": "ponham"], pt: ["eu": "ponha", "tu": "ponhas", "ele": "ponha", "nos": "ponhamos", "vos": "ponhais", "eles": "ponham"]), level: 36),
            Verb(infinitive: "Trazer", translation: "To bring", irregular: true, context: "That I bring", conjugations: .init(br: ["eu": "traga", "voce": "traga", "nos": "tragamos", "voces": "tragam", "eles": "tragam"], pt: ["eu": "traga", "tu": "tragas", "ele": "traga", "nos": "tragamos", "vos": "tragais", "eles": "tragam"]), level: 36)
        ])

        let l37 = Level(level: 37, tense: "Futuro do Subjuntivo", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "When I speak", conjugations: .init(br: ["eu": "falar", "voce": "falar", "nos": "falarmos", "voces": "falarem", "eles": "falarem"], pt: ["eu": "falar", "tu": "falares", "ele": "falar", "nos": "falarmos", "vos": "falardes", "eles": "falarem"]), level: 37),
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "When I am", conjugations: .init(br: ["eu": "for", "voce": "for", "nos": "formos", "voces": "forem", "eles": "forem"], pt: ["eu": "for", "tu": "fores", "ele": "for", "nos": "formos", "vos": "fordes", "eles": "forem"]), level: 37),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "When I have", conjugations: .init(br: ["eu": "tiver", "voce": "tiver", "nos": "tivermos", "voces": "tiverem", "eles": "tiverem"], pt: ["eu": "tiver", "tu": "tiveres", "ele": "tiver", "nos": "tivermos", "vos": "tiverdes", "eles": "tiverem"]), level: 37),
            Verb(infinitive: "Fazer", translation: "To do", irregular: true, context: "When I do", conjugations: .init(br: ["eu": "fizer", "voce": "fizer", "nos": "fizermos", "voces": "fizerem", "eles": "fizerem"], pt: ["eu": "fizer", "tu": "fizeres", "ele": "fizer", "nos": "fizermos", "vos": "fizerdes", "eles": "fizerem"]), level: 37),
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "When I can", conjugations: .init(br: ["eu": "puder", "voce": "puder", "nos": "pudermos", "voces": "puderem", "eles": "puderem"], pt: ["eu": "puder", "tu": "puderes", "ele": "puder", "nos": "pudermos", "vos": "puderdes", "eles": "puderem"]), level: 37),
            Verb(infinitive: "Querer", translation: "To want", irregular: true, context: "When I want", conjugations: .init(br: ["eu": "quiser", "voce": "quiser", "nos": "quisermos", "voces": "quiserem", "eles": "quiserem"], pt: ["eu": "quiser", "tu": "quiseres", "ele": "quiser", "nos": "quisermos", "vos": "quiserdes", "eles": "quiserem"]), level: 37)
        ])

        let l38 = Level(level: 38, tense: "Imperfeito do Subjuntivo", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "If I spoke", conjugations: .init(br: ["eu": "falasse", "voce": "falasse", "nos": "falássemos", "voces": "falassem", "eles": "falassem"], pt: ["eu": "falasse", "tu": "falasses", "ele": "falasse", "nos": "falássemos", "vos": "falásseis", "eles": "falassem"]), level: 38),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "If I ate", conjugations: .init(br: ["eu": "comesse", "voce": "comesse", "nos": "comêssemos", "voces": "comessem", "eles": "comessem"], pt: ["eu": "comesse", "tu": "comesses", "ele": "comesse", "nos": "comêssemos", "vos": "comêsseis", "eles": "comessem"]), level: 38),
            Verb(infinitive: "Partir", translation: "To leave", irregular: false, context: "If I left", conjugations: .init(br: ["eu": "partisse", "voce": "partisse", "nos": "partíssemos", "voces": "partissem", "eles": "partissem"], pt: ["eu": "partisse", "tu": "partisses", "ele": "partisse", "nos": "partíssemos", "vos": "partísseis", "eles": "partissem"]), level: 38),
            Verb(infinitive: "Trabalhar", translation: "To work", irregular: false, context: "If I worked", conjugations: .init(br: ["eu": "trabalhasse", "voce": "trabalhasse", "nos": "trabalhássemos", "voces": "trabalhassem", "eles": "trabalhassem"], pt: ["eu": "trabalhasse", "tu": "trabalhasses", "ele": "trabalhasse", "nos": "trabalhássemos", "vos": "trabalhásseis", "eles": "trabalhassem"]), level: 38),
            Verb(infinitive: "Viver", translation: "To live", irregular: false, context: "If I lived", conjugations: .init(br: ["eu": "vivesse", "voce": "vivesse", "nos": "vivêssemos", "voces": "vivessem", "eles": "vivessem"], pt: ["eu": "vivesse", "tu": "vivesses", "ele": "vivesse", "nos": "vivêssemos", "vos": "vivêsseis", "eles": "vivessem"]), level: 38)
        ])

        let l39 = Level(level: 39, tense: "Imperfeito do Subjuntivo", verbs: [
            Verb(infinitive: "Ser", translation: "To be", irregular: true, context: "If I were", conjugations: .init(br: ["eu": "fosse", "voce": "fosse", "nos": "fôssemos", "voces": "fossem", "eles": "fossem"], pt: ["eu": "fosse", "tu": "fosses", "ele": "fosse", "nos": "fôssemos", "vos": "fôsseis", "eles": "fossem"]), level: 39),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "If I had", conjugations: .init(br: ["eu": "tivesse", "voce": "tivesse", "nos": "tivéssemos", "voces": "tivessem", "eles": "tivessem"], pt: ["eu": "tivesse", "tu": "tivesses", "ele": "tivesse", "nos": "tivéssemos", "vos": "tivésseis", "eles": "tivessem"]), level: 39),
            Verb(infinitive: "Fazer", translation: "To do", irregular: true, context: "If I did", conjugations: .init(br: ["eu": "fizesse", "voce": "fizesse", "nos": "fizéssemos", "voces": "fizessem", "eles": "fizessem"], pt: ["eu": "fizesse", "tu": "fizesses", "ele": "fizesse", "nos": "fizéssemos", "vos": "fizésseis", "eles": "fizessem"]), level: 39),
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "If I could", conjugations: .init(br: ["eu": "pudesse", "voce": "pudesse", "nos": "pudéssemos", "voces": "pudessem", "eles": "pudessem"], pt: ["eu": "pudesse", "tu": "pudesses", "ele": "pudesse", "nos": "pudéssemos", "vos": "pudésseis", "eles": "pudessem"]), level: 39),
            Verb(infinitive: "Saber", translation: "To know", irregular: true, context: "If I knew", conjugations: .init(br: ["eu": "soubesse", "voce": "soubesse", "nos": "soubéssemos", "voces": "soubessem", "eles": "soubessem"], pt: ["eu": "soubesse", "tu": "soubesses", "ele": "soubesse", "nos": "soubéssemos", "vos": "soubésseis", "eles": "soubessem"]), level: 39)
        ])

        let l40 = Level(level: 40, tense: "Imperfeito do Subjuntivo", verbs: [
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "If I went", conjugations: .init(br: ["eu": "fosse", "voce": "fosse", "nos": "fôssemos", "voces": "fossem", "eles": "fossem"], pt: ["eu": "fosse", "tu": "fosses", "ele": "fosse", "nos": "fôssemos", "vos": "fôsseis", "eles": "fossem"]), level: 40),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "If I said", conjugations: .init(br: ["eu": "dissesse", "voce": "dissesse", "nos": "disséssemos", "voces": "dissessem", "eles": "dissessem"], pt: ["eu": "dissesse", "tu": "dissesses", "ele": "dissesse", "nos": "disséssemos", "vos": "dissésseis", "eles": "dissessem"]), level: 40),
            Verb(infinitive: "Dar", translation: "To give", irregular: true, context: "If I gave", conjugations: .init(br: ["eu": "desse", "voce": "desse", "nos": "déssemos", "voces": "dessem", "eles": "dessem"], pt: ["eu": "desse", "tu": "desses", "ele": "desse", "nos": "déssemos", "vos": "désseis", "eles": "dessem"]), level: 40),
            Verb(infinitive: "Ver", translation: "To see", irregular: true, context: "If I saw", conjugations: .init(br: ["eu": "visse", "voce": "visse", "nos": "víssemos", "voces": "vissem", "eles": "vissem"], pt: ["eu": "visse", "tu": "visses", "ele": "visse", "nos": "víssemos", "vos": "vísseis", "eles": "vissem"]), level: 40),
            Verb(infinitive: "Vir", translation: "To come", irregular: true, context: "If I came", conjugations: .init(br: ["eu": "viesse", "voce": "viesse", "nos": "viéssemos", "voces": "viessem", "eles": "viessem"], pt: ["eu": "viesse", "tu": "viesses", "ele": "viesse", "nos": "viéssemos", "vos": "viésseis", "eles": "viessem"]), level: 40)
        ])

        return [l33, l34, l35, l36, l37, l38, l39, l40]
    }

    private static func buildImperativoAndFinal() -> [Level] {
        let l41 = Level(level: 41, tense: "Imperativo", verbs: [
            Verb(infinitive: "Falar", translation: "To speak", irregular: false, context: "Speak!", conjugations: .init(br: ["voce": "fale", "nos": "falemos", "voces": "falem", "eu": "—", "eles": "falem"], pt: ["tu": "fala", "voce": "fale", "nos": "falemos", "vos": "falai", "voces": "falem", "eu": "—", "eles": "falem"]), level: 41),
            Verb(infinitive: "Comer", translation: "To eat", irregular: false, context: "Eat!", conjugations: .init(br: ["voce": "coma", "nos": "comamos", "voces": "comam", "eu": "—", "eles": "comam"], pt: ["tu": "come", "voce": "coma", "nos": "comamos", "vos": "comei", "voces": "comam", "eu": "—", "eles": "comam"]), level: 41),
            Verb(infinitive: "Abrir", translation: "To open", irregular: false, context: "Open!", conjugations: .init(br: ["voce": "abra", "nos": "abramos", "voces": "abram", "eu": "—", "eles": "abram"], pt: ["tu": "abre", "voce": "abra", "nos": "abramos", "vos": "abri", "voces": "abram", "eu": "—", "eles": "abram"]), level: 41),
            Verb(infinitive: "Escrever", translation: "To write", irregular: false, context: "Write!", conjugations: .init(br: ["voce": "escreva", "nos": "escrevamos", "voces": "escrevam", "eu": "—", "eles": "escrevam"], pt: ["tu": "escreve", "voce": "escreva", "nos": "escrevamos", "vos": "escrevei", "voces": "escrevam", "eu": "—", "eles": "escrevam"]), level: 41),
            Verb(infinitive: "Olhar", translation: "To look", irregular: false, context: "Look!", conjugations: .init(br: ["voce": "olhe", "nos": "olhemos", "voces": "olhem", "eu": "—", "eles": "olhem"], pt: ["tu": "olha", "voce": "olhe", "nos": "olhemos", "vos": "olhai", "voces": "olhem", "eu": "—", "eles": "olhem"]), level: 41)
        ])

        let l42 = Level(level: 42, tense: "Imperativo", verbs: [
            Verb(infinitive: "Fazer", translation: "To do", irregular: true, context: "Do it!", conjugations: .init(br: ["voce": "faça", "nos": "façamos", "voces": "façam", "eu": "—", "eles": "façam"], pt: ["tu": "faz", "voce": "faça", "nos": "façamos", "vos": "fazei", "voces": "façam", "eu": "—", "eles": "façam"]), level: 42),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "Go!", conjugations: .init(br: ["voce": "vá", "nos": "vamos", "voces": "vão", "eu": "—", "eles": "vão"], pt: ["tu": "vai", "voce": "vá", "nos": "vamos", "vos": "ide", "voces": "vão", "eu": "—", "eles": "vão"]), level: 42),
            Verb(infinitive: "Vir", translation: "To come", irregular: true, context: "Come!", conjugations: .init(br: ["voce": "venha", "nos": "venhamos", "voces": "venham", "eu": "—", "eles": "venham"], pt: ["tu": "vem", "voce": "venha", "nos": "venhamos", "vos": "vinde", "voces": "venham", "eu": "—", "eles": "venham"]), level: 42),
            Verb(infinitive: "Dar", translation: "To give", irregular: true, context: "Give!", conjugations: .init(br: ["voce": "dê", "nos": "demos", "voces": "deem", "eu": "—", "eles": "deem"], pt: ["tu": "dá", "voce": "dê", "nos": "demos", "vos": "dai", "voces": "deem", "eu": "—", "eles": "deem"]), level: 42),
            Verb(infinitive: "Dizer", translation: "To say", irregular: true, context: "Say it!", conjugations: .init(br: ["voce": "diga", "nos": "digamos", "voces": "digam", "eu": "—", "eles": "digam"], pt: ["tu": "diz", "voce": "diga", "nos": "digamos", "vos": "dizei", "voces": "digam", "eu": "—", "eles": "digam"]), level: 42)
        ])

        let l43 = Level(level: 43, tense: "Revisão Final", verbs: [
            Verb(infinitive: "Ser", translation: "To be (permanent)", irregular: true, context: "Final review", conjugations: .init(br: ["eu": "sou", "voce": "é", "nos": "somos", "voces": "são", "eles": "são"], pt: ["eu": "sou", "tu": "és", "ele": "é", "nos": "somos", "vos": "sois", "eles": "são"]), level: 43),
            Verb(infinitive: "Estar", translation: "To be (temporary)", irregular: true, context: "Final review", conjugations: .init(br: ["eu": "estou", "voce": "está", "nos": "estamos", "voces": "estão", "eles": "estão"], pt: ["eu": "estou", "tu": "estás", "ele": "está", "nos": "estamos", "vos": "estais", "eles": "estão"]), level: 43),
            Verb(infinitive: "Ter", translation: "To have", irregular: true, context: "Final review", conjugations: .init(br: ["eu": "tenho", "voce": "tem", "nos": "temos", "voces": "têm", "eles": "têm"], pt: ["eu": "tenho", "tu": "tens", "ele": "tem", "nos": "temos", "vos": "tendes", "eles": "têm"]), level: 43),
            Verb(infinitive: "Ir", translation: "To go", irregular: true, context: "Final review", conjugations: .init(br: ["eu": "vou", "voce": "vai", "nos": "vamos", "voces": "vão", "eles": "vão"], pt: ["eu": "vou", "tu": "vais", "ele": "vai", "nos": "vamos", "vos": "ides", "eles": "vão"]), level: 43),
            Verb(infinitive: "Fazer", translation: "To do/make", irregular: true, context: "Final review", conjugations: .init(br: ["eu": "faço", "voce": "faz", "nos": "fazemos", "voces": "fazem", "eles": "fazem"], pt: ["eu": "faço", "tu": "fazes", "ele": "faz", "nos": "fazemos", "vos": "fazeis", "eles": "fazem"]), level: 43),
            Verb(infinitive: "Poder", translation: "To be able", irregular: true, context: "Final review", conjugations: .init(br: ["eu": "posso", "voce": "pode", "nos": "podemos", "voces": "podem", "eles": "podem"], pt: ["eu": "posso", "tu": "podes", "ele": "pode", "nos": "podemos", "vos": "podeis", "eles": "podem"]), level: 43)
        ])

        return [l41, l42, l43]
    }
}
