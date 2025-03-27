//
//  LocationManager.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/22/25.
//

import MapKit

/// A custom location manager class that integrates with `CLLocationManager` to handle location updates and region management.
/// It conforms to `ObservableObject` to allow SwiftUI views to react to changes in location data.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    /// The underlying `CLLocationManager` instance used to manage location updates.
    private let locationManager = CLLocationManager()
    
    /// The user's current location, updated whenever new location data is received.
    @Published var location: CLLocation?
    
    /// The region displayed on the map, updated based on the user's current location.
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.4241, longitude: -98.4936),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    /// Initializes the `LocationManager` instance and configures the `CLLocationManager`.
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        print("Initializing Location Manager")
        locationManager.requestAlwaysAuthorization()
    }
    
    /// Starts updating the user's location by enabling continuous location tracking.
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Stops updating the user's location to conserve battery life when tracking is not needed.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Delegate method called whenever new location data is available.
    /// Updates the `location` property and adjusts the map region based on the latest coordinates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        region.center = location.coordinate
    }
}
