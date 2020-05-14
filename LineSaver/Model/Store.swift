//
//  Store.swift
//  LineSaver
//
//  Created by Cat  on 4/15/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation

class Store {
    // Info from Google API Call
    
    // Will double as the key in the firebase database
    var placeID:String = ""
    
    var latitude:Double = 0
    var longitude:Double = 0
    var name:String = ""
    // Google Places calls it vicinity
    var address:String = ""
    // not stored in database, calculated 
    var distanceFromCurrentUser: Double {
        return LocationService.shared.distance(latitude: latitude, longitude: longitude)
    }
    
    init() {}
    
    init(placeID:String, name:String, address:String) {
        self.placeID = placeID
        self.name = name
        self.address = address
    }
    
    convenience init(placeID:String, name:String, address:String, latitude:Double, longitude:Double) {
        self.init(placeID:placeID, name:name, address:address)
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(placeID:String, name:String, address:String, zipcode:String) {
        self.init(placeID:placeID, name:name, address:address)
        self.zip = Int(zipcode) ?? 0
    }
    
    var zip:Int = 0

    // each store has a queue of users
    var queue = Queue<User>()
    
    // each store has a map of user reservations

    var maxCapacity :Int?
    // stores the current wait time in minutes
    var currentWaitTime:Int?
    // tbd how to add in the popular times feature
    // currently only available through web scraping & in python
    var queuingEnabled:Bool = true
    
    var lastUpdate:Int = 5
    
    static let storeSorter: (Store, Store) -> Bool = { $0.distanceFromCurrentUser < $1.distanceFromCurrentUser}
}

