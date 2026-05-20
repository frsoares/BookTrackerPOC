//
//  BookEditView.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 11/05/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct BookEditView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Bindable var book: Book
    @State private var showingAlert = false
    @State private var showErrorAlert = false
    @State var isEditing = false

    @State private var selection: PhotosPickerItem?

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
            Section("Comments") {
                Text(book.review)
                    .multilineTextAlignment(.leading)
            }
            Section("Reference Image") {
                if let imagedata = book.imagedata {
                    if let uiImage = UIImage(data: imagedata) {
                        Image(uiImage: uiImage)
                            .resizable()
                        //                        .scaledToFit()
                            .aspectRatio(3/4, contentMode: .fit)
                    }
                } else {
                    let url = URL(
                        string: "https://upload.wikimedia.org/wikipedia/commons/b/bf/Zines-fromlondonsymp07.jpg"
                    )
                    AsyncImage(url: url)
                }
            }
        }
        .navigationTitle(book.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
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
                Section("Basic Info") {
                    HStack {
                        TextField("Book title:", text: $book.name, prompt: Text("The book's title"))
                        PhotosPicker(
                            selection: $selection,
                            matching: .images
                        ) {
                            if let imageData = book.imagedata {
                                if let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .frame(maxWidth: 100)
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.tint)
                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(Color.white)
                                }
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(maxWidth: 100)
                            }
                        }
                        .photosPickerStyle(.presentation)
                        .photosPickerDisabledCapabilities(.sensitivityAnalysisIntervention)
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
            ToolbarItem(placement: .primaryAction) {
                Button {
                    save()
                } label: {
                    Text("Save")
                }
                .foregroundStyle(.tint)
            }
        }
        .onChange(of: selection) {
            if let selection {
                Task {
                    do {
                        if let image = try await loadTransferrable(from: selection) {
                            // only updating if we manage to load the image, so we don't
                            // delete images that were loaded before for nothing
                            self.book.imagedata = image
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    private func loadTransferrable(from photoItem: PhotosPickerItem) async throws -> Data? {
        try await photoItem.loadTransferable(type: Data.self)
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
    NavigationStack {
        BookEditView(book: Book(name: "The Swift Programming Language", author: "Apple Inc.", review: "A great book"))
    }
}
