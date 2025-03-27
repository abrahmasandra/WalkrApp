//
//  WalkTrackingView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//


import SwiftUI
import MapKit
import PhotosUI

struct MapView: View {
    @Binding var walk: ActiveWalk?
    @Binding var position: MapCameraPosition
    
    var currentLocation: CLLocationCoordinate2D?

    var body: some View {
        Map(position: $position) {
            // Display the user's current location on the map
            UserAnnotation()
            
            // Display the dropped pins on the map
            if var walk = walk {
                ForEach(walk.pins.indices, id: \.self) { index in
                    Annotation(coordinate: walk.pins[index].coordinate) {
                        PinButton(pin: Binding(
                            get: { walk.pins[index] },
                            set: { newValue in
                                walk.pins[index] = newValue
                                self.walk?.pins[index] = newValue
                            }
                        ))
                    } label: {
                        Text(walk.pins[index].title ?? "")
                    }
                }
            }
            
            // Display the route on the map
            if let route = walk?.route, route.count > 1 {
                MapPolyline(coordinates: route)
                    .stroke(Color.blue, lineWidth: 4)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .mapControls {
            MapUserLocationButton()
        }
    }
}
