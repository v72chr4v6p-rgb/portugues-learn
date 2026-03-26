import Foundation

nonisolated struct LessonPage: Sendable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let blocks: [ContentBlock]
}

nonisolated struct ContentBlock: Sendable, Identifiable {
    let id: String
    let type: BlockType
    let text: String
    let items: [String]
    let headers: [String]
    let rows: [[String]]

    nonisolated enum BlockType: Sendable {
        case paragraph
        case heading
        case subheading
        case tip
        case bullets
        case steps
        case table
        case highlight
        case question
    }

    static func paragraph(_ text: String) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .paragraph, text: text, items: [], headers: [], rows: [])
    }

    static func heading(_ text: String) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .heading, text: text, items: [], headers: [], rows: [])
    }

    static func subheading(_ text: String) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .subheading, text: text, items: [], headers: [], rows: [])
    }

    static func tip(_ text: String) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .tip, text: text, items: [], headers: [], rows: [])
    }

    static func bullets(_ items: [String]) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .bullets, text: "", items: items, headers: [], rows: [])
    }

    static func steps(_ items: [String]) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .steps, text: "", items: items, headers: [], rows: [])
    }

    static func table(headers: [String], rows: [[String]]) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .table, text: "", items: [], headers: headers, rows: rows)
    }

    static func highlight(_ text: String) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .highlight, text: text, items: [], headers: [], rows: [])
    }

    static func question(_ text: String) -> ContentBlock {
        ContentBlock(id: UUID().uuidString, type: .question, text: text, items: [], headers: [], rows: [])
    }
}
