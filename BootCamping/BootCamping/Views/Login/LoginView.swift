//
//  LoginView.swift
//  Semosomo
//
//  Created by sole on 2022/12/13.
//

import SwiftUI


struct LoginView: View {
    @State private var isAlert: Bool = false
    @State private var isSignUp: Bool = false
    var alertMesasge: String{
        get {
            return isAlert ? "아이디 또는 비밀번호가 잘못되었습니다!" : ""
        }
    }
    @Binding var isFirstLaunching: Bool
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack{
            Spacer()
            Image(systemName:"apple.logo")          //앱 로고
                .resizable()
                .frame(width: 100, height: 110)
                .padding(50)
            
            
            VStack {
                TextFieldFrame
                    .overlay{
                        TextField(" 이메일", text: $authStore.email)
                    }
                
                TextFieldFrame
                    .overlay{
                        SecureField(" 비밀번호", text: $authStore.password)
                    }
                    .padding(5)
                
                Text("\(alertMesasge)")
                    .foregroundColor(.red)
                    .font(.callout)
                
                
                Button {
                    Task {
                        if await authStore.signIn() {
                            isFirstLaunching = false
                        }
//                        await authStore.signIn()
                    }
                } label: {
                    LoginButton
                        .padding(.top, 60)
                        .padding(.bottom)
                }
                
                
                HStack {
                    Button(action: {
                        isSignUp.toggle()
                    }) {
                        Text("회원가입하기")
                            .foregroundColor(.gray)
                            .underline()
                    }
                    .padding(.horizontal)
                    Button(action: {
                        //이건 어떡하징
                    }) {
                        Text("아이디 / 비밀번호 찾기")
                            .foregroundColor(.gray)
                            .underline()
                    }
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isSignUp) {
            TermsView(isSignUp: $isSignUp)
        }
    }
    
    //MARK: - Button Frame
    private var LoginButton: some View {
        loginButtonFrame(title: "로그인")
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isFirstLaunching: .constant(false))
            .environmentObject(AuthStore())
    }
}
