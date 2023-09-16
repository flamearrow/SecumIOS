//
//  LoginView.swift
//  Secum
//
//  Created by Chen Cen on 9/9/23.
//

import SwiftUI

struct LoginView : View {
    @State var text: String = ""
    @State var mobPhoneNumber : String = ""
    @State var countryCode : String = "+1"
    @State var phoneNumberIsValid : Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: -20) {
                Color.lightGrey
                ZStack {
                    Color.lightGrey
                    VStack {
                        Cathead(scale: 0.5)
                        Text(LocalizedStringKey("welcome_to_app")).font(.largeTitle).bold()
                        Text(LocalizedStringKey("login_in_to_continue")).font(.title).bold().foregroundColor(.secondary)
                    }
                }
                .frame(height: geo.size.height / 2)
                
                
                ZStack {
                    Color.white
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer().frame(height: 30)
                        Text(LocalizedStringKey("enter_mobile")).font(.title)
                        Text(LocalizedStringKey("we_will_send_otp")).font(.callout).foregroundColor(.secondary)
                        Spacer().frame(height: 40)
                        PhoneNumberCollectorView(countryCode: $countryCode, mobPhoneNumber: $mobPhoneNumber, phoneNumberIsValid: $phoneNumberIsValid)
                        Spacer().frame(height: 10)
                        HStack {
                            Button(action: {
                                print("Button tapped! \(countryCode) : \(mobPhoneNumber)")
                            }) {
                                Text(LocalizedStringKey("next"))
                                    .padding(EdgeInsets(top: 12, leading: 80, bottom: 12, trailing: 80))
                                    .font(.headline)
                                    .background(phoneNumberIsValid ? .blue : .gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(!phoneNumberIsValid)
                        }.frame(maxWidth: .infinity)
                        Spacer()
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                .frame(height: geo.size.height / 2)
                .clipShape(RoundedCornerShape(corner: .topLeft, radius: 20))
                .clipShape(RoundedCornerShape(corner: .topRight, radius: 20))
                
            }
        }.ignoresSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

import SwiftUI

struct AContentView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: -20) {
                Color.green
                VStack {
                    Color.green
                }.frame(height: geo.size.height / 2)
                
                VStack {
                    Color.red
                }
                .frame(height: geo.size.height / 2)
                .clipShape(RoundedCornerShape(corner: .topLeft, radius: 20))
                .clipShape(RoundedCornerShape(corner: .topRight, radius: 20))
                
            }
        }.ignoresSafeArea(.all)
    }
}

private struct RoundedCornerShape: Shape {
    var corner: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corner,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

//struct AContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AContentView()
//    }
//}
