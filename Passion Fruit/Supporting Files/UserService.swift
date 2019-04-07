//
//  UserService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2019-01-16.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserService {
    
    // Get current user
    static func getCurrentUserID() -> String {
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            
            return uid
        }
        
        return ""
    }
    
    
    // Get user with uid
//    static func getUser(with uid: String) -> User {
//
//        let user = User()
//
//        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//
//                user.uid = dictionary["uid"] as? String
//                user.email = dictionary["email"] as? String
//
//                user.profile_photo_url = dictionary["profile_photo_url"] as? String
//
//                user.user_name = dictionary["user_name"] as? String
//                user.i_am = dictionary["i_am"] as? String
//                user.i_like = dictionary["i_like"] as? String
//                user.my_date_would = dictionary["my_date_would"] as? String
//
//                user.age = dictionary["age"] as? [String: Any]
//                user.height = dictionary["height"] as? [String: Any]
//                user.weight = dictionary["weight"] as? [String: Any]
//                user.ethnicity = dictionary["ethnicity"] as? [String: Any]
//                user.relationship_status = dictionary["relationship_status"] as? [String: Any]
//                user.want = dictionary["want"] as? [String: Any]
//                user.looking_for = dictionary["looking_for"] as? [String: Any]
//
//                user.gender = dictionary["gender"] as? [String: Any]
//                user.interested = dictionary["interested"] as? [String: Any]
//
//            }
//        }, withCancel: nil)
//
//
//        return user
//    }
    
    static func getUser(with uid: String, completion: @escaping (User?, Error?) -> Void) {

        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let user = User()
                
                user.uid = dictionary["uid"] as? String
                user.email = dictionary["email"] as? String
                
                user.profile_photo_url = dictionary["profile_photo_url"] as? String
                
                user.user_name = dictionary["user_name"] as? String
                user.i_am = dictionary["i_am"] as? String
                user.i_like = dictionary["i_like"] as? String
                user.my_date_would = dictionary["my_date_would"] as? String
                
                user.age = dictionary["age"] as? [String: Any]
                user.height = dictionary["height"] as? [String: Any]
                user.weight = dictionary["weight"] as? [String: Any]
                user.ethnicity = dictionary["ethnicity"] as? [String: Any]
                user.relationship_status = dictionary["relationship_status"] as? [String: Any]
                user.want = dictionary["want"] as? [String: Any]
                user.looking_for = dictionary["looking_for"] as? [String: Any]
                
                user.gender = dictionary["gender"] as? [String: Any]
                user.interested = dictionary["interested"] as? [String: Any]
                
                user.followings = dictionary["followings"] as? [String]
                user.followers = dictionary["followers"] as? [String]
                
                completion(user, nil)
            }
        }) { (error) in
            completion(nil, error)
        }
    }
}
