//
//  Ingredients.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 09.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift

class Ingredients: Object {
    
    @objc dynamic var ingredientName: String = ""
    @objc dynamic var ingredientTimestamp: Date?
    @objc dynamic var ingredientSelected: Bool = false
   
    let dishes = List<Dishes>()
    
}


