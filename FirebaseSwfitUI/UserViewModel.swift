//
//  UserViewModel.swift
//  FirebaseSwfitUI
//
//  Created by Jonathan Bones on 09.07.20.
//  Copyright © 2020 bonesyblue. All rights reserved.
//

import Foundation
import Combine
import Navajo_Swift

enum PasswordCheck {
    case valid
    case empty
    case noMatch
    case notStrongEnough
}

class UserViewModel: ObservableObject {
    // Input
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""
    
    // Output
    @Published var isValid =  false
    @Published var usernameMessage =  ""
    @Published var passwordMessage =  ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { (text) in
                return text.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordStrengthPublisher: AnyPublisher<PasswordStrength, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return Navajo.strength(ofPassword: input)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
        passwordStrengthPublisher
            .map { strength in
                switch strength {
                case .reasonable, .strong, .veryStrong:
                    return true
                default:
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher,arePasswordsEqualPublisher,isPasswordStrongEnoughPublisher)
            .map { isEmpty, areEqual, isStrongEnough in
                if(isEmpty) {
                 return .empty
                }
                
                if(!areEqual){
                    return .noMatch
                }
                
                if(!isStrongEnough){
                    return .notStrongEnough
                }
                
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .map { isUsernameValid, isPasswordValid in
                return isUsernameValid && (isPasswordValid == .valid)
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map{ valid in
                valid ? "" : "Username should be at least 3 characters"
            }
        .assign(to: \.usernameMessage, on: self)
        .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return "Password  must not be empty"
                case .noMatch:
                    return "Passwords don't match"
                case .notStrongEnough:
                    return "Password not strong enough"
                default:
                    return ""
                }
            }
        .assign(to: \.passwordMessage, on: self)
    .store(in: &cancellableSet)
    }
}
