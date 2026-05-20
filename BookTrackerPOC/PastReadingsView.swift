//
//  PastReadingsView.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 11/05/26.
//

import SwiftUI
import SwiftData

struct PastReadingsView: View {

    @Environment(\.modelContext) var context
    @Query(
        filter: #Predicate<Book> { book in
            book.finished == true
        },
        animation: .interactiveSpring) var books: [Book]

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink {
                    BookEditView(book: book)
                } label: {
                    Text("\(book.name), by \(book.author)")
                }
            }
            .onDelete(perform: delete(at:))
        }
        .overlay {
            if books.isEmpty {
                ContentUnavailableView(
                    "No books read yeat",
                    systemImage: "bookmarks.slash",
                    description: Text(
                        "Read some books so there'll be something to show here!"
                    )
                )
            }
        }
        .navigationTitle("Past Readings")
        .navigationDestination(for: Book.self) { book in
            BookEditView(book: book)
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
    PastReadingsView()
}
