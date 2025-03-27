//
//  WalkrApp.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//

import SwiftUI

@main
struct WalkrApp: App {
    @StateObject private var dataController = DataController() // Initialize DataController
    @State private var isDarkModeEnabled = false
    
    init() {
        // Set the initial launch date if it's the first time the app is launched
        if UserDefaults.standard.object(forKey: "Initial Launch") == nil {
            let firstLaunchDate = Date()
            UserDefaults.standard.set(firstLaunchDate, forKey: "Initial Launch")
            print("App launched for the first time on: \(firstLaunchDate)")
        } else {
            if let initialLaunchDate = UserDefaults.standard.object(forKey: "Initial Launch") as? Date {
                print("App was first launched on: \(initialLaunchDate)")
            }
        }
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataController)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
                .onAppear {
                    isDarkModeEnabled = UserDefaults.standard.bool(forKey: "darkmode_preference")
                }
        }
    }
}
