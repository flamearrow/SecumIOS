//
//  Views+Button.swift
//  Secum
//
//  Created by Chen Cen on 9/10/23.
//

import SwiftUI

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}
