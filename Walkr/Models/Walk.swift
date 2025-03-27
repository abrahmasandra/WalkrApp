//
//  Walk.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//


import Foundation
import CoreLocation
import UIKit
import CoreData

/// Represents a completed or ongoing walk, including details such as route, pins, distance, and duration.
@Observable class Walk: Identifiable {
    /// Unique identifier for the walk.
    let id: UUID
    
    /// Name of the walk (e.g., "Morning Walk").
    var walkName: String
    
    /// Date when the walk occurred.
    var date: Date
    
    /// Total distance covered during the walk in meters.
    var distance: Double
    
    /// Total duration of the walk in seconds.
    var duration: TimeInterval
    
    /// Route of the walk represented as an array of geographic coordinates.
    var route: [CLLocationCoordinate2D]
    
    /// Pins added during the walk, such as points of interest or landmarks.
    var pins: [Pin]
    
    /// Optional image associated with the walk (e.g., a snapshot or summary photo). Not currently used -- will update in future
    var image: UIImage?
    
    /// Optional note describing the walk (e.g., observations or reflections).
    var note: String?
    
    /// Optional feeling or mood associated with the walk.
    var feeling: String?
    
    /// The user associated with this walk. Defaults to `User.defaultUser`.
    var user: User = User.defaultUser

    /// Initializes a new `Walk` instance with all required properties.
    init(id: UUID = UUID(), user: User, walkName: String, date: Date, distance: Double, duration: TimeInterval, route: [CLLocationCoordinate2D], pins: [Pin], image: UIImage? = nil, note: String? = "", feeling: String? = "") {
        self.id = id
        self.user = user
        self.walkName = walkName
        self.date = date
        self.distance = distance
        self.duration = duration
        self.route = route
        self.pins = pins
        self.image = image
        
        self.note = note
        self.feeling = feeling
    }
}

// MARK: - Walk Formatting Utilities

extension Walk {
    /// Formats the total duration of the walk into a human-readable string (e.g., "01:23:45").
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "00:00:00"
    }
    
    /// Formats the total distance covered during the walk into kilometers with two decimal places (e.g., "5.23 km").
    var formattedDistance: String {
        return String(format: "%.2f", distance / 1000) + (" km")
    }
}

// MARK: - Core Data Integration

extension Walk {
    /// Convenience initializer to create a `Walk` instance from a Core Data `WalkModel`.
   /// This method transforms stored Core Data attributes back into their original types.
   /// - Parameter walkModel: The Core Data model representing a stored walk.
    convenience init(from walkModel: WalkModel) {
        // Decode route using CoordinateTransformer
        var route: [CLLocationCoordinate2D] = []
        if let routeTransformer = ValueTransformer(forName: .coordinateTransformerName) {
            route = routeTransformer.reverseTransformedValue(walkModel.route) as? [CLLocationCoordinate2D] ?? []
            
            print("Route read from CoreData: \(route)")
        }
        
        // Decode pins using PinTransformer
        var pins: [Pin] = []
        if let pinTransformer = ValueTransformer(forName: .pinTransformerName) {
            pins = pinTransformer.reverseTransformedValue(walkModel.pins) as? [Pin] ?? []
            
            print("Pins read from CoreData: \(pins)")
        }

        // Convert stored image data back into a UIImage if available.
        let image = UIImage(data: walkModel.image ?? Data())

        
        // Initialize a new `Walk` object using decoded data and default values for missing fields.
        self.init(
            id: walkModel.id ?? UUID(),
            user: User.defaultUser,
            walkName: walkModel.walkName ?? "",
            date: walkModel.date ?? Date(),
            distance: walkModel.distance,
            duration: walkModel.duration,
            route: route,
            pins: pins,
            image: image,
            note: walkModel.note,
            feeling: walkModel.feeling
        )
    }
}
