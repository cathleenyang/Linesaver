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
    var placeID:String!
    
    private var latitude:Double!
    private var longitude:Double!
    private var name:String!
    // Google Places calls it vicinity
    private var address:String!
    private var distanceFromCurrentUser: Double!
    
    init(placeID: String, lat: Double, long: Double, name:String, address:String, distance:Double) {
        self.placeID = placeID
        self.latitude = lat
        self.longitude = long
        self.name = name
        self.address = address
        self.distanceFromCurrentUser = distance
    }
    var zip:Int?
    func getZip() -> Int {
        if let zip = zip {
            return zip
        }
        else {
            return 0
        }
    }
    func getName() -> String {
        return name
    }
    func getDistance() -> Double {
        return distanceFromCurrentUser
    }
    func getWait() -> Int? {
        return currentWaitTime
    }
    func getPlaceID() -> String {
        return placeID
    }
    func getLat() -> Double {
        return latitude
    }
    func getLong() -> Double {
        return longitude
    }
    func getAddress() -> String {
        return address
    }
    // each store has a queue of users
    private var queue = Queue<User>()
    
    func getQueue() -> Queue<User> {
        return queue
    }
    private var maxCapacity :Int?
    // stores the current wait time in minutes
    private var currentWaitTime:Int?
    // tbd how to add in the popular times feature
    // currently only available through web scraping & in python
    private var queuingEnabled:Bool = false
    
    func isQueingEnabled() -> Bool {
        return queuingEnabled
    }
    static let storeSorter: (Store, Store) -> Bool = { $0.distanceFromCurrentUser < $1.distanceFromCurrentUser}
}

//struct Image : Decodable {
//    let id: String
//    let width: Int
//    let height: Int
//    let color: String
//    let likes: Int
//    let urls: ImageUrl
//}
