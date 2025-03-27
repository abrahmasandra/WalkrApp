//
//  OnboardingPage.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/10/25.
//


import SwiftUI

struct OnboardingContainerView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var selection = 0
    @State private var email = ""
    @State private var username = ""
    
    var body: some View {
        TabView(selection: $selection) {
            OnboardingInstructionsView()
                .edgesIgnoringSafeArea(.all)
                .tag(0)
            OnboardingUserInputView(email: $email, username: $username, hasCompletedOnboarding: $hasCompletedOnboarding)
                .tag(1)
        }
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingContainerView(hasCompletedOnboarding: Binding.constant(false))
}

