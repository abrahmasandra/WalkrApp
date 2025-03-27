//
//  PlaceButton.swift
//  Walkr
//
//  Created by Arnav Brahmasandra on 2/22/25.
//

import SwiftUI

struct PinButton: View {
    // The pin to display on the map
    @Binding var pin: Pin
    
    @State private var popoverSize = CGSize(width: 300, height: 300)
    @State private var isShowingPopover = false
    
    var body: some View {
        Button(action: {
            print("Showing pin popover")
            isShowingPopover = true
        }, label: {
            Image(systemName: "mappin.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .font(isShowingPopover ? .title : .body)
                .animation(.easeInOut(duration: 0.2), value: isShowingPopover)  
        })
        .popover(isPresented: $isShowingPopover) {
            PinPopoverView(pin: $pin)
        }
    }
}
