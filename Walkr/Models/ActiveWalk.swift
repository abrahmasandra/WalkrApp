//
//  ActiveWalk.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/21/25.
//

import Foundation
import UIKit
import MapKit

/// Represents an active walk session, tracking real-time data such as route, distance, speed, and pins.
struct ActiveWalk {
    /// Unique identifier for the walk.
    let id: UUID
    
    /// Name of the walk (e.g. "Morning Walk")
    var walkName: String
    
    /// The start time of the walk.
    var startTime: Date
    
    /// The route of the walk, represented as an array of coordinates.
    var route: [CLLocationCoordinate2D]
    
    /// Total distance covered during the walk in meters.
    var distance: Double = 0
    
    /// Current speed of the user during the walk in meters per second.
    var currentSpeed: Double = 0
    
    /// Pins added during the walk, such as points of interest or landmarks.
    var pins: [Pin]
    
    /// Optional note associated with the walk.
    var note: String = ""
    
    /// Optional feeling or mood associated with the walk
    var feeling: String = ""
    
    /// The total duration of the walk in seconds, calculated from the start time to now.
    var duration: TimeInterval {
        return Date().timeIntervalSince(startTime)
    }
    
    /// The average speed during the walk in meters per second, calculated as `distance / duration`.
    var averageSpeed: Double {
        guard duration > 0 else { return 0 }
        return distance / duration
    }
    
    /// A formatted string representation of the total duration (e.g., "01:23:45").
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "00:00:00"
    }
        
    /// A formatted string representation of the total distance in kilometers (e.g., "5.23 km").
    var formattedDistance: String {
        return String(format: "%.2f", distance / 1000) + (" km")
    }
    
    /// Initializes a new `ActiveWalk` instance with default values or provided parameters.
    init(id: UUID = UUID(), walkName: String = "New Walk", startTime: Date = Date()) {
        self.id = id
        self.walkName = walkName
        self.startTime = startTime
        self.route = []
        self.distance = 0
        self.pins = []
    }
    
    /// Stores the last recorded time when a location was added to calculate speed.
    private var lastRecordedTime: Date?
    
    // MARK: - Methods
    
    /// Adds a new location to the route and updates distance and current speed.
    /// - Parameter location: The new location to add to the route.
    mutating func addLocation(_ location: CLLocationCoordinate2D) {
        route.append(location)
        if route.count > 1 {
            let lastIndex = route.count - 1
            
            // Update total distance covered during the walk.
            let newDistance = CLLocation(latitude: route[lastIndex-1].latitude, longitude: route[lastIndex-1].longitude)
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            self.distance += newDistance
            
            // Update current speed using time elapsed since last recorded time.
            if let lastTime = lastRecordedTime {
                let timeInterval = Date().timeIntervalSince(lastTime)
                if timeInterval > 0 {
                    self.currentSpeed = newDistance / timeInterval
                }
            }
        }
        
        lastRecordedTime = Date()
    }
    
    /// Adds a pin at a specific coordinate during the walk, optionally with a note and image.
    mutating func addPin(at coordinate: CLLocationCoordinate2D, note: String? = nil, image: UIImage? = nil) {
        let newPin = Pin(id: UUID(), coordinate: coordinate, note: note, image: image)
        pins.append(newPin)
    }
    
    /// Converts an active walk into a completed `Walk` object for storage or further use.
    func toWalk(user: User, endTime: Date, image: UIImage) -> Walk {
        Walk(id: id,
             user: user,
             walkName: walkName,
             date: startTime,
             distance: distance,
             duration: endTime.timeIntervalSince(startTime),
             route: route,
             pins: pins,
             image: image,
             note: note,
             feeling: feeling)
    }
}
