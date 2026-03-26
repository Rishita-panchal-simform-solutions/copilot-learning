//
//  LibraryPicker.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import PhotosUI
import UIKit
// MARK: - SwiftUI View
struct LibraryPicker: UIViewControllerRepresentable {
    let filter: PHPickerFilter
    @Binding var url: [URL]
    @Binding var preselected: [URL: String]
    @Binding var error: LibraryPickerError?
    let selectionLimit: Int
    let fileSizeLimit: UInt?
    var didCancel: (() -> Void)?
    init(
        url: Binding<[URL]>,
        preselected: Binding<[URL: String]> = .constant([:]),
        error: Binding<LibraryPickerError?> = .constant(nil),
        selectionLimit: Int = 1,
        filter: PHPickerFilter,
        fileSizeLimit: UInt? = nil,
        didCancel: (() -> Void)? = nil) {
            self.filter = filter
            self.didCancel = didCancel
            self.selectionLimit = selectionLimit
            self.fileSizeLimit = fileSizeLimit
            _url = url
            _preselected = preselected
            _error = error
    }
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = selectionLimit
        config.filter = filter
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = preselected.values.filter({ _ in true })
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        return coordinator
    }
}
// MARK: - Static Properties and Functions
extension LibraryPicker {
    static let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("PickerItems")
    static func createFolderPickerItems() {
        do {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: LibraryPicker.path.path, isDirectory: &isDir) && isDir.boolValue {
                let fileURLs = try FileManager.default.contentsOfDirectory(
                    at: LibraryPicker.path,
                    includingPropertiesForKeys: nil,
                    options: .skipsHiddenFiles)
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } else {
                try FileManager.default.createDirectory(
                    at: LibraryPicker.path,
                    withIntermediateDirectories: false,
                    attributes: nil)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
// MARK: - Coordinator
extension LibraryPicker {
    class Coordinator: PHPickerViewControllerDelegate {
        var parent: LibraryPicker
        init(_ parent: LibraryPicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                self.parent.didCancel?()
                picker.dismiss(animated: true)
            }
            for result in results {
                processResult(result: result) { [weak self] error in
                    if let error {
                        DispatchQueue.main.async {
                            self?.parent.error = error
                        }
                    }
                    picker.dismiss(animated: true)
                }
            }
            picker.dismiss(animated: true)
        }
        private func processResult(result: PHPickerResult, onFinish: @escaping (LibraryPickerError?) -> Void) {
            let itemProvider = result.itemProvider
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                processAsset(item: result, type: .image, onFinish: onFinish)
            } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                processAsset(item: result, type: .movie, onFinish: onFinish)
            }
        }
        private func processAsset(item: PHPickerResult, type: UTType, onFinish: @escaping (LibraryPickerError?) -> Void) {
            let itemProvider = item.itemProvider
            itemProvider.loadFileRepresentation(forTypeIdentifier: type.identifier) { [weak self] url, error in
                guard let self = self else { return }
                do {
                    guard let url = url, error == nil else {
                        throw error ?? NSError(domain: NSFileProviderErrorDomain, code: -1, userInfo: nil)
                    }
                    // Check file size
                    if let fileSizeLimit = self.parent.fileSizeLimit, url.fileSize() > fileSizeLimit {
                        DispatchQueue.main.async {
                            onFinish(.fileSizeLimitExceeded)
                        }
                        return
                    }
                    let localURL = LibraryPicker.path.appendingPathComponent(url.lastPathComponent)
                    if FileManager.default.fileExists(atPath: localURL.path) {
                        try FileManager.default.removeItem(at: localURL)
                    }
                    try FileManager.default.copyItem(at: url, to: localURL)
                    DispatchQueue.main.async {
                        self.parent.preselected[localURL] = item.assetIdentifier
                        self.parent.url.append(localURL)
                        onFinish(nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.parent.url = []
                        onFinish(.other(error: error))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//                            showSnackBar(.errorMsg(text: "txt_could_not_pick_asset_from_library".localized))
                        })
                    }
                }
            }
        }
    }
}
// MARK: - Error
extension LibraryPicker {
    enum LibraryPickerError: Error {
        case fileSizeLimitExceeded
        case other(error: Error)
    }
}