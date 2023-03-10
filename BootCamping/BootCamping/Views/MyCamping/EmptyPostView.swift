//
//  EmptyPostView.swift
//  BootCamping
//
//  Created by 이소영 on 2022/12/20.
//

import SwiftUI

struct EmptyPostView: View {
    @Binding var tabSelection: Tab
    
    var body: some View {
        VStack {
            Text("나의 캠핑 이야기를")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, -5)
            Text("공유해 주세요!")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Button {
                tabSelection = .third
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .frame(width: 120, height: 40)
                    Text("글쓰러 가기")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: 198, height: 198)
    }
}

struct EmptyPostView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPostView(tabSelection: .constant(.third))
    }
}
