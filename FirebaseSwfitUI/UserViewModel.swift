//
//  UserViewModel.swift
//  FirebaseSwfitUI
//
//  Created by Jonathan Bones on 09.07.20.
//  Copyright © 2020 bonesyblue. All rights reserved.
//

import Foundation

class UserViewModel: ObservableObject {
    // Input
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""
    
    // Output
    @Published var isValid =  false
    
}
