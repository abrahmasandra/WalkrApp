//
//  ContentView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//

import SwiftUI
import OnboardingKit

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @AppStorage("launchCount") private var launchCount = 0
    
    @State private var showRatingAlert = false
    
    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingContainerView(hasCompletedOnboarding: $hasCompletedOnboarding)
        } else {
            DashboardView()
                .onAppear {
                    launchCount += 1
                    if launchCount == 3 {
                        showRatingAlert = true
                    }
                }
                .alert("Rate Our App", isPresented: $showRatingAlert) {
                        Button("Rate Now") {
                            // Open App Store to rate the app
                            if let url = URL(string: "https://itunes.apple.com/app/idYOUR_APP_ID") {
                                UIApplication.shared.open(url)
                            }
                        }
                        Button("Later", role: .cancel) {}
                    } message: {
                        Text("We hope you're enjoying Walkr! Please take a moment to rate us.")
                    }
        }
    }
}

#Preview {
    ContentView()
}
