//
//  ProfileEditor.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/20/25.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var user: User
    
    var body: some View {
        Form {
            userInfoSection
        }
    }
    
    private var userInfoSection: some View {
        Section(header: Text("User Info")) {
            TextField("Username", text: $user.userName)
            TextField("Email", text: $user.email)
        }
    }
}

#Preview {
    ProfileEditor(
        user: .constant(.defaultUser)
    )
}
