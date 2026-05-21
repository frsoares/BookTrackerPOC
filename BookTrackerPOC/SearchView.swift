//
//  SearchView.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 20/05/26.
//

import SwiftUI
import SwiftData

struct SearchView: View {

    @Query(animation: .interactiveSpring) private var books: [Book]

    init(searchText: String = "", books: [Book] = []) {
        _books = Query(
            filter: Book.predicate(searchText: searchText),
            sort: \.name,
            order: .forward
        )
    }
    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(book.name) {
                    BookEditView(
                        book: book,
                        isEditing:  false
                    )
                }
            }
        }
    }
}

#Preview {
    SearchView()
    .modelContainer(for: Book.self)
}
