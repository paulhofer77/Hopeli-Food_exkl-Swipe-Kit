//
//  Dishes.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift

class Dishes: Object {
    
    @objc dynamic var dishName: String = ""
    @objc dynamic var dishTimestamp: Date?
    @objc dynamic var dishImage: NSData?
   
    let users = List<User>()
    let ingredients = List<Ingredients>()
    
}
