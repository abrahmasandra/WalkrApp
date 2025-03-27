//
//  Pin.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//

import SwiftUI
import MapKit

/// Represents a pin on the map, containing location data and optional metadata such as title, note, and image.
struct Pin: Identifiable {
    /// Unique identifier for the pin.
    let id: UUID
    
    /// The geographic coordinate of the pin.
    let coordinate: CLLocationCoordinate2D
    
    /// Optional title for the pin (e.g., a name or label).
    var title: String?
    
    /// Optional note associated with the pin (e.g., a description or observation).
    var note: String?
    
    /// Optional image associated with the pin (e.g., a photo of the location).
    var image: UIImage?
}

/// A wrapper class for `Pin` that conforms to `NSSecureCoding`.
/// Used to encode and decode `Pin` objects for secure storage in Core Data.
class PinWrapper: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    let id: UUID
    
    var coordinateWrapper: CoordinateWrapper
    var title: String?
    var note: String?
    var imageData: Data?

    /// Initializes a `PinWrapper` from a `Pin` object.
    /// - Parameter pin: The `Pin` object to wrap for encoding/decoding purposes.
    init(pin: Pin) {
        id = pin.id
        coordinateWrapper = CoordinateWrapper(coordinate: pin.coordinate)
        title = pin.title
        note = pin.note
        if let image = pin.image {
            imageData = image.pngData()
        }
    }

    /// Converts the `PinWrapper` back into a `Pin` object.
    var pin: Pin {
        var image: UIImage?
        if let data = imageData {
            image = UIImage(data: data)
        }
        return Pin(id: id, coordinate: coordinateWrapper.coordinate, title: title, note: note, image: image)
    }

    /// Decodes a `PinWrapper` object from an archive.
    /// - Parameter coder: The decoder used to extract data from storage.
    required init?(coder: NSCoder) {
        // Decode UUID from its string representation.
        guard let idString = coder.decodeObject(forKey: "id") as? String else {
            return nil
        }
        guard let id = UUID(uuidString: idString) else {
            return nil
        }
        
        // Decode the wrapped coordinate object.
        guard let coordinateWrapper = coder.decodeObject(of: CoordinateWrapper.self, forKey: "coordinate") else {
            return nil
        }
        self.id = id
        self.coordinateWrapper = coordinateWrapper
        
        // Decode optional properties (title, note, and image data).
        title = coder.decodeObject(forKey: "title") as? String
        note = coder.decodeObject(forKey: "note") as? String
        imageData = coder.decodeObject(forKey: "imageData") as? Data
    }

    /// Encodes the `PinWrapper` object into an archive for storage.
    /// - Parameter coder: The encoder used to store data securely.
    func encode(with coder: NSCoder) {
        coder.encode(id.uuidString, forKey: "id")
        coder.encode(coordinateWrapper, forKey: "coordinate")
        coder.encode(title, forKey: "title")
        coder.encode(note, forKey: "note")
        coder.encode(imageData, forKey: "imageData")
    }
}




