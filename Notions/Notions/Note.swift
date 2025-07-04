import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var text: String
    var date: Date

    init(id: UUID = UUID(), title: String, text: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.text = text
        self.date = date
    }
}

