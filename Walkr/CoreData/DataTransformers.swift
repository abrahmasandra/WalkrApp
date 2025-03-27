//
//  DataTransformers.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//

import Foundation
import MapKit


/// A custom value transformer for converting an array of `CLLocationCoordinate2D`
/// objects to and from a serialized data format for Core Data storage.
@objc(CoordinateTransformer)
final class CoordinateTransformer: ValueTransformer {
    /// Specifies the class of the transformed value (`NSData`).
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    /// Indicates that reverse transformation is supported.
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    /// Transforms an array of `CLLocationCoordinate2D` into serialized data.
    /// - Parameter value: The value to transform (expected to be `[CLLocationCoordinate2D]`).
    /// - Returns: Serialized data representing the array of coordinates, or `nil` if transformation fails.
    override func transformedValue(_ value: Any?) -> Any? {
        guard let coordinates = value as? [CLLocationCoordinate2D] else { return nil }

        // Convert [CLLocationCoordinate2D] to [CoordinateWrapper]
        let wrappedCoordinates = coordinates.map { CoordinateWrapper(coordinate: $0) }

        // Archive the wrapped coordinates
        return try? NSKeyedArchiver.archivedData(withRootObject: wrappedCoordinates, requiringSecureCoding: true)
    }

    /// Reverses the transformation by converting serialized data back into an array of `CLLocationCoordinate2D`.
    /// - Parameter value: The serialized data to transform back (expected to be `Data`).
    /// - Returns: An array of `CLLocationCoordinate2D`, or `nil` if reverse transformation fails.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        // Unarchive the wrapped coordinates
        if let wrappedCoordinates = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: CoordinateWrapper.self, from: data) {
            
            // Convert [CoordinateWrapper] back to [CLLocationCoordinate2D]
            return wrappedCoordinates.map { $0.coordinate }
        }

        return nil
    }
}

/// A custom value transformer for converting an array of `Pin` objects
/// to and from a serialized data format for Core Data storage.
@objc(PinTransformer)
final class PinTransformer: ValueTransformer {
    /// Specifies the class of the transformed value (`NSData`).
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    /// Indicates that reverse transformation is supported.
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    
    /// Transforms an array of `Pin` objects into serialized data.
    /// - Parameter value: The value to transform (expected to be `[Pin]`).
    /// - Returns: Serialized data representing the array of pins, or `nil` if transformation fails.
    override func transformedValue(_ value: Any?) -> Any? {
        guard let pins = value as? [Pin] else { return nil }
        
        // Convert [Pin] to [PinWrapper]
        let wrappedPins = pins.map { PinWrapper(pin: $0) }

        // Archive the wrapped pins
        return try? NSKeyedArchiver.archivedData(withRootObject: wrappedPins, requiringSecureCoding: true)
    }

    
    /// Reverses the transformation by converting serialized data back into an array of `Pin`.
    /// - Parameter value: The serialized data to transform back (expected to be `Data`).
    /// - Returns: An array of `Pin`, or `nil` if reverse transformation fails.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        // Unarchive the wrapped pins
        if let wrappedPins = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: PinWrapper.self, from: data) {
            // Convert [PinWrapper] back to [Pin]
            return wrappedPins.map { $0.pin }
        } else {
            print("Failed to unarchive pin data")
        }

        return nil
    }
}

