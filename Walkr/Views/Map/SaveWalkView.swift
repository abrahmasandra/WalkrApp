//
//  SaveWalkView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//

import SwiftUI

struct SaveWalkView: View {
    @Binding var showingSaveWalkView: Bool
    @Binding var isRecording: Bool
    @Binding var activeWalk: ActiveWalk?
    
    @State private var walkName = ""
    @State private var walkNote = ""
    @State private var feeling: String = ""
    let feelings: [String] = ["😊", "😐", "😔", "😠"]
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Walk Summary")) {
                    Text("Duration: \(activeWalk?.formattedDuration ?? "00:00:00")")
                    Text("Distance: \(activeWalk?.formattedDistance ?? "0.00 km")")
                    Text("Pins: \(activeWalk?.pins.count ?? 0)")
                }
                
                Section(header: Text("Walk Name")) {
                    TextField("Enter Walk Name", text: $walkName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Add a Note")) {
                    TextEditor(text: $walkNote)
                        .frame(height: 100)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("How are you feeling?")) {
                    Picker("Feeling", selection: $feeling) {
                        ForEach(feelings, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Actions")) {
                    Button("Save Walk") {
                        print("Saving walk...")
                        var completedWalk: Walk?
                        
                        if var activeWalk = activeWalk {
                            activeWalk.walkName = walkName
                            activeWalk.note = walkNote
                            activeWalk.feeling = feeling
                            
                            completedWalk = activeWalk.toWalk(user: dataController.currentUser, endTime: Date(), image: UIImage(systemName: "photo")!)
                        }
                        
                        if let walk = completedWalk {
                            dataController.saveWalk(walk)
                            print("Walk saved to Core Data")
                        }
                                            
                        activeWalk = nil
                        isRecording = false
                        showingSaveWalkView = false
                        completedWalk = nil
                    }
                }
                
                Button(action: {
                    print("Resuming walk...")
                    // Resume walk
                    showingSaveWalkView = false
                    isRecording = true
                }) {
                    Text("Resume Walk")
                }
            }
            .navigationTitle("Save Walk")
        }
    }
}
