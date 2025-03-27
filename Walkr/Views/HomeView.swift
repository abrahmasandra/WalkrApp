//
//  HomeView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    
    @State private var showingProfile = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if dataController.sortedWalks.isEmpty {
                        VStack {
                            Image(systemName: "figure.walk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                            Text("Get Walking")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                    else {
                        Text("All Walks")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 15) {
                                ForEach(dataController.sortedWalks) { walk in
                                    NavigationLink(destination: WalkDetailView(walk: walk)) {
                                        WalkCard(walk: walk)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .toolbar {
                Button {
                    print("Showing Profile")
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(DataController())
}
