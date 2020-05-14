//
//  FBDatabaseService.swift
//  LineSaver
//
//  Created by Cat  on 4/22/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation
import FirebaseDatabase

class FBDatabaseService: NSObject {
    
    var ref: DatabaseReference!
    
    // Swift Singleton pattern
    static let shared = FBDatabaseService()
    
    override init() {
        super.init()
        ref = Database.database().reference()
    }
    
    func getCurrentWaitTime(storeID: String, onSuccess: @escaping (Int) -> Void) {
        let lineRef = ref.child("active_queues/\(storeID)")
        lineRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let waitTime = value?["currentWaitTime"] as? Int
            let queue = value?["queue"] as? NSDictionary
            let numberInLine:Int = queue?.count ?? 1
            onSuccess((waitTime ?? 0) * numberInLine) 
        }
    }
    
    // Adds a user to Firebase using it's unique user ID from Firebase Auth as the key
    // only populates the required fields for a user
    func addToUserDatabase(newUser: User, onFailure: @escaping (Bool) -> Void) {
        // add to the usernames database
        let usernamesRef = ref.child("users/usernames/")
        let username = newUser.username
        usernamesRef.child("\(username.lowercased())").setValue(newUser.uniqueID)
        // add to the users/details database
        let usersRef = ref.child("users/details")
        usersRef.observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let user = value?["\(newUser.uniqueID)"] as? NSDictionary
            if user == nil {
                let uniqueUser = usersRef.child(newUser.uniqueID)
                let userObj = ["username" : "\(newUser.username)",
                    "zipcode" : newUser.zipcode ?? 0] as [String : Any]
                uniqueUser.setValue(userObj)
                print("added to database")
            }
            else {
                onFailure(true)
            }
        }
    }
    
    func addToEmployeeDatabase(uniqueID:String, store:Store) {
        let employeesRef = ref.child("employees")
        let employeeObj = ["placeID" : store.placeID,
                           "zipcode" : store.zip,
                           "name"    : store.name,
                           "address" : store.address] as [String : Any] 
        employeesRef.child("\(uniqueID)").setValue(employeeObj)
    }
    
    
    // detect if anything has changed, set a bool if the text has changed then call the API 
    // returns true if a user already exists with this username 
    func checkUniqueUsername( username: String, onSuccess: @escaping (Bool)-> Void)  {
        let usersRef = ref.child("users/usernames")
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let user = value?["\(username)"] as? String
            if user != nil {
                onSuccess(true)
            }
        }
        
    }
    
    // 
    func getExistingUser(uid: String, onSuccess: @escaping (User)-> Void) {
        let usersRef = ref.child("users/details")
        usersRef.observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let user = value?["\(uid)"] as? NSDictionary
            if user != nil {
                guard let username = user?["username"] as? String else {return}
                guard let zip = user?["zipcode"] as? Int else {return}
                onSuccess( User(zipcode: zip, username: username, uniqueID: uid))
                print("retreived from database")
            }
            else {
                print("user was not found")
            }
        }
    }
    
    // ACTIVE QUEUES DATABASE
    // USERS DATABASE 
    func addUserToQueue(user: User, store: Store) {
        let storeRef = ref.child("stores/\(store.zip)/\(store.placeID)")
        // check if the queue already exists
        storeRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let queuingEnabled = value?["queuing_enabled"] as? Bool ?? false
            if queuingEnabled {
                storeRef.child("queue").child(user.uniqueID).setValue(true)
            }
        })
    }
    
    // returns a Store given it's shorthand ID native to the app 
    func getStoreFromShorthandID(shorthandID: String, onSuccess: @escaping (Store) -> Void) {
        let storesRef = ref.child("stores/annotatedStoreIDs")
        storesRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let store = value?["\(shorthandID)"] as? NSDictionary
            if store != nil {
                let name = store?["name"] as? String ?? ""
                let address = store?["address"] as? String ?? ""
                let placeID = store?["placeID"] as? String ?? ""
                let zipcode = store?["zipcode"] as? String ?? ""
                onSuccess(Store(placeID: placeID, name: name, address: address, zipcode: zipcode))
            }
        }
    }
    
    // returns a Store given an employee ID (generated from firebase auth)
    func getStoreFromEmployeeID(employeeID:String, onSuccess: @escaping (Store) -> Void) {
        let employeeRef = ref.child("employees/\(employeeID)")
        employeeRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            guard let storeID = value?["placeID"] as? String else {return}
            guard let zip = value?["zipcode"] as? Int else {return}
            guard let name = value?["name"] as? String else {return}
            guard let address = value?["address"] as? String else {return}
            onSuccess(Store(placeID: storeID, name: name, address: address, zipcode: String(zip)))
        }
    }
    
    // returns a users reservations in the form of an array
    func getReservations(uniqueID:String, onSuccess: @escaping ([Reservation]) -> Void) {
        let usersRef = ref.child("users/details/\(uniqueID)/reservations")
        var reservations:[Reservation] = [Reservation]()
        //var count = 0;
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.childrenCount)
            for case let snap as DataSnapshot in snapshot.children {
                let value = snap.value as? NSDictionary
                guard let type = value?["type"] as? String else {return}
                guard let store = value?["store"] as? NSDictionary else {return}
               
                // STORE INFORMATION
                guard let storeName = store["name"] as? String else {return}
                guard let storeAddress = store["address"] as? String else {return}
                guard let storeLat = store["latitude"] as? Double else {return}
                guard let storeLong = store["longitude"] as? Double else {return}
                guard let storeID = store["placeID"] as? String else {return}
                
                let storeObj = Store(placeID: storeID, name: storeName, address: storeAddress, latitude: storeLat, longitude: storeLong)
                
                guard let notificationTime = value?["notificationTime"] as? Int else {return}
                let uniqueID = snap.key
                
                // construct a queue reservation
                if type == "queue" {
                    guard let position = value?["placeInLine"] as? Int else {return}
                    guard let waitTime = value?["waitTime"] as? Int else {return}
                    reservations.append(Reservation(type: type, store: storeObj, userID: uniqueID, notificationTime: notificationTime, uniqueID: uniqueID, position: position, waitTime: waitTime))
                }
                // construct a scheduled reservation
                else if type == "schedule" {
                    guard let timestamp = value?["dateAndTime"] as? Double else {return}
                    guard let date = DateService.shared.getDateFromUnixTimestamp(date: timestamp) else {return}
                    reservations.append(Reservation(type: type, store: storeObj, userID: uniqueID, notificationTime: notificationTime, uniqueID: uniqueID, dateAndTime: date))
                }
            }
            reservations[1].active = true
            onSuccess(reservations)
        }
    }
    
    func getCurrentLine(store:Store, onSuccess: @escaping ([User]) -> Void) {
        let queuesRef = ref.child("active_queues/\(store.placeID)/queue")
        var usersInLine: [User] = [User]()
        queuesRef.observeSingleEvent(of: .value) { (snapshot) in
            for case let snap as DataSnapshot in snapshot.children {
                guard let username = snap.value as? String else {return}
                let uniqueID = snap.key
                usersInLine.append(User(username: username, uniqueID: uniqueID))
            }
            onSuccess(usersInLine)
        }
    }
    
    
    // Adds a store to Firebase first by Zip code, then unique place ID
    // only populates the required fields for a store
    func addToStoreDatabase(newStore: Store) {
        let storesRef = ref.child("stores/storeIDs")
        
        // check first if the store exists or not, need to make sure not overwriting data
        storesRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let store = value?["\(newStore.placeID)"] as? Int
            // store exists already, no need to add to the database again
            if store != nil {
                return
            }
            else {
                // Update the key that just maintains all stores
                let storeIDRef = storesRef.child(newStore.placeID)
                storeIDRef.setValue(newStore.zip)
                // Create an actual new store entry
                let zipRef = self.ref.child("stores/zips/\(newStore.zip)")
                let uniqueStore = zipRef.child(newStore.placeID)
                let storeObj = ["name" : newStore.name,
                                "address" : newStore.address,
                                "queuing_enabled" : String(newStore.queuingEnabled)]
                uniqueStore.setValue(storeObj)
                let coords = ["lat" : newStore.latitude,
                              "long" : newStore.longitude]
                uniqueStore.child("coords").setValue(coords)
            }
        }
    }
    
    
    
}
