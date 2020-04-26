//
//  VerificationCodeViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/14/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit
import FirebaseAuth

class VerificationCodeViewController: UIViewController {

    @IBOutlet weak var verificationCodeTF: BottomBorderTextField!
    var verificationID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }
    
    // connect with firebase to verify phone number, then link with existing account 
    @IBAction func submitWasPressed(_ sender: RoundedButton) {
        guard let verificationID = self.verificationID else {return}
        let code = verificationCodeTF.text!
        FBAuthService.shared.validatePhoneNumber(verificationID: verificationID, verificationCode: code) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    // maybe have an alert giving the option to get a new code
                    print("Error")
                }
            }
        }
        
    }
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard verificationCodeTF != nil else {
            return
        }
        
        verificationCodeTF?.resignFirstResponder()
    }
    

}
