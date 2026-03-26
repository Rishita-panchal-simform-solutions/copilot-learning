//
//  ImagePicker.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var imageURL: URL?
    @Binding var gifURL: URL?
    @Binding var videoURL: URL?
    var typePicker: UIImagePickerController.SourceType
    var cameraDevice: UIImagePickerController.CameraDevice?
    var allowEdit = true
    var allowVideo = false
    var didCancel: (() -> Void)?
    var onCompleted: (() -> Void)?
    init(
        image: Binding<UIImage?> = .constant(nil),
        imageURL: Binding<URL?> = .constant(nil),
        gifURL: Binding<URL?> = .constant(nil),
        videoURL: Binding<URL?> = .constant(nil),
        typePicker: UIImagePickerController.SourceType,
        allowEdit: Bool = true,
        allowVideo: Bool = false,
        cameraDevice: UIImagePickerController.CameraDevice? = nil,
        didCancel: (() -> Void)? = nil,
        onCompleted: (() -> Void)? = nil
    ) {
        _image = image
        _imageURL = imageURL
        _gifURL = gifURL
        _videoURL = videoURL
        self.typePicker = typePicker
        self.allowEdit = allowEdit
        self.allowVideo = allowVideo
        self.cameraDevice = cameraDevice
        self.didCancel = didCancel
        self.onCompleted = onCompleted
    }
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        var didCancel: (() -> Void)?
        var onCompleted: (() -> Void)?
        init(_ parent: ImagePicker, _ didCancel: (() -> Void)? = nil, _ onCompleted: (() -> Void)? = nil) {
            self.parent = parent
            self.didCancel = didCancel
            self.onCompleted = onCompleted
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            didCancel?()
            picker.dismiss(animated: true)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Video
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                parent.videoURL = videoURL
                parent.image = nil
                parent.imageURL = nil
                parent.gifURL = nil
            // GIF
            } else if let gifURL = info[.imageURL] as? URL, gifURL.pathExtension.lowercased() == "gif" {
                parent.gifURL = gifURL
                parent.videoURL = nil
                parent.image = nil
                parent.imageURL = nil
            // Static Image
            } else {
                if let editedImage = info[.editedImage] as? UIImage {
                    parent.image = editedImage
                } else if let originalImage = info[.originalImage] as? UIImage {
                    parent.image = originalImage
                }
                if let imageURL = info[.imageURL] as? URL {
                    parent.imageURL = imageURL
                }
                parent.gifURL = nil
                parent.videoURL = nil
            }
            picker.dismiss(animated: true) {
                self.onCompleted?()
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, self.didCancel, self.onCompleted)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = typePicker
        picker.allowsEditing = allowEdit
        if typePicker == .camera {
            picker.cameraDevice = cameraDevice ?? .rear
        }
        if allowVideo {
            picker.mediaTypes = ["public.image", "public.movie"]
        }
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        uiViewController.delegate = context.coordinator
    }
}