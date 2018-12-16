//
//  StaticVariables.swift
//  Passion Fruit
//
//  Created by Jason Li on 2018-11-24.
//  Copyright © 2018 Jason Li. All rights reserved.
//

import Foundation

struct StaticVariables {
    
    static var agePickerData = (18...100).map {"\($0)"}
    static var heightPickerData = (100...250).map {"\($0) cm"}
    static var weightPickerData = (40...280).map {"\($0) kg"}
    
    
    
    static let imageCells = ["Image"]
    static let infoCells = ["User Name", "I AM", "I Like", "My Date Would"] // hold infoCell displaying title
    static let statsCells = ["Age", "Height", "Weight", "Ethnicity", "Relationship Status", "I Want", "I'm Looking For"] // hold statsCell displaying title
    static let sexualityCells = ["Gender", "Interested In"] // hold sexualityCell displaying title
    
    static let infoCellPlaceholders = ["This will be displayed on your profile...", "Let people know about you...", "Let people know what you like...", "Let people know what you expect..."]
    
    static let ethnicityPickerData = ["Do Not Show", "Asian", "African", "Latino", "Middle Eastern", "Native American", "White", "South Asian", "Mixed", "Other"]
    static let relationshipPickerData = ["Do Not Show", "Single", "Dating", "Exclusive", "Committed", "Engaged", "Partnered", "Married", "Open Relationship", "Separated", "Divorced"]
    static let wantPickerData = ["Do Not Show", "Relationship", "Fun", "Both"]
    static let lookingData = ["Love", "Friends", "Dates", "Chat", "Networking", "NSA", "Right Now", "Discreet Fun", "Kinks"]
    
    static let genderPickerData = ["Do Not Show", "Male", "Female", "Trans Male", "Trans Female"]
    static let interestedData = ["Male", "Female", "Trans Male", "Trans Female"]
    
//    init() {
//        StaticVariables.agePickerData.insert("Do Not Show", at: 0)
//        StaticVariables.heightPickerData.insert("Do Not Show", at: 0)
//        StaticVariables.weightPickerData.insert("Do Not Show", at: 0)
//    }
}
