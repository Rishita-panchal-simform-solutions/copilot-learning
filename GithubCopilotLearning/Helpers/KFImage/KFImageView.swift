//
//  KFImageView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import Kingfisher
struct KFImageView<Placeholder: View> {
    private var urlString: String
    private var frame: CGSize
    private var processor: ImageProcessor
    let placeholder: Placeholder
    init(urlString: String, frame: CGSize, @ViewBuilder placeholder: () -> Placeholder) {
        self.urlString = urlString
        self.frame = frame
        self.processor = DownsamplingImageProcessor(size: frame) |> RoundCornerImageProcessor(cornerRadius: 0)
        self.placeholder = placeholder()
    }
}
extension KFImageView: View {
    var body: some View {
        KFImage.url(URL(string: urlString))
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .placeholder({
                placeholder
            })
            .frame(width: frame.width, height: frame.height)
    }
}