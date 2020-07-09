//
//  SignUpForm.swift
//  FirebaseSwfitUI
//
//  Created by Jonathan Bones on 09.07.20.
//  Copyright © 2020 bonesyblue. All rights reserved.
//

import SwiftUI

struct SignUpForm: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        Form {
            Section(footer: Text(
                    viewModel.usernameMessage
                ).foregroundColor(.red)
            ) {
                TextField(
                    "Username",
                    text: $viewModel.username
                ).autocapitalization(.none)
            }
            Section(footer: Text(
                    viewModel.passwordMessage
            ).foregroundColor(.red)
            ) {
                SecureField(
                    "Password",
                    text: $viewModel.password
                )
                SecureField(
                    "Password again",
                    text: $viewModel.passwordAgain
                )
            }
            Section {
                Button(action: {
                    print("Register user \(self.viewModel.username)")
                }){
                   Text("Sign up")
                }.disabled(!viewModel.isValid)
            }
        }
    }
}

struct SignUpForm_Previews: PreviewProvider {
    static var previews: some View {
        SignUpForm(viewModel: UserViewModel())
            .environment(\.colorScheme, .dark)
    }
}
