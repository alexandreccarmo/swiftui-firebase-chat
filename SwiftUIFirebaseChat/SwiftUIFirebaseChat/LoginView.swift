//
//  ContentView.swift
//  SwiftUIFirebaseChat
//
//  Created by Alexandre C do Carmo on 04/02/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLogginModel = false
    @State var email = ""
    @State var senha = ""
    @State var password = ""
    
    init() {
        FirebaseApp.configure()
    }
    
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
                            
                            
                        } label: {
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
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
               
    }
    
    private func handleAction() {
        if isLogginModel {
            loginUser()
        }
        else {
            createNewAccount()
        }
    }
    
    private func loginUser(){
        Auth.auth().signIn(withEmail: email, password: senha) {
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
        Auth.auth().createUser(withEmail: self.email, password: self.senha){
            result,error in
            
            if let error = error {
                print("Falha ao criar conta", error)
                self.loginStatusMessage = "Erro ao criar a conta: \(error)"
                return
            }
            
            print("Conta criado, usuario: \(result?.user.uid ?? "")" )
            
            self.loginStatusMessage = "Conta criada com sucesso \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
