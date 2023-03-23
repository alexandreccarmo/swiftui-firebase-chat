//
//  ContentView.swift
//  SwiftUIFirebaseChat
//
//  Created by Alexandre C do Carmo on 04/02/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

//singleton necessario para os recursos de fibase funcionarem no preview :)


struct LoginView: View {
    
    @State var isLogginModel = false
    @State var email = ""
    @State var senha = ""
    
    @State var shouldShowImagePicker = false
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                
                VStack(spacing: 16) {
                    
                    Picker(selection: $isLogginModel, label: Text("Piker here")){
                        Text("Login")
                            .tag(true)
                        Text("Criar conta")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLogginModel {
                        Button{
                            shouldShowImagePicker.toggle()
                            
                        } label: {
                            
                            VStack{
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:  64, height: 64)
                                        .cornerRadius(32)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3)
                            )
                        }
                    }
                    
                    Group {
                        TextField("E-mail", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                                                   
                        SecureField("Senha", text: $senha)
                    }.padding(12)
                    .background(.white)
                                        
                    Button{
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLogginModel ? "Log In" : "Criar conta")
                                .foregroundColor(.white)
                                .padding(.vertical,10)
                                .font(.system(size: 14,weight: .semibold))
                            
                            Spacer()
                        }.background(.blue)
                        
                    }
                    
                }.padding()
                
                Text(self.loginStatusMessage)
                    .foregroundColor(.red)
                
            }
            .navigationTitle(isLogginModel ? "Log In" : "Criar conta")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
               
    }
    
    @State var image: UIImage?
    
    private func handleAction() {
        if isLogginModel {
            loginUser()
        }
        else {
            createNewAccount()
        }
    }
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: senha) {
            res, error in
            
            if let error = error {
                print("Falha ao logar: ", error)
                self.loginStatusMessage = "Erro ao logar: \(error)"
                return
            }
            
            print("Sucesso ao logar, usuario: \(res?.user.uid ?? "")" )
            
            self.loginStatusMessage = "Logado com usuário \(res?.user.uid ?? "")"
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.senha){
            result,error in
            
            if let error = error {
                print("Falha ao criar conta", error)
                self.loginStatusMessage = "Erro ao criar a conta: \(error)"
                return
            }
            
            print("Conta criado, usuario: \(result?.user.uid ?? "")" )
            
            self.loginStatusMessage = "Conta criada com sucesso \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
            
        }
    }
    
    private func persistImageToStorage() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) {
            metadata, error in
            if let error = error {
                self.loginStatusMessage = "Erro ao enviar a imagem: \(error)"
                return
            }
            
            ref.downloadURL { url, error in
                
                if let error = error {
                    self.loginStatusMessage = "Erro fazer o download : \(error)"
                    return
                }
                
                self.loginStatusMessage = "Download realizado com suscesso na url: \(url?.absoluteString ?? "")"
                
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                storeUserInformation(imageProfileUrl: url)
                
            }
            
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email":self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        
        FirebaseManager.shared.fireStore.collection("users")
            .document(uid).setData(userData) { error in
                print(error ?? "")
                
                self.loginStatusMessage = "\(String(describing: error))"
                return
            }
        
        print("armazenado com suceeso no firestore")
        
        
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
