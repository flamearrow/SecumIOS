//
//  File.swift
//  Secum
//
//  Created by Chen Cen on 9/9/23.
//

import SwiftUI

struct Cathead : View {
    static let defaultBorderSize: Double = 180
    static let defaultCatSize: Double = 110
    
    let scale: Double
    let borderSize: Double
    let catSize: Double
    init(scale: Double = 1.0) {
        self.scale = scale
        borderSize = Cathead.defaultBorderSize * scale
        catSize = Cathead.defaultCatSize * scale
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20 * scale)
                .fill(Color.darkBlue)
                .frame(width: borderSize, height: borderSize)
            Image("cathead")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.lightBlue)
                .scaledToFill()
                .frame(width: catSize, height: catSize)
        }
    }
}
