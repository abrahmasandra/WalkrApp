//
//  ProfileHost.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/20/25.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    
    @EnvironmentObject var dataController: DataController
    
    @State private var draftUser = User.defaultUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        draftUser = dataController.currentUser
                        
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                EditButton()
            }
            
            if editMode?.wrappedValue == .inactive
            {
                ProfileSummary(user: dataController.currentUser)
            } else {
                ProfileEditor(user: $draftUser)
                    .onAppear {
                        draftUser = dataController.currentUser
                    }
                    .onDisappear {
                        dataController.saveUser(from: draftUser)
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ProfileHost()
        .environmentObject(DataController())
}
