import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NoteViewModel
    @Binding var note: Note?
    
    @State private var title: String = ""
    @State private var text: String = ""
    
    var isNew: Bool { note == nil }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Заголовок", text: $title)
                    .font(.title2)
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                
                TextEditor(text: $text)
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .frame(minHeight: 200, maxHeight: .infinity)
                
                Spacer()
            }
            .padding()
            .navigationTitle(isNew ? "Новая заметка" : "Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        if isNew {
                            viewModel.addNote(title: title, text: text)
                        } else if let n = note {
                            viewModel.updateNote(n, title: title, text: text)
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty && text.isEmpty)
                }
            }
            .onAppear {
                title = note?.title ?? ""
                text = note?.text ?? ""
            }
        }
    }
}
