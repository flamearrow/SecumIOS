//
//  ContentView.swift
//  Secum
//
//  Created by Chen Cen on 6/19/23.
//

import SwiftUI

struct ContentView: View {
    @State var shouldShowSplash: Bool = true
    
    var body: some View {
        if(shouldShowSplash) {
            SecumSplash().onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                    // ping and confirm
                    self.shouldShowSplash = false
                })
            }
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
