//
//  CreateAccountViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/13/20.
//  Copyright © 2020 Cat . All rights reserved.
//

/*
Reference for scrolling:  https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field */
import UIKit
import FirebaseAuth


class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTF: UITextField! {
        didSet {
            if let icon = UIImage(named: "icon-user") {
                usernameTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var passwordTF: UITextField! {
        didSet {
            if let icon = UIImage(named: "icon-lock") {
                passwordTF.setIcon(icon)
            }
        }
    }
    
    @IBOutlet weak var confirmPasswordTF: UITextField! {
        didSet {
            if let icon = UIImage(named: "icon-lock") {
                confirmPasswordTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var phoneTF: UITextField! {
        didSet {
            if let icon = UIImage(named: "icon-phone") {
                phoneTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var zipcodeTF: UITextField! {
        didSet {
            if let icon = UIImage(named: "icon-location") {
                zipcodeTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    var verificationID: String?
    
    @IBOutlet weak var signUpButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTF.delegate = self
        self.passwordTF.delegate = self
        self.confirmPasswordTF.delegate = self
        self.phoneTF.delegate = self
        self.zipcodeTF.delegate = self
        
        self.usernameTF.text = "cathleey@usc.edu"
        self.passwordTF.text = "password"
        self.confirmPasswordTF.text = "password"
        self.phoneTF.text = "626-552-1795"
        self.zipcodeTF.text = "91006"
        
        registerForKeyboardNotifications()
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }
    
    @IBAction func signUpButtonClicked(_ sender: RoundedButton) {
        if checkValidInput() {
            // create account through firebase
            guard let username = usernameTF.text, !username.isEmpty else {return}
            guard let password = passwordTF.text, !password.isEmpty else {return}
            guard let zip = zipcodeTF.text, !zip.isEmpty else {return}
            let phone = "+16505552222"
            
            FBAuthService.shared.signUpInitial(email: username, password: password, phoneNum: phone, zip: Int(zip) ?? 0, onSuccess: { (verificationID) in DispatchQueue.main.async {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                }
            })
        }
        else {
            resetFields()
        }
    }
    
    func checkValidInput() -> Bool {
        guard let username = usernameTF.text, !username.isEmpty else {
            return false
        }
        let validEmail = username.isValidEmail
        guard let password = passwordTF.text, !password.isEmpty else {
            return false
        }
        guard let confirmPass = confirmPasswordTF.text, !confirmPass.isEmpty else {
            return false
        }
        let matching = password == confirmPass
        guard let phone = phoneTF.text, !phone.isEmpty else {
            return false
        }
//        let validPhone = phone.isValidPhone
        guard let zip = zipcodeTF.text, !zip.isEmpty else {
            return false
        }
        let validZip = zip.isValidZip
        return validEmail && matching && validZip
    }
    
    func resetFields() {
        self.usernameTF.text = nil
        self.passwordTF.text = nil
        self.confirmPasswordTF.text = nil
        self.phoneTF.text = nil
        self.zipcodeTF.text = nil
    }
    
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if(!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        // Once keyboard disappears, restore original positions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top:0.0, left: 0.0, bottom: -keyboardSize!.height, right:0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let activeField = self.activeField {
            activeField.resignFirstResponder()
            self.activeField = nil
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
        if let viewController = (segue.destination as? VerificationCodeViewController) {
            if let id = segue.identifier {
                if id == "Verify" {
                    guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else{return}
                    viewController.verificationID = verificationID
                }
            }
        }
    }
    

}

