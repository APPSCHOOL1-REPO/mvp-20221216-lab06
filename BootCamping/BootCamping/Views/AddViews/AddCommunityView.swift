//
//  AddCommunityView.swift
//  BootCamping
//
//  Created by Donghoon Bae on 2022/12/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct AddCommunityView: View {
    @EnvironmentObject var authStore: AuthStore
    @StateObject var communityPostStore: CommunityPostStore
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var location: String = ""
    @State private var content: String = ""
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?
    @State var selectedImages: [UIImage?] = []
    @State private var isDoneRegister: Bool = false
    @Binding var tabSelection: Tab
    
    var user: Users {
        get {
            if Auth.auth().currentUser?.uid != nil {
                return authStore.userList.filter { $0.userID == String(Auth.auth().currentUser!.uid) }.first!
            } else {
                return Users(id: "", userID: "", userNickName: "", userEmail: "", profileImage: "")
            }
        }
    }
    
    var body: some View {
        if isDoneRegister{
            ProgressView()
        } else {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Button {
                            if selectedImages.count > 10 {
                                isPickerShowing = false
                            } else {
                                isPickerShowing = true
                            }
                        } label: {
                            VStack {
                                Image(systemName: "photo").font(.title)
                                Text("\(selectedImages.count) / 10").font(.subheadline)
                            }
                            .frame(width: 100, height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .foregroundColor(.gray)
                            
                        }
                        
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image!)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                        }
                    }
                }
                
                
                VStack(alignment: .leading) {
                    Text("???????????? ????????????").bold()
                    ZStack(alignment: .leading) {
                        TextField("??????????????? ?????????????????? ex) ?????? ??????, ??????, ?????????", text: $category)
                            .frame(height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 1)
                            )
                    }
                    Text("?????? ???????????? ??????????????????").bold()
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $content)
                            .scrollContentBackground(.hidden)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 1)
                    )
                }
                .font(.subheadline)
                .sheet(isPresented: $isPickerShowing) {
                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                        .onDisappear {
                            if selectedImage != nil {
                                selectedImages.append(selectedImage)
                            }
                        }
                }
                
                Button {
                    Task {
                        try await communityPostStore.addCommunityPost(communityPost: CommunityPost(id: UUID().uuidString, userID: String(Auth.auth().currentUser?.uid ?? ""), userNickName: user.userNickName, title: title, content: content, createdDate: Timestamp(), photos: [], category: category.components(separatedBy: ", ")), selectedImages: selectedImages)
                        content = ""
                        category = ""
                        selectedImages = []
                        isDoneRegister = true
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        tabSelection = .forth
                        isDoneRegister = false
                        
                    }
                } label: {
                    AddButton
                }
                
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("???????????? ?????????")
                        .modifier(TitleViewModifier())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    private var AddButton: some View {
        loginButtonFrame(title: "?????? ??????")
        
    }
    
}

struct AddCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCommunityView(communityPostStore: CommunityPostStore(), tabSelection: .constant(.third))
            .environmentObject(AuthStore())
    }
}
