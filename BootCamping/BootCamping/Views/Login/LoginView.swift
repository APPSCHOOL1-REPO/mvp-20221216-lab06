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
    
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        VStack{
            
            Spacer()
            Image("LoginLogo")
                .resizable()
                .frame(width: 300, height: 100)
                .padding(50)
            
            
            VStack {
                TextFieldFrame
                    .overlay{
                        TextField(" 이메일을 입력하세요.", text: $authStore.email)
                    }
                
                TextFieldFrame
                    .overlay{
                        SecureField(" 비밀번호를 입력하세요.", text: $authStore.password)
                    }
                    .padding(5)
                
                //                TextFieldFrame
                //                    .overlay{
                //                        SecureField(" 비밀번호를 다시 입력하세요.", text: $authStore.confirmPassword)
                //                    }
                //                    .padding(5)
                
                Text("\(alertMesasge)")
                    .foregroundColor(.red)
                    .font(.callout)
                
                
                NavigationLink {
                    ContentView()
                } label: {
                    
                    LoginButton
                        .padding(.top, 60)
                }.task {
                    Task {
                        await authStore.signIn()
                    }
                        
                }
                
                
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text("함께하다")
                        .foregroundColor(.gray)
                        .underline()
                }
                .padding(5)
            }
            Spacer()
        }
        .sheet(isPresented: $isSignUp) {
            SignUpView()
        }
    }
    
    //MARK: - Button Frame
    private var LoginButton: some View {
        loginButtonFrame(title: "들어가다")
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthStore())
    }
}