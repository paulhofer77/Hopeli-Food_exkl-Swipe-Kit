//
//  User.swift
//  Hopeli Food
//
//  Created by Paul Hofer on 01.09.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var userName: String = ""
    @objc dynamic var userEmail: String = ""
    @objc dynamic var userPasswort: String = ""
    @objc dynamic var userId: String?
    @objc dynamic var userImage: NSData?
    let dishes = List<Dishes>()
    
//    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
    
    
}
