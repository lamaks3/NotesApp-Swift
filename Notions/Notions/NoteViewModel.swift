import Foundation

@MainActor
class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""

    private let saveKey = "notes_data"

    init() {
        loadNotes()
    }

    func addNote(title: String, text: String) {
        let newNote = Note(title: title, text: text)
        notes.insert(newNote, at: 0)
        saveNotes()
    }

    func updateNote(_ note: Note, title: String, text: String) {
        if let idx = notes.firstIndex(of: note) {
            notes[idx].title = title
            notes[idx].text = text
            notes[idx].date = Date()
            saveNotes()
        }
    }

    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }

    var filteredNotes: [Note] {
        if searchText.isEmpty { return notes }
        return notes.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.text.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: Persistence
    func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
}
