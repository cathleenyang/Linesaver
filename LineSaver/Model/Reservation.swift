//
//  Reservation.swift
//  LineSaver
//
//  Created by Cat  on 4/15/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation

// this includes mobile queue and actual reservation
struct Reservation {
    // REQUIRED FOR ALL RESERVATIONS
    // type will be either queue or schedule
    var type:String = ""
    var store:Store = Store()
    var userID:String = ""
    var notificationTime:Int = 0 // int representation of minutes until notified
    // generated from firebase
    var uniqueID:String = ""
    var active:Bool = false
    
    // INITIALIZER FOR RESERVATION
    init (type:String, store:Store, userID:String, notificationTime:Int, uniqueID:String) {
        self.type = type
        self.store = store
        self.userID = userID
        self.notificationTime = notificationTime
        self.uniqueID = uniqueID
    }
    // INITIALIZER FOR SCHEDULED RESERVATIONS
    init (type:String, store:Store, userID:String, notificationTime:Int, uniqueID:String, dateAndTime:Date) {
        self.init(type:type, store: store, userID: userID, notificationTime: notificationTime, uniqueID: uniqueID )
        self.dateAndTime = dateAndTime
    }
    // REQUIRED FOR SCHEDULED RESERVATIONS
    var dateAndTime:Date?
    
    // INITIALIZER FOR LINE RESERVATIONS
    init (type:String, store:Store, userID:String, notificationTime:Int, uniqueID:String, position:Int, waitTime:Int) {
        self.init(type:type, store: store, userID: userID, notificationTime: notificationTime, uniqueID: uniqueID )
        self.placeInLine = position
        // wait time per customer 
        self.currentWaitTime = waitTime
    }
    // REQUIRED FOR LINE RESERVATION
    var placeInLine:Int?
    var currentWaitTime:Int?
    
    
}
