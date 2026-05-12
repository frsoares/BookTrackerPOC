//
//  BookEditView.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 11/05/26.
//

import SwiftUI
import SwiftData

struct BookEditView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Bindable var book: Book
    @State private var showingAlert = false
    @State private var showErrorAlert = false
    @State var isEditing = false

    var body: some View {
        if isEditing {
            editBody
        } else {
            regularBody
        }
    }

    private var regularBody: some View {
        Form {
            HStack {
                Text("Author").bold()
                Spacer()
                Text(book.author)
            }
            Text("Comments").bold()
            Text(book.review)
                .multilineTextAlignment(.leading)
        }
        .navigationTitle(book.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isEditing = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
    }

    private var editBody: some View {
        VStack {
            Form {
                Section ("Basic Info") {
                    HStack {
                        TextField("Book title:", text: $book.name, prompt: Text("The book's title"))
                        Button {

                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.tint)
                                Image(systemName: "camera.fill")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: 100)
                    }
                    TextField("Book author:", text: $book.author, prompt: Text("The book's author"))
                }
                Section("Comments") {
                    TextEditor(text: $book.review)
                }
                Section("Status") {
                    Toggle("Finished reading?", isOn: $book.finished)
                }
            }
            .alert("Book saved!", isPresented: $showingAlert) {
                Button("OK!") {
                    dismiss()
                }
            }
            .alert("There was a problam saving the book!", isPresented: $showErrorAlert) {
                Button("OK") {
                    showErrorAlert.toggle()
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    save()
                } label: {
                    Text("Save")
//                    Label("Save", systemImage: "pencil")
                }
                .foregroundStyle(.tint)
            }
        }
    }

    fileprivate func save() {
        do {
            if book.modelContext == nil {
                context.insert(book)
            }
            if context.hasChanges {
                try context.save()
                showingAlert = true
            }
        } catch {
            print("hey, there was an error: \(error.localizedDescription)")
            showErrorAlert.toggle()
        }
    }

}

#Preview {
    BookEditView(book: Book(name: "The Swift Programming Language", author: "Apple Inc.", review: "A great book"))
}
