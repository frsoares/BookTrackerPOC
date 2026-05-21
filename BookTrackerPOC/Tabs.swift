//
//  Tabs.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 20/05/26.
//

import SwiftUI
import SwiftData

struct Tabs: View {

    @State var searchText: String = ""

    var body: some View {
        TabView {
            Tab("Reading", systemImage: "eye") {
                NavigationStack {
                    ContentView()
                }
            }

            Tab ("Past Readings", systemImage: "clock") {
                NavigationStack {
                    PastReadingsView()
                }
            }

            Tab(role: .search) {
                NavigationStack {
                    SearchView(searchText: searchText)
                        .searchable(text: $searchText)
                }
            }
        }
        .tabViewSearchActivation(.searchTabSelection)
    }
}

#Preview {
    Tabs()
        .modelContainer(
            for: Book.self,
            inMemory: true
        )
}
