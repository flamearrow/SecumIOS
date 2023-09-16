//
//  Tora.swift
//  Secum
//
//  Created by Chen Cen on 6/25/23.
//

import SwiftUI

struct Tora: View {
    var body: some View {
        //            Image(systemName: "clock")
        //                .imageScale(.large)
        //                .foregroundColor(.accentColor)
        Image("tora")
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200) // Set the desired size of the image
            .clipped() // Ensures the image stays within the frame
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct Tora_Previews: PreviewProvider {
    static var previews: some View {
        Tora()
    }
}
