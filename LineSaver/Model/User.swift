//
//  User.swift
//  LineSaver
//
//  Created by Cat  on 4/13/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation

// all actual login information is done behind the scenes w/ firebase, i.e. email, password & phone number
struct User {
    private var username: String?
    private var zipcode : Int!
    private var uniqueID : String!
    private var reservations = [Reservation]()
    
    init(zipcode:Int, uniqueID:String) {
        self.zipcode = zipcode
        self.uniqueID = uniqueID
    }
    
    mutating func setUsername(asUsername: String) {
        username = asUsername
    }
    
    func getReservations()-> [Reservation] {
        return reservations
    }
    
    func getUID() -> String {
        return uniqueID
    }
    
    func getZip() -> Int {
        return zipcode
    }
    
    
    func getNumReservations() -> Int {
        return reservations.count
    }
    
    // should adding information here also update it in firebase?
    
    
}
