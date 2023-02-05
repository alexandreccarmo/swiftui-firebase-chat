//
//  ContentView.swift
//  SwiftUIFirebaseChat
//
//  Created by Alexandre C do Carmo on 04/02/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var isLogginModel = false
    @State var email = ""
    @State var senha = ""
    
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
                        print(123)
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
                
            }
            .navigationTitle(isLogginModel ? "Log In" : "Criar conta")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
               
    }
    
    private func handleAction() {
        if isLogginModel {
            
        }
        else {
            
        }
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
