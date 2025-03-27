//
//  WalkDetailView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//

import SwiftUI
import MapKit

struct WalkDetailView: View {
    @State private var walk: Walk
    @State private var editingTitle = false
    @State private var newTitle: String
    
    @State private var mapPosition: MapCameraPosition
    
    @State private var showingDeleteConfirmation = false
    
    @EnvironmentObject var dataController: DataController
    
    @Environment(\.presentationMode) var presentationMode
    
    init(walk: Walk) {
        _walk = State(initialValue: walk)
        _newTitle = State(initialValue: walk.walkName)
        
        let center = walk.route.isEmpty ? CLLocationCoordinate2D(latitude: 29.4241, longitude: -98.4936) : walk.route[0]
        _mapPosition = State(initialValue: .region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))))
    }
    
    var body: some View {
        VStack {
            Map(position: $mapPosition) {
                UserAnnotation()
                ForEach(walk.pins) { pin in
                    Annotation(coordinate: pin.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.blue)
                    } label: {
                        Text(pin.note ?? "")
                    }
                }
                if !walk.route.isEmpty {
                    MapPolyline(coordinates: walk.route)
                        .stroke(.blue, lineWidth: 3)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .frame(height: 300)
            
            Spacer()
            
            // Walk Details Section (conditionally displayed)
            if (walk.feeling != nil && !walk.feeling!.isEmpty) ||
               (walk.note != nil && !walk.note!.isEmpty) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Walk Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.bottom, 5)
                    
                    HStack(alignment: .center, spacing: 15) {
                        if let emoji = walk.feeling, !emoji.isEmpty {
                            Text(emoji)
                                .font(.system(size: 50)) // Large emoji display
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                        }
                        
                        Spacer()
                        
                        if let note = walk.note, !note.isEmpty {
                            Text(note)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3) // Limit to 3 lines for better readability
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemGray6))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal, 10)
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 20) // Add vertical padding for better spacing
            }


            
            Spacer()
            
            // List or Placeholder
            if walk.pins.isEmpty {
                // Placeholder for no pins
                VStack(spacing: 20) {
                    Image(systemName: "mappin.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    Text("No Pins Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .padding()
                .padding(.bottom, 50)
            } else {
                // List of Pins
                List {
                    ForEach(walk.pins) { pin in
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(pin.note ?? "No note")
                                    .font(.headline)
                                if let image = pin.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(InsetGroupedListStyle()) // Makes the list visually appealing
            }
        }
        .navigationTitle(walk.walkName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    print("Editing Walk Title")
                    editingTitle = true
                }) {
                    Text("Edit")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    print("Clicked Delete Walk")
                    showingDeleteConfirmation = true
                } label: {
                    Label("Delete Walk", systemImage: "trash")
                }
                .alert("Delete Walk", isPresented: $showingDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        print("Actually deleting walk")
                        dataController.deleteWalk(walk)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to delete this walk? This action cannot be undone.")
                }
            }
        }
        .alert("Edit Walk Title", isPresented: $editingTitle) {
            TextField("Walk Title", text: $newTitle)
            Button("Save") {
                print("Saving new title")
                walk.walkName = newTitle
                dataController.saveWalk(walk) // Save to Core Data
                editingTitle = false
            }
            Button("Cancel", role: .cancel) {
                newTitle = walk.walkName
                editingTitle = false
            }
        }
    }
}

#Preview {
    let walk = Walk(
        id: UUID(),
        user: User(userName: "test", email: "test@test.com"),
        walkName: "Morning Walk",
        date: Date(),
        distance: 1000,
        duration: 3600,
        route: [],
        pins: [],
        image: nil,
        note: "Great walk!",
        feeling: "😊"
    )
    WalkDetailView(walk: walk)
}
