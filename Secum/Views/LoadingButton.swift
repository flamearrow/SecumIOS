//
//  LoadingButton.swift
//  Secum
//
//  Created by Chen Cen on 10/8/23.
//

import Foundation
import SwiftUI

enum LoadingButtonState {
    case loading
    case idle
    case disabled
}

struct LoadingButton : View {
    let state: LoadingButtonState
    let labelKey: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        ZStack(alignment:.trailing) {
            switch(state) {
            case .disabled:
                Button(action: self.action) {
                    Text(labelKey)
                        .padding(EdgeInsets(top: 12, leading: 80, bottom: 12, trailing: 80))
                        .font(.headline)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(true)
            case .idle:
                Button(action: self.action){
                    Text(labelKey)
                        .padding(EdgeInsets(top: 12, leading: 80, bottom: 12, trailing: 80))
                        .font(.headline)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(false)
            case .loading:
                Button(action: self.action){
                    Text(labelKey)
                        .padding(EdgeInsets(top: 12, leading: 80, bottom: 12, trailing: 80))
                        .font(.headline)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.disabled(true)
                ProgressView() // The spinner
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .offset(x: -10)
            }
        }
    }
}

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        return LoadingButton(state: .loading, labelKey: LocalizedStringKey("next"), action: {})
    }
}
