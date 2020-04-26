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
    private var currentLSUser: User?
    private var zip:Int!
    
    // MAKE THIS ON SUCCESS BC OF ASYNCH
    // On failure? - is this necessary?
    // Creates the initial account with the user's email and password, & starts first half of phone number verification
    func signUpInitial (email: String, password:String, phoneNum: String, zip:Int, onSuccess: @escaping (String) -> Void){
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                // User's account data is in the authResult object that's passed to the callback method.
                print("result \(String(describing: authResult))")
            }
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
            //                self.showMessagePrompt(error.localizedDescription)
                print("unable to get secret ID", error.localizedDescription)
                return
            }
            else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            guard let verificationID = verificationID else {return}
            print("verificationID \(String(describing: verificationID))")
            self.zip = zip
            onSuccess(verificationID)
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
                self.currentLSUser = User(zipcode: self.zip, uniqueID: currentUser.uid)
                // write current user to database
                onSuccess(true)
            }
            else {
                print(error.debugDescription)
            }
        }
    }
    
    func signIn(withEmail:String, password:String, onSuccess: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password) {  authResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                // set current user from firebase
                onSuccess(true)
                //self.currentLSUser = FBDatabaseService.getExistingUser() 
            }
        }
    }
    
    func getCurrentUser() -> User? {
        return currentLSUser
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            currentLSUser = nil
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return false
        }
        return true
    }
    
}
