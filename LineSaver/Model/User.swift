//
//  User.swift
//  LineSaver
//
//  Created by Cat  on 4/13/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation

// all actual login information is done behind the scenes w/ firebase, i.e. email, password & phone number
struct User : Encodable, Decodable{
    
    var uniqueID : String
    var username: String
    var zipcode : Int
    
    init() {
        self.uniqueID = ""
        self.username = ""
        self.zipcode = 0
    }
    
    init(username:String, uniqueID:String) {
        self.username = username
        self.uniqueID = uniqueID
        self.zipcode = 0
    }
    init(zipcode:Int, username:String, uniqueID:String) {
        self.zipcode = zipcode
        self.username = username
        self.uniqueID = uniqueID
    }
    
    
    
}
