//
//  User.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-12-12.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import UIKit


//struct SingleChoice {
//    var content: String?
//    var choice: Int?
//}
//
//struct MultipleChoice {
//    var content: String?
//    var choice: [Int]?
//}


class User: NSObject {
    var uid: String?
    var email: String?
    
    var profile_photo_url: String?
    
    var user_name: String?
    var i_am: String?
    var i_like: String?
    var my_date_would: String?
    
//    var age: Int?
//    var height: Int?
//    var weight: Int?
//    var ethnicity: Int?
//    var relationship_status: Int?
//    var want: Int?
//    var looking_for: [Int]?
//
//    var gender: Int?
//    var interested: [Int]?
    
//    var age: SingleChoice?
//    var height: SingleChoice?
//    var weight: SingleChoice?
//    var ethnicity: SingleChoice?
//    var relationship_status: SingleChoice?
//    var want: SingleChoice?
//    var looking_for: MultipleChoice?
//
//    var gender: SingleChoice?
//    var interested: MultipleChoice?
    
    
    var age: [String: Any]?
    var height: [String: Any]?
    var weight: [String: Any]?
    var ethnicity: [String: Any]?
    var relationship_status: [String: Any]?
    var want: [String: Any]?
    var looking_for: [String: Any]?
    
    var gender: [String: Any]?
    var interested: [String: Any]?
}
