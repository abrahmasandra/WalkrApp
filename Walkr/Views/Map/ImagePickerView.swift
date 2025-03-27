//
//  ImagePickerView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/22/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    /// Selected image
    @Binding var image: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Label("Select Photo", systemImage: "photo")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
            }
        }
    }
}
