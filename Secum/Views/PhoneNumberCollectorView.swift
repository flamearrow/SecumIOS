//
//  PhoneNumberCollectorView.swift
//  Secum
//
//  Created by Chen Cen on 9/10/23.
//

import SwiftUI
import Combine

struct PhoneNumberCollectorView: View {
    
    @Binding var countryCode : String
    @Binding var mobPhoneNumber : String
    @Binding var phoneNumberIsValid: Bool
    
    
    @State var presentSheet = false
    @State var countryFlag : String = "🇺🇸"
    @State var countryPattern : String = "### ### ####"
    @State var countryLimit : Int = 17
    @State private var searchCountry: String = ""
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var keyIsFocused: Bool
    
    var body: some View {
        HStack {
            Button {
                presentSheet = true
                keyIsFocused = false
            } label: {
                Text("\(countryFlag) \(countryCode)")
                    .padding(10)
                    .frame(minWidth: 80, minHeight: 47)
                    .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(foregroundColor)
            }
            
            TextField("", text: $mobPhoneNumber)
                .placeholder(when: mobPhoneNumber.isEmpty) {
                    Text(LocalizedStringKey("phone"))
                        .foregroundColor(.secondary)
                }
                .focused($keyIsFocused)
                .keyboardType(.numbersAndPunctuation)
                .onReceive(Just(mobPhoneNumber)) { _ in
                    applyPatternOnNumbers(&mobPhoneNumber, &phoneNumberIsValid, pattern: countryPattern, replacementCharacter: "#")
                }
                .padding(10)
                .frame(minWidth: 80, minHeight: 47)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .sheet(isPresented: $presentSheet) {
            NavigationView {
                List(filteredResorts) { country in
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                            .font(.headline)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        self.countryFlag = country.flag
                        self.countryCode = country.dial_code
                        self.countryPattern = country.pattern
                        self.countryLimit = country.limit
                        presentSheet = false
                        searchCountry = ""
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchCountry, prompt: "Your country")
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    
    
    var filteredResorts: [CPData] {
        if searchCountry.isEmpty {
            return CPData.allCountry
        } else {
            return CPData.allCountry.filter { $0.name.contains(searchCountry) }
        }
    }
    
    var foregroundColor: Color {
        if colorScheme == .dark {
            return Color(.white)
        } else {
            return Color(.black)
        }
    }
    
    var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(.systemGray5)
        } else {
            return Color(.systemGray6)
        }
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, _ phoneNumberValid: inout Bool, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                phoneNumberValid = false
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        if(pureNumber.count > pattern.count) {
            pureNumber = String(pureNumber.prefix(pattern.count))
        }
        stringvar = pureNumber
        phoneNumberValid = (stringvar.count == pattern.count)
        
    }
}
