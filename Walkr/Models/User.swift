//
//  Model.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/20/25.
//

import Foundation
import Combine
import CoreData

/// Represents a user in the application, including their profile information and associated walks.
class User: Identifiable {
    /// Unique identifier for the user.
    let id = UUID()
    
    /// The user's name.
    var userName: String
    
    /// The user's email address.
    var email: String
    
    /// Optional URL for the user's profile image.
    var profileImageURL: String?
    
    /// The date the user joined the application.
    var joinDate: Date
    
    /// List of walks associated with the user.
    var walks: [Walk] = []
    
    /// A default user instance for cases where no user data is available.
    static let defaultUser = User(userName: "Anonymous", email: "anonymous@example.com")
    
    
    /// Initializes a new `User` instance with the provided parameters.
    init(userName: String, email: String, profileImageURL: String? = nil, joinDate: Date = Date(), walks: [Walk] = []) {
        self.userName = userName
        self.email = email
        self.profileImageURL = profileImageURL
        self.joinDate = joinDate
        self.walks = walks
    }
    
    /// Converts the `User` object into a dictionary format for saving to persistent storage (e.g., UserDefaults).
    /// - Returns: A dictionary representation of the user's data.
    func toDictionary() -> [String: Any] {
        return [
            "userName": userName,
            "email": email,
            "profileImageURL": profileImageURL ?? "",
            "joinDate": joinDate.timeIntervalSince1970 // Convert Date to TimeInterval
        ]
    }
    
    /// Initializes a `User` object from a dictionary representation.
    /// - Parameter dictionary: A dictionary containing user data.
    convenience init?(from dictionary: [String: Any]) {
        guard let userName = dictionary["userName"] as? String,
              let email = dictionary["email"] as? String,
              let joinDate = dictionary["joinDate"] as? TimeInterval else {
            return nil
        }
        
        self.init(userName: userName,
                  email: email,
                  profileImageURL: dictionary["profileImageURL"] as? String,
                  joinDate: Date(timeIntervalSince1970: joinDate))
    }
}

// MARK: - User Metrics and Utilities

extension User {
    /// Calculates the user's average walk distance in kilometers.
    var averageWalkDistance: Double {
        guard !walks.isEmpty else {
            return 0
        }
        
        return totalDistance / Double(totalWalks)
    }
    
    /// Finds the longest walk distance in kilometers among all walks.
    var longestWalkDistance: Double {
        guard !walks.isEmpty else {
            return 0
        }
        
        return (walks.max(by: { $0.distance < $1.distance })?.distance ?? 0) / 1000
    }
    
    /// Returns the total number of walks associated with the user.
    var totalWalks: Int {
        return walks.count
    }
    
    /// Calculates the total distance walked by the user in kilometers across all walks.
    var totalDistance: Double {
        return walks.reduce(0) { $0 + $1.distance } / 1000
    }
    
    /// Calculates the total time spent walking by the user across all walks, in seconds.
    var totalTimeWalked: TimeInterval {
        return walks.reduce(0) { $0 + $1.duration }
    }
    
    /// Returns up to 5 most recent walks, or all walks if fewer than 5 are available.
    var recentWalks: [Walk] {
        return Array(walks.sorted { $0.date > $1.date }.prefix(5))
    }
    
    /// Calculates the user's average walking speed in kilometers per second across all walks.
    var averageWalkingSpeed: Double {
        guard totalTimeWalked > 0 else {
            return 0
        }
        
        return totalDistance / totalTimeWalked
    }
    
    
    /// Creates a copy of the current `User` instance without any associated walks.
    /// - Returns: A new `User` instance with identical profile information but no walks.
    func copy() -> User {
        let newUser = User(userName: userName, email: email, profileImageURL: profileImageURL, joinDate: joinDate)
        
        return newUser
    }
}
