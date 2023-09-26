//
//  ContentView.swift
//  Secum
//
//  Created by Chen Cen on 6/19/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        switch contentViewModel.state {
        case .splash:
            SecumSplash().onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    contentViewModel.tryPing()
                }
            }
        case .login:
            LoginView()
        case .loading:
            ProgressView()
        default:
            Text("default")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
