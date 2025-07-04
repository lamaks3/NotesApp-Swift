import SwiftUI
// A SwiftUI preview.
#Preview {
    ContentView()
}
struct ContentView: View {
    @StateObject private var vm = NoteViewModel()
    @State private var showingEditor = false
    @State private var selectedNote: Note?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Notes")
                            .font(.largeTitle)
                            .bold()
                        Text("By LaMaks")
                            .font(.custom("Bradley Hand", size: 20))
                        Spacer()
                        Button {
                            selectedNote = nil
                            showingEditor = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.horizontal)
                    SearchBar(text: $vm.searchText)
                        .padding(.horizontal)

                    if vm.filteredNotes.isEmpty {
                        Spacer()
                        VStack {
                            Image(systemName: "note.text")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray.opacity(0.3))
                            Text("No notes yet. Add a new one!")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(vm.filteredNotes) { note in
                                Button {
                                    selectedNote = note
                                    showingEditor = true
                                } label: {
                                    NoteRow(note: note)
                                }
                                .listRowBackground(Color.white.opacity(0.8))
                            }
                            .onDelete(perform: vm.deleteNote)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                NoteEditorView(viewModel: vm, note: $selectedNote)
            }
        }
    }
}

struct NoteRow: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.title.isEmpty ? "Without title" : note.title)
                .font(.headline)
                .foregroundColor(.purple)
            
            Text(note.text)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Text(note.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .listRowBackground(Color.clear) // Ключевое изменение!
    }
    
}

// Поисковая строка с поддержкой светлой/тёмной темы
struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Smart Search", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}
