import SwiftUI

enum ConversationDataService {

    static func scenarios(for dialect: Dialect) -> [ConversationScenario] {
        dialect == .brazilian ? brazilianAll : europeanAll
    }

    static var brazilianAll: [ConversationScenario] {
        brBeginner + brIntermediate + brAdvanced
    }

    static var europeanAll: [ConversationScenario] {
        ptBeginner + ptIntermediate + ptAdvanced
    }
}
