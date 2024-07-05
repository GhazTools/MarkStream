//
//  ContentView.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 6/29/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var isAuthenticating = false
    
    
    func validate_user() async -> Bool {
        let setCorrectly = TokenGranter.shared.set_username_and_password(username: self.username, password: self.password);
                
        if(setCorrectly){
            return await TokenGranter.shared.grant_access_token();
        }
        
        return false;
    }
    
    
    var body: some View {
        VStack {
            if showError {
                Text("Authentication Error: Invalid Username & Password")
                    .foregroundColor(.red)
                    .padding()
                
            }

            Image("LoginPageAppIcon")
                .resizable() // Make the image resizable
                .aspectRatio(contentMode: .fill) // Keep the aspect ratio and fill the frame
                .frame(width: 350, height: 350) // Specify the frame size

            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
                .disabled(isAuthenticating) // Disable input during authentication
            
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
                .disabled(isAuthenticating) // Disable input during authentication
            
            if (isAuthenticating) {
                LoadingView(isLoading: self.$isAuthenticating)
            }
            
            
            Button(action: {
                // Implement your login logic here
                self.isAuthenticating = true // Disable inputs and button
                
                
                Task {
                    let validated: Bool = await validate_user()
                    self.isAuthenticated = validated;
                    self.showError = false;

                    
                    if(validated){
                        KeychainManager.shared.save(self.username, forKey: KeychainKeys.username)
                        KeychainManager.shared.save(self.password, forKey: KeychainKeys.password)
                        self.isAuthenticating = false;
                    }
                    else {
                        self.showError = true;
                        self.isAuthenticating = false;
                    }
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(isAuthenticating) // Disable input during authentication
            
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    struct LoginPreviewWrapper: View {
        @State private var isAuthenticated: Bool = false

        var body: some View {
            LoginView(isAuthenticated: $isAuthenticated).preferredColorScheme(.dark)
        }
    }

    
    static var previews: some View {
        LoginPreviewWrapper()
    }
}
