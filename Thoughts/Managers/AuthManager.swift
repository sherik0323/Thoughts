//
//  AuthManager.swift
//  Thoughts
//
//  Created by Sherozbek on 20/11/23.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager ()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signUp(email: String, password: String, completion: @escaping (Bool) -> Void){
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    public func signIn(email: String, password: String, completion: @escaping (Bool) -> Void){
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
    }
    
    public func signOut(completion:  (Bool) -> Void){
        do {
            try auth.signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
}
