//
//  FollowService.swift
//  Passion Fruit
//
//  Created by Jason Li on 2019-04-08.
//  Copyright © 2019 Jason Li. All rights reserved.
//

//import Foundation
//import FirebaseDatabase
//
//
//class FollowService {
//
//
//
//    static func followUser(of uid: String) {
//        let currentUserID = UserService.getCurrentUserID()
//        let databaseReference = Database.database().reference()
//
//        let currentUserReference = databaseReference.child("users").child(currentUserID)
//        let userReference = databaseReference.child("users").child(uid)
//
//        fetchFollowings(of: currentUserID) { (followings) in
//            var newFollowings = followings
//            appendFollower(uid: uid, to: &newFollowings)
//            currentUserReference.child("followings").setValue(newFollowings)
//        }
//
//        fetchFollowers(of: uid) { (followers) in
//            var newFollowers = followers
//            appendFollower(uid: currentUserID, to: &newFollowers)
//            userReference.child("followers").setValue(newFollowers)
//        }
//
//    }
//
//    static func unfollowUser(of uid: String) {
//        let currentUserID = UserService.getCurrentUserID()
//        let databaseReference = Database.database().reference()
//
//        let currentUserReference = databaseReference.child("users").child(currentUserID)
//        let userReference = databaseReference.child("users").child(uid)
//
//        fetchFollowings(of: currentUserID) { (followings) in
//            var newFollowings = followings
//            removeFollower(uid: uid, from: &newFollowings)
//            currentUserReference.child("followings").setValue(newFollowings)
//        }
//
//        fetchFollowers(of: uid) { (followers) in
//            var newFollowers = followers
//            removeFollower(uid: currentUserID, from: &newFollowers)
//            userReference.child("followers").setValue(newFollowers)
//        }
//    }
//
//    static func fetchFollowings(of uid: String, completion: @escaping ([String]) -> Void) {
////        UserService.getUserOnce(with: uid) { (user, error) in
////            if error != nil {
////                print("Error fetching followings: \(error!)")
////            }
////            else if user != nil {
////                if let followings = user?.followings {
////                    completion(followings)
////                }
////            }
////        }
////        completion([String]())
//
//        let databaseReference = Database.database().reference()
//        let userReference = databaseReference.child("users").child(uid)
//
//        userReference.child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let followings = snapshot.value as? [String] {
//                completion(followings)
//            }
//            completion([String]())
//        }, withCancel: nil)
//    }
//
//    static func fetchFollowers(of uid: String, completion: @escaping ([String]) -> Void) {
////        UserService.getUserOnce(with: uid) { (user, error) in
////            if error != nil {
////                print("Error fetching followers: \(error!)")
////            }
////            else if user != nil {
////                if let followers = user?.followers {
////                completion(followers)
////                }
////            }
////        }
////        completion([String]())
//
//        let databaseReference = Database.database().reference()
//        let userReference = databaseReference.child("users").child(uid)
//
//        userReference.child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let followers = snapshot.value as? [String] {
//                completion(followers)
//            }
//            completion([String]())
//        }, withCancel: nil)
//    }
//
//    static func appendFollower(uid: String, to array: inout [String]) {
//
//        if !array.contains(uid) {
//            array.append(uid)
//        }
//    }
//
//
//    static func removeFollower(uid: String, from array: inout [String]) {
//        array.removeAll{$0 == uid}
//
//    }
//
//    static func isFollowingUser(of uid: String, completion: @escaping (Bool) -> Void) {
//        fetchFollowings(of: UserService.getCurrentUserID()) { (followings) in
//            if followings.count > 0 {
//                for i in 0...followings.count - 1 {
//                    if followings[i] == uid {
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }
//
//}






import Foundation
import FirebaseDatabase


class FollowService {
    
    static var followings = [""]//[String]()
    static var followers = [""]//[String]()
    
    static func followUser(of uid: String) {
        let currentUserID = UserService.getCurrentUserID()
        let databaseReference = Database.database().reference()
        
        let currentUserReference = databaseReference.child("users").child(currentUserID)
        let userReference = databaseReference.child("users").child(uid)
        
        fetchFollowings(of: currentUserID)
        fetchFollowers(of: uid)
        
        appendFollower(uid: uid, to: &followings)
        appendFollower(uid: currentUserID, to: &followers)
        
        currentUserReference.child("followings").setValue(followings)
        userReference.child("followers").setValue(followers)
        
    }
    
    static func unfollowUser(of uid: String) {
        let currentUserID = UserService.getCurrentUserID()
        let databaseReference = Database.database().reference()
        
        let currentUserReference = databaseReference.child("users").child(currentUserID)
        let userReference = databaseReference.child("users").child(uid)
        
        fetchFollowings(of: currentUserID)
        fetchFollowers(of: uid)
        
        removeFollower(uid: uid, from: &followings)
        removeFollower(uid: currentUserID, from: &followers)
        
        currentUserReference.child("followings").setValue(followings)
        userReference.child("followers").setValue(followers)
    }
    
    static func fetchFollowings(of uid: String) {
        
        let databaseReference = Database.database().reference()
        let userReference = databaseReference.child("users").child(uid)
        
        userReference.child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
            if let followings = snapshot.value as? [String] {
                self.followings = followings
            }
        }, withCancel: nil)
    }
    
    static func fetchFollowers(of uid: String) {
        
        let databaseReference = Database.database().reference()
        let userReference = databaseReference.child("users").child(uid)
        
        userReference.child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
            if let followers = snapshot.value as? [String] {
                self.followers = followers
            }
        }, withCancel: nil)
    }
    
    static func appendFollower(uid: String, to array: inout [String]) {
        if !array.contains(uid) {
            array.append(uid)
        }
    }
    
    
    static func removeFollower(uid: String, from array: inout [String]) {
        array.removeAll{$0 == uid}
    }
    
    static func isFollowingUser(of uid: String) -> Bool {
        fetchFollowings(of: UserService.getCurrentUserID())
        
        var following = false
        
//        if followings.count > 0 {
//            for i in 0...followings.count - 1 {
//                if followings[i] == uid {
//                    following = true
//                }
//            }
//        }
        if followings.contains(uid) {
            following = true
        }
        
        return following
        
    }
    
}
