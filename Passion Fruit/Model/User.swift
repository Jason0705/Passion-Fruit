//
//  User.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-12-12.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import Foundation


class User: NSObject {
    var uid: String?
    var email: String?
    
    var profile_photo_url: String?
    
    var user_name: String?
    var i_am: String?
    var i_like: String?
    var my_date_would: String?
    
    var age: [String: Any]?
    var height: [String: Any]?
    var weight: [String: Any]?
    var ethnicity: [String: Any]?
    var relationship_status: [String: Any]?
    var want: [String: Any]?
    var looking_for: [String: Any]?
    
    var gender: [String: Any]?
    var interested: [String: Any]?
    
    var followings: [String]?
    var followers: [String]?
}
