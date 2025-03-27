//
//  WalkHUD.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//

import SwiftUI

struct WalkHUD: View {
    @Binding var activeWalk: ActiveWalk?
    var body: some View {
        VStack {
            HStack {
                Text("\(activeWalk?.formattedDistance ?? "0.00 km")")
                
                Spacer()
                
                Text("\(activeWalk?.formattedDuration ?? "00:00:00")")
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom, 10)
            
            HStack {
                Text("Avg: \(activeWalk?.averageSpeed ?? 0 * 3.6, specifier: "%.2f") km/h")
                
                Spacer()
                
                Text("Curr: \(activeWalk?.currentSpeed ?? 0 * 3.6, specifier: "%.2f") km/h")
            }
            .font(.headline)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .frame(maxWidth: 275)
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .foregroundColor(.white)
        .shadow(radius: 5)
    }
}
