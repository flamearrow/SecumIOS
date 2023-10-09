//
//  LoginView.swift
//  Secum
//
//  Created by Chen Cen on 9/9/23.
//

import SwiftUI

struct LoginView : View {
    @ObservedObject var viewModel = LoginViewModel()
    @State var text: String = ""
    @State var mobPhoneNumber : String = ""
    @State var countryCode : String = "+1"
    @State var phoneNumberIsValid : Bool = false
    @State var otpIsInvalid : Bool = false
    @State var otp: String = ""
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    var filteredPhoneNumber: String  {
        return mobPhoneNumber.filter { c in
            return c != " "
        }
    }
    
    var body: some View {
        switch viewModel.state {
        case .error(let reason):
            Text("error! \(reason)")
        case .inputtingPhoneNumber(let loading):
            LoginScaffold {
                phoneNumber(loading: loading)
            }
        case .inputtingAccessCode(let phoneNumber, let loading):
            LoginScaffold {
                otp(phoneNumber: phoneNumber, loading: loading)
            }
        case .gotAccessToken:
            LoggedInView()
        }
    }
    
    @ViewBuilder
    private func phoneNumber(loading: Bool) -> some View {
        Spacer().frame(height: 30)
        Text(LocalizedStringKey("enter_mobile")).font(.title)
        Text(LocalizedStringKey("we_will_send_otp")).font(.callout).foregroundColor(.secondary)
        Spacer().frame(height: 40)
        PhoneNumberCollectorView(countryCode: $countryCode, mobPhoneNumber: $mobPhoneNumber, phoneNumberIsValid: $phoneNumberIsValid)
        Spacer().frame(height: 10)
        HStack {
            LoadingButton(
                state: loading ? .loading : phoneNumberIsValid ? .idle : .disabled,
                labelKey: LocalizedStringKey("next")
            ) {
                registerAndRequestAccessCode()
            }
        }.frame(maxWidth: .infinity)
        Spacer()
    }
    
    @ViewBuilder
    private func otp(phoneNumber: String, loading: Bool) -> some View {
        Spacer().frame(height: 30)
        
        Text(LocalizedStringKey("enter_4_digits")).font(.title)
        Text(LocalizedStringKey("we_sent_otp_to \(String(phoneNumber.suffix(4)))")).font(.callout).foregroundColor(.secondary)
        Spacer().frame(height: 20)
        OTPCollectionView(otp: $otp).frame(maxWidth: .infinity)
        Spacer().frame(height: 20)
        // quirky way to handle custom url
        Text(LocalizedStringKey("not_receive_code")).font(.subheadline).foregroundColor(.secondary).frame(maxWidth: .infinity).environment(
            \.openURL, OpenURLAction { _ in
                registerAndRequestAccessCode()
                return .handled
            }
        )
        Spacer().frame(height: 10)
        HStack {
            LoadingButton(
                state: loading ? .loading : otp.count < 4 ? .disabled : .idle,
                labelKey: LocalizedStringKey("next"),
                action: {
                    guard let correctOtp = viewModel.otp?.accessCode, correctOtp == otp else {
                        otpIsInvalid = true
                        return
                    }
                    viewModel.getAndSaveAccessToken()
                }
            )
        }.frame(maxWidth: .infinity)
        Spacer()
    }
        
    
    private func LoginScaffold<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
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
                        content()
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                .frame(height: geo.size.height / 2)
                .clipShape(RoundedCornerShape(corner: .topLeft, radius: 20))
                .clipShape(RoundedCornerShape(corner: .topRight, radius: 20))
                
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .padding(.bottom, keyboardResponder.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .ignoresSafeArea(.all)
        .alert(isPresented: $otpIsInvalid, content: {
            Alert(
                title: Text(LocalizedStringKey("incorrect_otp")),
                message: Text(LocalizedStringKey("input_incorrect_otp")),
                dismissButton: .default(Text(LocalizedStringKey("ok"))) {
                    otpIsInvalid = false
                    otp = ""
                }
            )
        })
    }
    
    private func registerAndRequestAccessCode() {
        viewModel.registerUserAndRequestAccessCode(fullPhoneNumber: "\(countryCode)\(filteredPhoneNumber)")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = LoginViewModel()
        mockViewModel.state = .inputtingAccessCode(phoneNumber: "4151234567", loading: false)
        mockViewModel.otp = .init(accessCode: "1234")
        return LoginView(viewModel: mockViewModel, otpIsInvalid: true, otp: "1234")
    }
}
