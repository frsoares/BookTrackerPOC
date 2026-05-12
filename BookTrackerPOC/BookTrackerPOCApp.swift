//
//  BookTrackerPOCApp.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 11/05/26.
//

import SwiftUI
import SwiftData

@main
struct BookTrackerPOCApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
        .modelContainer(for: [Book.self])
    }
}
