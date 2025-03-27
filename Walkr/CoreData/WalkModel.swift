//
//  WalkModel.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/13/25.
//

import Foundation
import CoreData
import MapKit

extension WalkModel {
    /// Updates the properties of a `WalkModel` instance using data from a `Walk` object.
    /// This method maps the attributes of a `Walk` object to the corresponding Core Data model fields.
    func update(from walk: Walk) {
        self.id = walk.id
        self.walkName = walk.walkName
        self.date = walk.date
        self.distance = walk.distance
        self.duration = walk.duration
        
        // Use the ValueTransformer to set route
        if let routeTransformer = ValueTransformer(forName: .coordinateTransformerName) {
            self.route = routeTransformer.transformedValue(walk.route) as? NSData
        }

        // Use the ValueTransformer to set pins
        if let pinTransformer = ValueTransformer(forName: .pinTransformerName) {
            // print("Pins recorded in walk: \(walk.pins)")
            self.pins = pinTransformer.transformedValue(walk.pins) as? NSData
        }
        
        self.image = walk.image?.pngData() // Convert UIImage to Data
        self.note = walk.note
        self.feeling = walk.feeling
    }
}
