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
    var searchText: String

    init(searchText: String = "", books: [Book] = []) {
        _books = Query(
            filter: Book.predicate(searchText: searchText),
            sort: \.name,
            order: .forward
        )
        self.searchText = searchText
    }
    var body: some View {
        VStack {
            if searchText == "" {
                Button("Pesquise algo") {

                }
                .navigationTitle("Search")
            }
            else if books.isEmpty {
                ContentUnavailableView.search
                    .navigationTitle("Search")
            } else {
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
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .toolbarVisibility(.visible, for: .navigationBar)
    }
}

#Preview {
    SearchView()
    .modelContainer(for: Book.self)
}
