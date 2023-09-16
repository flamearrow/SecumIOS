//
//  SplashView.swift
//  Secum
//
//  Created by Chen Cen on 9/9/23.
//

import SwiftUI

struct SecumSplash : View {
    
    var body: some View {
        VStack {
            Cathead()
            Spacer()
            Text("AI MARS")
                .font(.system(size: 50))
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 600)
    }
}

struct SecumSplash_Previews: PreviewProvider {
    static var previews: some View {
        SecumSplash()
    }
}
