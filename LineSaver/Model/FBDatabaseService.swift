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
    
    // Adds a user to Firebase using it's unique user ID from Firebase Auth as the key
    // only populates the required fields for a user
    func addToUserDatabase(newUser: User, onFailure: @escaping (Bool) -> Void) {
        let usersRef = ref.child("users/\(newUser.getUID())")
        // maybe add error checking to ensure that the user isn't already in the database?
        usersRef.observe(.value, with: {(snapshot) in
            if snapshot.exists() {
                // 
                onFailure(true)
            }
            else {
                let uniqueUser = usersRef.child(newUser.getUID())
                let userObj = ["name" : "insert username",
                               "zipcode" : String(newUser.getZip())]
                uniqueUser.setValue(userObj)
                print("added to database")
            }
        })
    }
    
    func getExistingUser(uid: String, onSuccess: @escaping (User)-> Void) {
        
    }
    
    func addUserToQueue(user: User, store: Store) {
        let storeRef = ref.child("stores/") //\(store.zip)/\(store.getPlaceID())
        // check if the queue already exists
        storeRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let queuingEnabled = value?["queuing_enabled"] as? Bool ?? false
            if queuingEnabled {
                // check if there's a queue already
                if var queue = value?["queue"] as? [String: Bool] {
                    // append to the queue
                    queue[user.getUID()] = true
                    
                }

                // otherwise create a new queue
                else {
                    let queueObj = [user.getUID() : true]
                    storeRef.child("queue").setValue(queueObj)
                }
            }
        })
    }
    
    
    func getExistingStores(zip: Int) {
        
    }
    
    // Adds a store to Firebase first by Zip code, then unique place ID
    // only populates the required fields for a store
    func addToStoreDatabase(newStore: Store) {
        let storesRef = ref.child("stores")
        
        // Update the key that just maintains all stores
        let storeIDRef = storesRef.child("store ids").child(newStore.getPlaceID())
        storeIDRef.setValue(true)
        
        // Create an actual new store entry
        
        let zipRef = storesRef.child("zips/\(newStore.getZip())")
        let uniqueStore = zipRef.child(newStore.getPlaceID())
        let storeObj = ["name" : newStore.getName(),
                        "address" : newStore.getAddress(),
                        "queuing_enabled" : String(newStore.isQueingEnabled())]
        uniqueStore.setValue(storeObj)
        let coords = ["lat" : newStore.getLat(),
                      "long" : newStore.getLong()]
        uniqueStore.child("coords").setValue(coords)
    }
    
    
    
}
