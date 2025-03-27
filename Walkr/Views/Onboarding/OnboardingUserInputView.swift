//
//  OnboardingUserInputView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 3/11/25.
//

import SwiftUI
import Foundation

struct OnboardingUserInputView: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var hasCompletedOnboarding: Bool
    
    @State private var emailIsValid = true
    @State private var usernameIsValid = true
    @State private var errorMessage: String?
    
    // @Environment(DataController.self) var dataController
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ZStack {
            // Softer gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("Create Your Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    Image(systemName: "person.circle")
                        .font(.title)
                        .foregroundColor(.yellow)
                    Text("Enter your details to get started.")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 0)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .onChange(of: email) {
                        emailIsValid = validateEmail(email)
                        if !emailIsValid {
                            errorMessage = "Invalid email address."
                        } else {
                            errorMessage = nil
                        }
                    }
                    .foregroundColor(emailIsValid ? .black : .red)
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 0)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .onChange(of: username) {
                        usernameIsValid = validateUsername(username)
                        if !usernameIsValid {
                            errorMessage = "Username must be alphanumeric, 3-18 characters long."
                        } else if errorMessage != nil {
                            errorMessage = nil
                        }
                    }
                    .foregroundColor(usernameIsValid ? .black : .red)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Text("Your account will help you save walks and memories.")
                    .foregroundColor(.white)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        print("Validating and submitting user details...")
                        // Validate fields if needed
                        if emailIsValid && usernameIsValid {
                            let user = User(userName: username, email: email)
                            dataController.saveUser(from: user)
                            hasCompletedOnboarding = true
                        } else {
                            print("Validation failed.")
                        }
                    }) {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 40) // Add horizontal padding for centering
        }
    }

    func validateEmail(_ email: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let detector = detector {
            if let _ = detector.firstMatch(in: email, options: [], range: NSRange(email.startIndex..., in: email)) {
                return true
            }
        }
        return false
    }
    
    func validateUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]{3,18}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
}



//#Preview {
//    OnboardingUserInputView()
//}
