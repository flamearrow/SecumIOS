//
//  SampleView.swift
//  Secum
//
//  Created by Chen Cen on 9/9/23.
//

import SwiftUI

struct SampleView: View {
    var body: some View {
        VStack {
            MapView().frame(height: 300).ignoresSafeArea(edges: .top)
            Tora().offset(y:-100)
            HStack {
                Text("Tora's headshot")
                Spacer()
                Text("on NYC")
            }.padding() // this would just give more left/right space
            Divider()
            Text("About Tora").font(.title2).alignmentGuide(.leading) { _ in 0 }
            Text("Bestest cat ever")
            Spacer()
        }
    }
}
