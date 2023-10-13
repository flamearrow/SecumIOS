//
//  OTPCollectionView.swift
//  Secum
//
//  Created by Chen Cen on 10/1/23.
//

import Foundation
import SwiftUI

struct OTPCollectionView: View {
    @Binding var otp : String
    @FocusState private var focusedField: Int?
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { index in
                DigitTextField(index: index, text: $otp, focusedField: _focusedField)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
            }
        }.onChange(of: otp) { newValue in
            if(newValue == "") {
                focusedField = 0
            }
            if(newValue.count == 4) {
                hideKeyboard()
            }
        }
    }
}

struct DigitTextField: View {
    let index: Int
    @Binding var text: String
    @FocusState var focusedField: Int?

    var body: some View {
        TextField("", text: Binding<String>(
            get: {
                if(index < text.count) {
                    return String(text[text.index(text.startIndex, offsetBy: index)])
                } else {
                    return ""
                }
            },
            set: { newValue in
                // delete value
                // Note when updaing focusedField, the previous field will then get focus and got newValue
                // Otherwise focusedField will appear not changed if printed out
                if newValue.count == 0 && text.count == index + 1 {
                    text = String(text.dropLast())
                    focusedField = index == 0 ? index  : (index - 1)
                }
                // got new value
                // need to distinguish if the focus is acquired due to either backspace from the next field
                //  or a new value just input by user, only pick the 2nd case
                else if newValue.count == 1 && text.count == index {
                    // set string value
                    if text.count <= index {
                        var newText = text
                        // copy the text as the prefix, fill spaces in between
                        
                        for _ in text.count..<index {
                            newText += " "
                        }
                        text = newText + newValue
                    } else {
                        // replace index with the value
                        text = text.replaceWithChar(index: index, replacementCharacterString: newValue)
                    }
                    focusedField = index + 1
                }
            }
        ))
        .focused($focusedField, equals: index)
        .multilineTextAlignment(.center)
        .frame(width: 50, height: 50)
        .font(.headline)
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        .background(Color.clear)
        .cornerRadius(10)
    }
}

fileprivate extension String {
    func replaceWithChar(index: Int, replacementCharacterString: String) -> String {
        var modifiedString = self
        if index >= 0 && index < self.count {
            let index = self.index(self.startIndex, offsetBy: index)
            modifiedString.replaceSubrange(index...index, with: replacementCharacterString)
        }
        return modifiedString
    }
}

struct OTPCollectionView_Previews: PreviewProvider {
    @State static var otp = ""
    static var previews: some View {
        OTPCollectionView(otp: $otp)
    }
}
