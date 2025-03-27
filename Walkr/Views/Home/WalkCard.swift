//
//  SocialFeedView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//

import SwiftUI
import MapKit

struct WalkCard: View {
    var walk: Walk
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Mini Map
            if let firstCoordinate = walk.route.first {
                Map(position: .constant(MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: firstCoordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                ))) {
                    Marker("Start Point", coordinate: firstCoordinate)
                }
                .frame(height: 150)
                .cornerRadius(10)
            } else {
                Text("No route available")
                    .frame(height: 150)
            }
            
            // Walk Details
            Text(walk.walkName)
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "clock")
                Text("\(walk.formattedDuration)")
                
                Spacer()
                
                Image(systemName: "arrow.triangle.swap")
                Text("\(walk.formattedDistance)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
