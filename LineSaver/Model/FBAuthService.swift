//
//  FBAuthService.swift
//  
//
//  Created by Cat  on 4/22/20.
//

import Foundation
import FirebaseAuth

class FBAuthService: NSObject {
    
    // Swift Singleton pattern
    static let shared = FBAuthService()
    var currentLSUser: User = User()

    var currentLSStore: Store = Store() 
    
    func getCurrentUniqueID() ->String {
        return currentLSUser.uniqueID
    }
    // MAKE THIS ON SUCCESS BC OF ASYNCH
    // Creates the initial account with the user's email and password, & starts first half of phone number verification
    func signUpInitial (email: String, username:String, password:String, phoneNum: String, zip:Int, onSuccess: @escaping (String) -> Void){
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                // User's account data is in the authResult object that's passed to the callback method.
                print("result \(String(describing: authResult))")
            }
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("unable to get secret ID", error.localizedDescription)
                return
            }
            guard let verificationID = verificationID else {return}
            print("verificationID \(String(describing: verificationID))")
            self.currentLSUser.zipcode = zip
            self.currentLSUser.username = username
            onSuccess(verificationID)
        }
    }
    
    func signUpEmployee(email:String, password:String, storeID:String, onSuccess: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // User's account data is in the authResult object that's passed to the callback method.
            print("result \(String(describing: authResult))")
            if let error = error {
                print("Error creating new account", error.localizedDescription)
                return
            }
            // set the current store
            FBDatabaseService.shared.getStoreFromShorthandID(shorthandID: storeID) { (currentStore) in
                self.currentLSStore = currentStore
                // add to employee database
                guard let currentUser = Auth.auth().currentUser else {return}
                let employeeID = currentUser.uid
                FBDatabaseService.shared.addToEmployeeDatabase(uniqueID: employeeID, store: self.currentLSStore)
                onSuccess(true)
            }
        }
    }
    
    // MAKE THIS ON SUCCESS BC OF ASYNCH
    // Completes the creating of user account by merging account that takes in email/password with account that
    // just uses phone number validation
    func validatePhoneNumber(verificationID:String, verificationCode:String, onSuccess: @escaping (Bool) -> Void){
        let credential = PhoneAuthProvider.provider().credential(
                 withVerificationID: verificationID,
                 verificationCode: verificationCode)
        guard let currentUser = Auth.auth().currentUser else {return}
        currentUser.link(with: credential) { (authResult, error) in
            if error == nil {
                print("success! \(String(describing: authResult))")
                self.currentLSUser.uniqueID = currentUser.uid
                onSuccess(true)
                // write current user to database
                FBDatabaseService.shared.addToUserDatabase(newUser: self.currentLSUser) {
                    (failure) in
                    if failure {
                        print("couldn't add to user database")
                    }
                }
            }
            else {
                print(error.debugDescription)
            }
        }
    }
    
    // signs in an employee through Firebase auth & retrieves the respective store from the database
    func signInEmployee(withEmail:String, password:String, onSuccess:@escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password) {  authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                guard let currentUser = Auth.auth().currentUser else {return}
                // set current store from firebase
                FBDatabaseService.shared.getStoreFromEmployeeID(employeeID: currentUser.uid) { (store) in
                    self.currentLSStore = store
                    onSuccess(true)
                }
            }
        }
    }
    
    // signs in the customer with firebase auth and retrieves the user's info from the database
    func signInCustomer(withEmail:String, password:String, onSuccess: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password) {  authResult, error in
            if let error = error {
                print(error.localizedDescription)
                onSuccess(false)
                return
            }
            else {
                guard let currentUser = Auth.auth().currentUser else {return}
                // set current user from firebase
                FBDatabaseService.shared.getExistingUser(uid: currentUser.uid) { (user) in
                    self.currentLSUser = user
                    onSuccess(true)
                }
            }
        }
    }
    
    // signs out the user
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            currentLSUser = User()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return false
        }
        return true
    }
    
}
