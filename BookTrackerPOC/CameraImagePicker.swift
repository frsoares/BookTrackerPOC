//
//  CameraImagePicker.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 22/05/26.
//

import SwiftUI

struct CameraImagePicker: UIViewControllerRepresentable {

    @Binding var selectedImage: Image?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .camera
        imgPicker.cameraCaptureMode = .photo
        imgPicker.delegate = context.coordinator
        return imgPicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraImagePicker

        init(with parent: CameraImagePicker) {
            self.parent = parent
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.selectedImage = Image(uiImage: image)
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: image)
            }
            parent.dismiss()
        }
    }

}
