//
//  AuthService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-10.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    
    // Sign In User
    static func signInUser(email: String, password: String, onSuccess: @escaping() -> Void, onFail: @escaping(_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                onFail(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    // Sign Up User
    static func signUpUser(email: String, password: String, onSuccess: @escaping() -> Void, onFail: @escaping(_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                onFail(error!.localizedDescription)
                return
            }
            guard let user = authResult?.user else { return }
            let uid = user.uid
            self.setUserInfo(email: email, uid: uid, onSuccess: onSuccess)
        }
    }
    
    static func setUserInfo(email: String, uid: String, onSuccess: @escaping() -> Void) {
        let databaseReference = Database.database().reference() // : https://passion-fruit-39bda.firebaseio.com
        let usersReference = databaseReference.child("users") // : https://passion-fruit-39bda.firebaseio.com/users
        let newUserReference = usersReference.child(uid) // : https://passion-fruit-39bda.firebaseio.com/users/uid
        
        newUserReference.setValue(["email": email])
    
        onSuccess()
    }
}
