//
//  ContentView.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 11/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) var context
    @Query(
        filter: #Predicate<Book> { $0.finished == false },
        animation: .interactiveSpring) var books: [Book]

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(value: book) {
                    Text("\(book.name), by \(book.author)")
                }
            }
            .onDelete(perform: delete(at:))
        }
        .listRowSpacing(4)
        .overlay {
            if books.isEmpty {
                ContentUnavailableView {
                    Label("No books found!", systemImage: "book.fill")
                } description: {
                    Text("We could not find any books saved. Why not add a new one?")
                } actions: {
                    newBookView
                }
            }
        }
        .navigationTitle("What I'm Reading")
        .toolbarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                NavigationLink("Past readings", destination: {
                    PastReadingsView()
                })
                .padding()
            }
            ToolbarItem(placement: .topBarTrailing) {
                newBookView
            }
        }
        .navigationDestination(for: Book.self) { book in
            BookEditView(book: book)
        }
    }

    private var newBookView: some View {
        NavigationLink {
            BookEditView(book: Book(), isEditing: true)
        } label: {
            Label("Create new book", systemImage: "plus.circle.fill")
        }
    }

    private func delete(at indexes: IndexSet) {
        for index in indexes {
            let book = books[index]
            context.delete(book)
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .modelContainer(for: [Book.self], inMemory: true)
}
