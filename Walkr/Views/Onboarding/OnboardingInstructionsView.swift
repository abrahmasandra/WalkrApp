//
//  OnboardingInstructionView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/11/25.
//

import SwiftUI

struct OnboardingInstructionsView: View {
    var body: some View {
        ZStack {
            // Softer gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("Welcome to Walkr!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Built by Arnav Brahmasandra")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    Image(systemName: "map")
                        .font(.title)
                        .foregroundColor(.yellow)
                    Text("Record your walks and explore new places.")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "pin")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Save memories and locations along the way.")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "chart.bar")
                        .font(.title)
                        .foregroundColor(.purple)
                    Text("Track your progress and stay motivated.")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal, 40) // Add horizontal padding for centering
        }
    }
}


#Preview {
    OnboardingInstructionsView()
}
