//
//  AchievementBadge.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/22/25.
//

import SwiftUI

/// Achievement badge is not used yet --- will be used in the future
struct AchievementBadge: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.yellow)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 80)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}
