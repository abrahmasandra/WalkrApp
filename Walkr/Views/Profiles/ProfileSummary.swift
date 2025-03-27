//
//  ProfileSummary.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/20/25.
//

import SwiftUI

struct ProfileSummary: View {
    @State var user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                userHeader
                statisticsSection
                recentActivitySection
                // achievementsSection
            }
            .padding()
        }
    }
    
    private var userHeader: some View {
        HStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(user.userName)
                    .font(.title)
                    .fontWeight(.bold)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Statistics")
                .font(.headline)
            
            HStack {
                StatCard(title: "Total Distance", value: String(format: "%.1f", user.totalDistance), unit: "km")
                StatCard(title: "Total Walks", value: "\(user.totalWalks)", unit: "walks")
            }
            
            HStack {
                StatCard(title: "Avg. Distance", value: String(format: "%.1f", user.averageWalkDistance), unit: "km")
                StatCard(title: "Longest Walk", value: String(format: "%.1f", user.longestWalkDistance), unit: "km")
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activity")
                .font(.headline)
            
            ForEach(user.recentWalks.prefix(3)) { walk in
                HStack {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.green)
                    Text(walk.walkName)
                    Spacer()
                    Text("\(walk.formattedDistance)")
                }
            }
        }
    }
    
//    private var achievementsSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Achievements")
//                .font(.headline)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    AchievementBadge(title: "50 Walks", imageName: "figure.walk")
//                    AchievementBadge(title: "100 km", imageName: "map")
//                    AchievementBadge(title: "Early Bird", imageName: "sunrise")
//                    AchievementBadge(title: "Night Owl", imageName: "moon.stars")
//                }
//            }
//        }
//    }
}


#Preview {
    ProfileSummary(
        user: User.defaultUser
    )
}
