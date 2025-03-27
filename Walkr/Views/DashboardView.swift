//
//  DashboardView.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/17/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            RecordWalkView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
        }
        .toolbarBackground(Color("transparent"))
    }
}

#Preview {
    DashboardView()
        .environmentObject(DataController())
}
