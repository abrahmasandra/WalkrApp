//
//  DataController.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//

import CoreData
import MapKit


/// Manages Core Data operations and user-related data for the Walkr app.
class DataController: ObservableObject {
    /// Core Data persistent container for managing the data model.
    let container: NSPersistentContainer
    
    /// The currently logged-in user.
    @Published var currentUser: User = User.defaultUser
    
    /// List of walks fetched from Core Data.
    @Published var walks: [Walk] = []
    
    /// Walks sorted by date in descending order.
    var sortedWalks: [Walk] {
        return walks.sorted { $0.date > $1.date }
    }
    
    /// Initializes the data controller, sets up Core Data, and fetches initial data.
    init() {
        container = NSPersistentContainer(name: "WalkrModels")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Register custom value transformers for Core Data attributes.
        ValueTransformer.setValueTransformer(CoordinateTransformer(),
                                             forName: .coordinateTransformerName)
        ValueTransformer.setValueTransformer(PinTransformer(),
                                             forName: .pinTransformerName)
        
        // Load persistent stores and handle errors if they occur.
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
            #if DEBUG
            // Debugging: Print the SQLite file location.
            if let url = self.container.persistentStoreCoordinator.persistentStores.first?.url {
                    print("SQLite file location: \(url.absoluteURL.path(percentEncoded: false))")
                }
            #endif
        }
        
        
        // Fetch the current user and their associated walks.
        currentUser = self.fetchUser()
        self.fetchWalks { walks in
            self.walks = walks
            self.currentUser.walks = walks
            
            print("Walks loaded: \(walks)")
        }
    }
    
    /// Saves changes in the Core Data context to persistent storage.
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    /// Fetches all walks from Core Data and updates the `walks` property.
    /// - Parameter completion: A closure to handle the fetched walks on the main thread.
    func fetchWalks(completion: @escaping ([Walk]) -> Void) {
        container.performBackgroundTask { backgroundContext in
            let fetchRequest: NSFetchRequest<WalkModel> = WalkModel.fetchRequest()
            
            do {
                // Fetch data in the background context
                let walkModels = try backgroundContext.fetch(fetchRequest)
                
                // Convert WalkModel to Walk objects
                let walks = walkModels.map { Walk(from: $0) }
                
                // Ensure changes are merged into the main context
                DispatchQueue.main.async {
                    completion(walks)
                }
            } catch {
                print("Error fetching WalkModel entities: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    /// Saves a new or updated walk to Core Data and refreshes the cached walks list.
    /// - Parameter walk: The walk object to save or update in Core Data.
    func saveWalk(_ walk: Walk) {
        container.performBackgroundTask { context in
            // Check if the walk already exists in Core Data
            let fetchRequest: NSFetchRequest<WalkModel> = WalkModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", walk.id as CVarArg)

            do {
                let existingWalks = try context.fetch(fetchRequest)
                let walkModel: WalkModel

                if let existingWalk = existingWalks.first {
                    walkModel = existingWalk
                } else {
                    walkModel = WalkModel(context: context)
                }
                            
                walkModel.update(from: walk)

                try context.save()

                // Update cached walks array on the main thread
                DispatchQueue.main.async {
                    self.fetchWalks { walks in
                        self.walks = walks
                        self.currentUser.walks = walks
                        
                        print("Walk saved. Updated walks: \(walks)")
                    }
                }
            } catch {
                print("Error saving walk: \(error)")
            }
        }
    }
    
    /// Deletes walk from Core Data and refreshes the cached walks list.
    /// - Parameter walk: The walk object to delete in Core Data.
    func deleteWalk(_ walk: Walk) {
        container.performBackgroundTask { context in
            // Check if the walk already exists in Core Data
            let fetchRequest: NSFetchRequest<WalkModel> = WalkModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", walk.id as CVarArg)

            do {
                let existingWalks = try context.fetch(fetchRequest)

                if let walkToDelete = existingWalks.first {
                    context.delete(walkToDelete)
                    try context.save()
                    
                    // Update cached walks array on the main thread
                    DispatchQueue.main.async {
                        self.fetchWalks { walks in
                            self.walks = walks
                            self.currentUser.walks = walks
                            
                            print("Walk deleted. Updated walks: \(walks)")
                        }
                    }
                } else {
                    print("No walk found with the provided ID to delete.")
                }
                            
            } catch {
                print("Error deleting walk: \(error)")
            }
        }
    }
    
    /// Fetches the current user from `UserDefaults`.
    /// - Returns: The current user object or a default user if not found.
    func fetchUser() -> User {
        let defaults = UserDefaults.standard
        if let userDictionary = defaults.dictionary(forKey: "currentUser") {
            return User(from: userDictionary) ?? User.defaultUser
        }
        return User.defaultUser
    }
    
    /// Saves a user's data to `UserDefaults` and updates the `currentUser` property.
    /// - Parameter user: The user object to save.
    func saveUser(from user: User) {
        let userDictionary = user.toDictionary() // Convert User to dictionary
        UserDefaults.standard.set(userDictionary, forKey: "currentUser") // Save to UserDefaults
        
        // Automatically update the `currentUser` property with the new user data.
        self.currentUser = user
    }
}

/// Defines custom transformer names for Core Data attributes as extensions of `NSValueTransformerName`.
extension NSValueTransformerName {
    static let coordinateTransformerName = NSValueTransformerName(rawValue: "CoordinateTransformer")
    static let pinTransformerName = NSValueTransformerName(rawValue: "PinTransformer")
}
