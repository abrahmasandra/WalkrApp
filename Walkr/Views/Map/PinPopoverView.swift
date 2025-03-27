//
//  PinPopoverView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/22/25.
//

import SwiftUI
import PhotosUI

struct PinPopoverView: View {
    /// The `Pin` object being edited, passed as a binding to allow two-way data flow.
    @Binding var pin: Pin

    /// State variables to track edit status of title and note
    @State private var isEditingTitle = false
    @State private var isEditingNote = false
    
    @State private var popoverSize = CGSize(width: 300, height: 300)
    
    /// Draft storage before user saves
    @State private var draftTitle: String
    @State private var draftNote: String
    @State private var draftImage: UIImage?
    
    @State private var showingImagePicker = false
    
    /// Environment variable to handle dismissing the popover view.
    @Environment(\.dismiss) private var dismiss
    
    @State private var imageSize = 288.0
    
    /// Initializes the `PinPopoverView` with a binding to a `Pin` object.
    /// - Parameter pin: A binding to the `Pin` object being edited.
    init(pin: Binding<Pin>) {
        self._pin = pin
        self._draftTitle = State(initialValue: pin.wrappedValue.title ?? "")
        self._draftNote = State(initialValue: pin.wrappedValue.note ?? "")
        self._draftImage = State(initialValue: pin.wrappedValue.image)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                header
                titleSection
                noteSection
                imageSection
                saveButton
            }
            .padding()
        }
        .frame(idealWidth: 300)
        .background(Color(.secondarySystemBackground)) // Modern background
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    /// The header section containing a close button to dismiss the view.
    private var header: some View {
        HStack(alignment: .top) {
            Spacer()

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }

    /// The section for editing the title of the pin.
    private var titleSection: some View {
        VStack(alignment: .leading) {
            Text("Title:")
                .font(.headline)
                .foregroundColor(.primary)
            TextField("Enter title", text: $draftTitle)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    /// The section for editing the note associated with the pin.
    private var noteSection: some View {
        VStack(alignment: .leading) {
            Text("Note:")
                .font(.headline)
                .foregroundColor(.primary)

            TextEditor(text: $draftNote)
                .frame(height: 100)
                .border(Color(.separator), width: 1) // Use system separator
                .cornerRadius(8)
        }
    }

    /// The section for displaying and selecting an image associated with the pin.
    private var imageSection: some View {
        VStack(alignment: .leading) {
            Text("Image:")
                .font(.headline)
                .foregroundColor(.primary)

            if let image = draftImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(8)
            } else {
                Text("No image selected")
                    .italic()
                    .foregroundColor(.gray)
            }
            
            ImagePicker(image: $draftImage)
        }
    }

    /// The save button that updates the `Pin` object with edited details and dismisses the view.
    private var saveButton: some View {
        HStack {
            Spacer()
            Button("Save") {
                print("Saving pin details...")
                savePinDetails()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    /// Saves the edited details (title, note, and image) back to the `Pin` object.
    private func savePinDetails() {
        pin.title = draftTitle
        pin.note = draftNote
        pin.image = draftImage
    }
}


