//
//  MapView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//


import MapKit
import SwiftUI

struct RecordWalkView: View {
    @State private var isRecording = false
    @State private var activeWalk: ActiveWalk?
        
    @StateObject private var locationManager = LocationManager()
    
    @State private var mapRegion =
    MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.4241, longitude: -98.4936), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    
    /// Timer to periodically update the map's region.
    let timer = Timer.publish(every: 10, tolerance: 2, on: .main, in: .common).autoconnect()
    
    /// Tracks whether the initial location has been set on the map.
    @State var initialLocationSet: Bool = false
    
    /// Tracks whether the `SaveWalkView` should be displayed.
    @State private var showingSaveWalkView = false
        
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Map view displaying the current region and walk route.
            MapView(walk: $activeWalk,
                    position: $mapRegion,
                    currentLocation: locationManager.location?.coordinate)
            .mapControlVisibility(.hidden)
            .ignoresSafeArea()
            
            
            // Overlay containing controls for recording and managing the walk.
            VStack {
                if isRecording {
                    WalkHUD(activeWalk: $activeWalk) // displays walk stats
                }
                
                Spacer()
                
                HStack {
                    // Drop Pin Button (left side, only visible when recording)
                   if isRecording {
                       Button(action: dropPin) {
                           Image(systemName: "mappin")
                               .padding()
                               .background(Color.white)
                               .clipShape(Circle())
                               .shadow(radius: 4) // Adds a subtle shadow for better visibility
                       }
                   } else {
                       Spacer() // Placeholder to maintain consistent layout
                           .frame(width: 60) // Same width as the button to avoid shifting
                   }
                    
                    Spacer()
                    
                    // Play/Stop Button (center)
                    Button(action: toggleRecording) {
                        Image(systemName: isRecording ? "stop.circle" : "play.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(isRecording ? .red : .green)
                            .shadow(radius: 4) // Adds a shadow for better visibility
                    }

                    Spacer()
                    
                    // Re-center Button (right side)
                    Button(action: {
                        print("Re-centering map")
                        if let currentLocation = locationManager.location?.coordinate {
                            withAnimation {
                                mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                            }
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4) // Adds a shadow for better visibility
                    }
                }
                .padding()
            }
        }
        .onAppear { // Start location updates as soon as the MapView appears
            locationManager.startUpdatingLocation()
            
            if let location = locationManager.location?.coordinate {
                mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
            }
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .onChange(of: isRecording) {
            if isRecording {
                locationManager.startUpdatingLocation()
            } else {
                print("Stopped updating location")
                locationManager.stopUpdatingLocation()
            }
        }
        // Update the active walk with new locations as they are received from the location manager.
        .onReceive(locationManager.$location) { location in
            if isRecording, let location = location {
                updateActiveWalk(with: location.coordinate)
            }
            
            if !initialLocationSet, let location = location {
                mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                initialLocationSet = true
            }
        }
        // Periodically update the map's region based on the timer.
        .onReceive(timer) {_ in
            if let location = locationManager.location?.coordinate {
                withAnimation {
                    mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                }
            }
        }
        // Display the `SaveWalkView` when saving a completed walk.
        .sheet(isPresented: $showingSaveWalkView) {
            SaveWalkView(showingSaveWalkView: $showingSaveWalkView, isRecording: $isRecording, activeWalk: $activeWalk)
        }
    }
    
    /// Toggles the recording state of the walk and starts/stops tracking accordingly.
    func toggleRecording() {
        if !isRecording {
            activeWalk = ActiveWalk()
            activeWalk?.startTime = Date()
            
            locationManager.startUpdatingLocation()
            
            print("Started recording walk...")
            isRecording = true
        } else {
            if activeWalk != nil {
                showingSaveWalkView = true
            }
        }
    }
    
    /// Updates the active walk with a new coordinate from the user's current location.
    private func updateActiveWalk(with coordinate: CLLocationCoordinate2D) {
        print("Update active walk with coordinate: \(coordinate)")
        activeWalk?.addLocation(coordinate)
    }

    /// Drops a pin at the user's current location during an active recording session.
    func dropPin() {
        guard isRecording, let currentLocation = locationManager.location?.coordinate else { return }
        let newPin = Pin(id: UUID(), coordinate: currentLocation, note: nil, image: nil)
        activeWalk?.pins.append(newPin)
    }
}
