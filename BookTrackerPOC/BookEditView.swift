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

    @State private var date: Date = .now

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
                HStack {
                    Spacer()
                    bookImage
                    Spacer()
                }
            }
            .listRowBackground(EmptyView())
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

    @ViewBuilder
    private var photoPickerBody: some View {
        if let imageData = book.imagedata {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: 100)
                    .clipShape(.rect(cornerRadius: 8))
            }
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.tint)
                Image(systemName: "photo.badge.plus.fill")
                    .foregroundStyle(Color.white)
                    .font(.largeTitle)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .frame(maxWidth: 80)
        }
    }

    @ViewBuilder
    var bookImage: some View {
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

    var editBody: some View {
        VStack {
            Form {
                Section("Basic Info") {
                    HStack {
                        TextField("Book title:", text: $book.name, prompt: Text("The book's title"))
                        PhotosPicker(
                            selection: $selection,
                            matching: .images
                        ) {
                            photoPickerBody
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
                    if let image = try? await loadTransferrable(from: selection) {
                        // only updating if we manage to load the image, so we don't
                        // delete images that were loaded before for nothing
                        self.book.imagedata = image
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

#Preview("Diss") {
    DisclosureGroup("Textinho") {
        HStack {
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")
            Spacer()
        }
    }
}

struct VerticalSmileys: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    let simbolos = [""]

    var body: some View {
         ScrollView {
             LazyVGrid(columns: columns) {
                 ForEach(0x1f600...0x1f679, id: \.self) { value in
//                     Text(String(format: "%x", value))
                     Button {
                         print("tocou num emoji")
                     } label: {
                         Text(emoji(value))
                             .font(.largeTitle)
                             .background {
                                 RoundedRectangle(cornerRadius: 16)
                                     .fill(.ultraThinMaterial)
                             }
                             .glassEffect(in: .rect(cornerRadius: 8))
                             .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                     }
                 }
             }
         }
    }


    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}

#Preview("sorrisos") {
    VerticalSmileys()
}
