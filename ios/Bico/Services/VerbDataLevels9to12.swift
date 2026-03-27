import Foundation

extension VerbDataService {
    static func buildLevels9to12() -> [Level] {
        let l9 = Level(level: 9, tense: "Presente", verbs: [
            Verb(infinitive: "Conhecer", translation: "To know (people)", irregular: false, context: "Knowing people/places", conjugations: .init(br: ["eu": "conheço", "voce": "conhece", "nos": "conhecemos", "voces": "conhecem", "eles": "conhecem"], pt: ["eu": "conheço", "tu": "conheces", "ele": "conhece", "nos": "conhecemos", "vos": "conheceis", "eles": "conhecem"]), level: 9),
            Verb(infinitive: "Encontrar", translation: "To find/meet", irregular: false, context: "Meeting people", conjugations: .init(br: ["eu": "encontro", "voce": "encontra", "nos": "encontramos", "voces": "encontram", "eles": "encontram"], pt: ["eu": "encontro", "tu": "encontras", "ele": "encontra", "nos": "encontramos", "vos": "encontrais", "eles": "encontram"]), level: 9),
            Verb(infinitive: "Pedir", translation: "To ask for", irregular: true, context: "Requests and orders", conjugations: .init(br: ["eu": "peço", "voce": "pede", "nos": "pedimos", "voces": "pedem", "eles": "pedem"], pt: ["eu": "peço", "tu": "pedes", "ele": "pede", "nos": "pedimos", "vos": "pedis", "eles": "pedem"]), level: 9),
            Verb(infinitive: "Esperar", translation: "To wait/hope", irregular: false, context: "Waiting and hoping", conjugations: .init(br: ["eu": "espero", "voce": "espera", "nos": "esperamos", "voces": "esperam", "eles": "esperam"], pt: ["eu": "espero", "tu": "esperas", "ele": "espera", "nos": "esperamos", "vos": "esperais", "eles": "esperam"]), level: 9),
            Verb(infinitive: "Ouvir", translation: "To hear/listen", irregular: true, context: "Listening", conjugations: .init(br: ["eu": "ouço", "voce": "ouve", "nos": "ouvimos", "voces": "ouvem", "eles": "ouvem"], pt: ["eu": "ouço", "tu": "ouves", "ele": "ouve", "nos": "ouvimos", "vos": "ouvis", "eles": "ouvem"]), level: 9)
        ])

        let l10 = Level(level: 10, tense: "Presente", verbs: [
            Verb(infinitive: "Cozinhar", translation: "To cook", irregular: false, context: "Cooking", conjugations: .init(br: ["eu": "cozinho", "voce": "cozinha", "nos": "cozinhamos", "voces": "cozinham", "eles": "cozinham"], pt: ["eu": "cozinho", "tu": "cozinhas", "ele": "cozinha", "nos": "cozinhamos", "vos": "cozinhais", "eles": "cozinham"]), level: 10),
            Verb(infinitive: "Limpar", translation: "To clean", irregular: false, context: "Cleaning", conjugations: .init(br: ["eu": "limpo", "voce": "limpa", "nos": "limpamos", "voces": "limpam", "eles": "limpam"], pt: ["eu": "limpo", "tu": "limpas", "ele": "limpa", "nos": "limpamos", "vos": "limpais", "eles": "limpam"]), level: 10),
            Verb(infinitive: "Jogar", translation: "To play (games)", irregular: false, context: "Games and sports", conjugations: .init(br: ["eu": "jogo", "voce": "joga", "nos": "jogamos", "voces": "jogam", "eles": "jogam"], pt: ["eu": "jogo", "tu": "jogas", "ele": "joga", "nos": "jogamos", "vos": "jogais", "eles": "jogam"]), level: 10),
            Verb(infinitive: "Ler", translation: "To read", irregular: true, context: "Reading", conjugations: .init(br: ["eu": "leio", "voce": "lê", "nos": "lemos", "voces": "leem", "eles": "leem"], pt: ["eu": "leio", "tu": "lês", "ele": "lê", "nos": "lemos", "vos": "ledes", "eles": "leem"]), level: 10),
            Verb(infinitive: "Correr", translation: "To run", irregular: false, context: "Exercise and running", conjugations: .init(br: ["eu": "corro", "voce": "corre", "nos": "corremos", "voces": "correm", "eles": "correm"], pt: ["eu": "corro", "tu": "corres", "ele": "corre", "nos": "corremos", "vos": "correis", "eles": "correm"]), level: 10)
        ])

        let l11 = Level(level: 11, tense: "Presente", verbs: [
            Verb(infinitive: "Viajar", translation: "To travel", irregular: false, context: "Travel", conjugations: .init(br: ["eu": "viajo", "voce": "viaja", "nos": "viajamos", "voces": "viajam", "eles": "viajam"], pt: ["eu": "viajo", "tu": "viajas", "ele": "viaja", "nos": "viajamos", "vos": "viajais", "eles": "viajam"]), level: 11),
            Verb(infinitive: "Ficar", translation: "To stay/remain", irregular: false, context: "Staying somewhere", conjugations: .init(br: ["eu": "fico", "voce": "fica", "nos": "ficamos", "voces": "ficam", "eles": "ficam"], pt: ["eu": "fico", "tu": "ficas", "ele": "fica", "nos": "ficamos", "vos": "ficais", "eles": "ficam"]), level: 11),
            Verb(infinitive: "Levar", translation: "To take/carry", irregular: false, context: "Carrying things", conjugations: .init(br: ["eu": "levo", "voce": "leva", "nos": "levamos", "voces": "levam", "eles": "levam"], pt: ["eu": "levo", "tu": "levas", "ele": "leva", "nos": "levamos", "vos": "levais", "eles": "levam"]), level: 11),
            Verb(infinitive: "Trazer", translation: "To bring", irregular: true, context: "Bringing things", conjugations: .init(br: ["eu": "trago", "voce": "traz", "nos": "trazemos", "voces": "trazem", "eles": "trazem"], pt: ["eu": "trago", "tu": "trazes", "ele": "traz", "nos": "trazemos", "vos": "trazeis", "eles": "trazem"]), level: 11),
            Verb(infinitive: "Mostrar", translation: "To show", irregular: false, context: "Showing and demonstrating", conjugations: .init(br: ["eu": "mostro", "voce": "mostra", "nos": "mostramos", "voces": "mostram", "eles": "mostram"], pt: ["eu": "mostro", "tu": "mostras", "ele": "mostra", "nos": "mostramos", "vos": "mostrais", "eles": "mostram"]), level: 11)
        ])

        let l12 = Level(level: 12, tense: "Presente", verbs: [
            Verb(infinitive: "Amar", translation: "To love", irregular: false, context: "Love and affection", conjugations: .init(br: ["eu": "amo", "voce": "ama", "nos": "amamos", "voces": "amam", "eles": "amam"], pt: ["eu": "amo", "tu": "amas", "ele": "ama", "nos": "amamos", "vos": "amais", "eles": "amam"]), level: 12),
            Verb(infinitive: "Preferir", translation: "To prefer", irregular: true, context: "Preferences", conjugations: .init(br: ["eu": "prefiro", "voce": "prefere", "nos": "preferimos", "voces": "preferem", "eles": "preferem"], pt: ["eu": "prefiro", "tu": "preferes", "ele": "prefere", "nos": "preferimos", "vos": "preferis", "eles": "preferem"]), level: 12),
            Verb(infinitive: "Parecer", translation: "To seem/appear", irregular: false, context: "Appearances", conjugations: .init(br: ["eu": "pareço", "voce": "parece", "nos": "parecemos", "voces": "parecem", "eles": "parecem"], pt: ["eu": "pareço", "tu": "pareces", "ele": "parece", "nos": "parecemos", "vos": "pareceis", "eles": "parecem"]), level: 12),
            Verb(infinitive: "Conseguir", translation: "To manage/achieve", irregular: true, context: "Achievement", conjugations: .init(br: ["eu": "consigo", "voce": "consegue", "nos": "conseguimos", "voces": "conseguem", "eles": "conseguem"], pt: ["eu": "consigo", "tu": "consegues", "ele": "consegue", "nos": "conseguimos", "vos": "conseguis", "eles": "conseguem"]), level: 12),
            Verb(infinitive: "Entender", translation: "To understand", irregular: false, context: "Comprehension", conjugations: .init(br: ["eu": "entendo", "voce": "entende", "nos": "entendemos", "voces": "entendem", "eles": "entendem"], pt: ["eu": "entendo", "tu": "entendes", "ele": "entende", "nos": "entendemos", "vos": "entendeis", "eles": "entendem"]), level: 12)
        ])

        return [l9, l10, l11, l12]
    }
}
