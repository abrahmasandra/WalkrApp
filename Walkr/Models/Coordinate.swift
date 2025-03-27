//
//  Coordinate.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//

import MapKit

/// A wrapper class for `CLLocationCoordinate2D` that conforms to `NSSecureCoding`.
/// Used to encode and decode coordinate data for secure storage.
class CoordinateWrapper: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var coordinate: CLLocationCoordinate2D

    /// Initializes a `CoordinateWrapper` with a given coordinate.
    /// - Parameter coordinate: The `CLLocationCoordinate2D` to wrap.
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    
    /// Decodes a `CoordinateWrapper` object from an archive.
    /// - Parameter coder: The decoder used to extract data.
    required init?(coder: NSCoder) {
        let latitude = coder.decodeDouble(forKey: "latitude")
        let longitude = coder.decodeDouble(forKey: "longitude")
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Encodes the `CoordinateWrapper` object into an archive.
    /// - Parameter coder: The encoder used to store data.
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: "latitude")
        coder.encode(coordinate.longitude, forKey: "longitude")
    }
}
