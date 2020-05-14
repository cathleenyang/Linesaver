//
//  SignInSignUpViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/28/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FontAwesome_swift
import PhoneNumberKit

extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
    var isValidZip: Bool {
        let testZip = NSPredicate(format: "SELF MATCHES %@", "^\\d{5}(?:[-\\s]?\\d{4})?$")
        return testZip.evaluate(with: self)
    }
    var isValidPhoneNumber: Bool {
        let testPhone = NSPredicate(format: "SELF MATCHES %@", "^(?:(?:\\+?1\\s*(?:[.-]\\s*)?)?(?:\\(\\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*\\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\\s*(?:[.-]\\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$")
        return testPhone.evaluate(with: self)
    }
    var withoutSpaceCharacters: String {
        let spaceLess = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined(separator: "")
        return spaceLess
    }
}

class SignInSignUpViewController: UIViewController, UITextFieldDelegate {
    let confirmedGreenColor = UIColor(red: 32/255.0, green: 160/255.0, blue: 0, alpha: 1.0)
    @IBOutlet weak var userTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            emailTextField.iconType = .font
            emailTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .regular)
            emailTextField.iconText = String.fontAwesomeIcon(name: .envelope)
            emailTextField.iconColor = .black
            emailTextField.iconMarginBottom = 0
            emailTextField.placeholder = "EMAIL"
            emailTextField.title = "Enter your email"
            emailTextField.errorColor = UIColor.red
            emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingDidEnd)
            emailTextField.selectedLineColor = confirmedGreenColor
            emailTextField.selectedTitleColor = confirmedGreenColor
        }
    }
    
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            usernameTextField.iconType = .font
            usernameTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .regular)
            usernameTextField.iconText = String.fontAwesomeIcon(name: .userCircle)
            usernameTextField.iconMarginBottom = 0
            usernameTextField.iconColor = .black
            usernameTextField.placeholder = "USERNAME"
            usernameTextField.title = "Enter a unique username"
            usernameTextField.errorColor = UIColor.red
            usernameTextField.addTarget(self, action: #selector(usernameTextFieldDidChange(_:)), for: .editingDidEnd)
            usernameTextField.selectedLineColor = confirmedGreenColor
            usernameTextField.selectedTitleColor = confirmedGreenColor
        }
    }
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            passwordTextField.iconType = .font
            passwordTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .solid)
            passwordTextField.iconText = String.fontAwesomeIcon(name: .lock)
            passwordTextField.iconMarginBottom = 0
            passwordTextField.iconColor = .black
            passwordTextField.errorColor = UIColor.red
            passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
            passwordTextField.placeholder = "PASSWORD"
            passwordTextField.title = "Enter a secure password"
            //passwordTextField.isSecureTextEntry = true
            passwordTextField.selectedLineColor = confirmedGreenColor
            passwordTextField.selectedTitleColor = confirmedGreenColor
        }
    }
    
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            confirmPassTextField.iconType = .font
            confirmPassTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .solid)
            confirmPassTextField.iconText = String.fontAwesomeIcon(name: .lock)
            confirmPassTextField.iconMarginBottom = 0
            confirmPassTextField.iconColor = .black
            confirmPassTextField.errorColor = UIColor.red
            confirmPassTextField.addTarget(self, action: #selector(confirmPasswordTextFieldDidChange(_:)), for: .editingChanged)
            confirmPassTextField.placeholder = "CONFIRM PASSWORD"
            //confirmPassTextField.isSecureTextEntry = true
            confirmPassTextField.title = "One more time to be sure "
            confirmPassTextField.selectedLineColor = confirmedGreenColor
            confirmPassTextField.selectedTitleColor = confirmedGreenColor
            
        }
    }
    
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            phoneTextField.iconType = .font
            phoneTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .solid)
            phoneTextField.iconText = String.fontAwesomeIcon(name: .phoneAlt)
            phoneTextField.iconMarginBottom = 0
            phoneTextField.iconColor = .black
            phoneTextField.errorColor = UIColor.red
            phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: .editingDidEnd)
            phoneTextField.placeholder = "PHONE NUMBER"
            phoneTextField.title = "+1(xxx)-xxx-xxxx"
            phoneTextField.selectedLineColor = confirmedGreenColor
            phoneTextField.selectedTitleColor = confirmedGreenColor
        }
    }
    
    @IBOutlet weak var storeIDTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            storeIDTextField.iconType = .font
            storeIDTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .solid)
            storeIDTextField.iconText = String.fontAwesomeIcon(name: .building)
            storeIDTextField.iconMarginBottom = 0
            storeIDTextField.iconColor = .black
            storeIDTextField.errorColor = UIColor.red
            storeIDTextField.addTarget(self, action: #selector(storeIDTextFieldDidChange(_:)), for: .editingDidEnd)
            storeIDTextField.placeholder = "STORE ID"
            storeIDTextField.title = "What's your store ID?"
            storeIDTextField.selectedLineColor = confirmedGreenColor
            storeIDTextField.selectedTitleColor = confirmedGreenColor
        }
    }
    
    @IBOutlet weak var zipTextField: SkyFloatingLabelTextFieldWithIcon! {
        didSet {
            zipTextField.iconType = .font
            zipTextField.iconFont = UIFont.fontAwesome(ofSize: 13, style: .solid)
            zipTextField.iconText = String.fontAwesomeIcon(name: .mapMarkerAlt)
            zipTextField.iconMarginBottom = 0
            zipTextField.iconColor = .black
            zipTextField.errorColor = UIColor.red
            zipTextField.addTarget(self, action: #selector(zipTextFieldDidChange(_:)), for: .editingDidEnd)
            zipTextField.placeholder = "ZIPCODE"
            zipTextField.title = "Enter your preferred zip code"
            zipTextField.selectedLineColor = confirmedGreenColor
            zipTextField.selectedTitleColor = confirmedGreenColor
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toggleLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var submitButton: RoundedButton!
    
    var activeField: UITextField?
    var signUpMode:Bool = true
    var segmentedControlIndex:Int = 0
    var phoneNumberObj: PhoneNumber? = nil
    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPassTextField.delegate = self
        self.phoneTextField.delegate = self
        self.storeIDTextField.delegate = self
        self.zipTextField.delegate = self
        
        submitButton.isEnabled = false
        submitButton.setTitleColor(.gray, for: .normal)
        
        userTypeSegmentedControl.selectedSegmentIndex = segmentedControlIndex
        setMode()
        
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    func employeeSignInMode() {
        userTypeSegmentedControl.selectedSegmentIndex = 1
        emailTextField.isHidden = false
        usernameTextField.isHidden = true
        passwordTextField.isHidden = false
        confirmPassTextField.isHidden = true
        phoneTextField.isHidden = true
        storeIDTextField.isHidden = true
        zipTextField.isHidden = true
        
        messageLabel.text = "Sign in"
        toggleLabel.text = "New user?"
        toggleButton.setTitle("Sign Up", for: .normal)
    }
    
    func employeeSignUpMode() {
        userTypeSegmentedControl.selectedSegmentIndex = 1
        emailTextField.isHidden = false
        usernameTextField.isHidden = true
        passwordTextField.isHidden = false
        confirmPassTextField.isHidden = false
        phoneTextField.isHidden = true
        storeIDTextField.isHidden = false
        zipTextField.isHidden = true
        
        messageLabel.text = "Create an Account"
        toggleLabel.text = "Already have an account?"
        toggleButton.setTitle("Sign In", for: .normal)
    }
    
    func customerSignInMode() {
        userTypeSegmentedControl.selectedSegmentIndex = 0
        emailTextField.isHidden = false
        usernameTextField.isHidden = true
        passwordTextField.isHidden = false
        confirmPassTextField.isHidden = true
        phoneTextField.isHidden = true
        storeIDTextField.isHidden = true
        zipTextField.isHidden = true
        
        messageLabel.text = "Sign in"
        toggleLabel.text = "New user?"
        toggleButton.setTitle("Sign Up", for: .normal)
    }
    
    func customerSignUpMode() {
        userTypeSegmentedControl.selectedSegmentIndex = 0
        emailTextField.isHidden = false
        usernameTextField.isHidden = false
        passwordTextField.isHidden = false
        confirmPassTextField.isHidden = false
        phoneTextField.isHidden = false
        storeIDTextField.isHidden = true
        zipTextField.isHidden = false
        
        messageLabel.text = "Create an Account"
        toggleLabel.text = "Already have an account?"
        toggleButton.setTitle("Sign In", for: .normal)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if signUpMode {
            if userTypeSegmentedControl.selectedSegmentIndex == 0 {
                validateCustomerSignUp()
            }
            else {
                validateEmployeeSignUp()
            }
        }
        else {
            validateSignIn()
        }
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
    
    @objc func emailTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if !text.isValidEmail {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    floatingLabelTextField.errorMessage = nil
                    floatingLabelTextField.titleColor = confirmedGreenColor
                }
            }
        }
    }
    
    @objc func usernameTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                let trim = text.trimmingCharacters(in: .whitespacesAndNewlines)
                FBDatabaseService.shared.checkUniqueUsername(username: trim, onSuccess: {  (flag) ->
                    Void in
                    DispatchQueue.main.async {
                        if flag {
                            floatingLabelTextField.errorMessage = "Username taken, try again"
                            return
                        }
                    }
                })
                floatingLabelTextField.errorMessage = nil
                floatingLabelTextField.titleColor = confirmedGreenColor
            }
        }
    }
    
    @objc func passwordTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if text.count < 8 {
                    floatingLabelTextField.errorMessage = "8 characters minimum needed"
                }
                else {
                    floatingLabelTextField.errorMessage = nil
                    floatingLabelTextField.titleColor = confirmedGreenColor
                }
                
            }
        }
    }
    
    @objc func confirmPasswordTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if let passText = passwordTextField.text {
                    if text != passText {
                        floatingLabelTextField.errorMessage = "Passwords do not match"
                    }
                    else {
                        floatingLabelTextField.errorMessage = nil
                        floatingLabelTextField.titleColor = confirmedGreenColor
                    }
                }
                
            }
        }
    }
    
    @objc func phoneTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                do {
                    phoneNumberObj = try phoneNumberKit.parse(text)
                }
                catch {
                    print("Parser error")
                    floatingLabelTextField.errorMessage = "Invalid phone number"
                    return
                }
                floatingLabelTextField.errorMessage = nil
                floatingLabelTextField.titleColor = confirmedGreenColor
            }
            
        }
    }
    
    @objc func storeIDTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                let trim = text.trimmingCharacters(in: .whitespacesAndNewlines)
                FBDatabaseService.shared.checkUniqueUsername(username: trim, onSuccess: {  (flag) ->
                    Void in
                    DispatchQueue.main.async {
                        if flag {
                            floatingLabelTextField.errorMessage = "Username taken, try again"
                            return
                        }
                    }
                })
                floatingLabelTextField.errorMessage = nil
                floatingLabelTextField.titleColor = confirmedGreenColor
            }
        }
    }
    
    @objc func zipTextFieldDidChange (_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if !text.isValidZip {
                    floatingLabelTextField.errorMessage = "Invalid zipcode"
                }
                else {
                    floatingLabelTextField.errorMessage = nil
                    floatingLabelTextField.titleColor = confirmedGreenColor
                }
            }
        }
    }
    
    @IBAction func didSwitchUserType(_ sender: UISegmentedControl) {
        setMode()
    }
    
    func validateCustomerSignUp() {
        if emailTextField.errorMessage == nil && emailTextField.text?.count ?? 0 > 0 && usernameTextField.errorMessage == nil && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.errorMessage == nil && passwordTextField.text?.count ?? 0 > 0 && confirmPassTextField.errorMessage == nil && confirmPassTextField.text?.count ?? 0 > 0 && phoneTextField.errorMessage == nil && phoneTextField.text?.count ?? 0 > 0 && zipTextField.errorMessage == nil && zipTextField.text?.count ?? 0 > 0 {
            // enable submit button and return true
            submitButton.isEnabled = true
            submitButton.setTitleColor(.white, for: .normal)
        }
        else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    func validateSignIn()  {
        if emailTextField.errorMessage == nil && emailTextField.text?.count ?? 0 > 0 && passwordTextField.errorMessage == nil && passwordTextField.text?.count ?? 0 > 0{
            submitButton.isEnabled = true
            submitButton.setTitleColor(.white, for: .normal)
        }
        else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    func validateEmployeeSignUp()  {
        if emailTextField.errorMessage == nil && emailTextField.text?.count ?? 0 > 0 && passwordTextField.errorMessage == nil && passwordTextField.text?.count ?? 0 > 0 && confirmPassTextField.errorMessage == nil && confirmPassTextField.text?.count ?? 0 > 0 && storeIDTextField.errorMessage == nil && storeIDTextField.text?.count ?? 0 > 0  {
            // enable submit button and return true
            submitButton.isEnabled = true
            submitButton.setTitleColor(.white, for: .normal)
        }
        else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    // handle all segues
    @IBAction func didPressSubmit(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}

        if userTypeSegmentedControl.selectedSegmentIndex == 0 {
            if signUpMode {
                guard let username = usernameTextField.text else {return}
                guard let phoneNumber = phoneNumberObj else {return}
                guard let zipcode = zipTextField.text else {return}
                let formattedPhoneNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
                FBAuthService.shared.signUpInitial(email: email, username: username, password: password, phoneNum: formattedPhoneNumber, zip: Int(zipcode) ?? 0, onSuccess: { (verificationID) in
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    }
                })
                self.performSegue(withIdentifier: "Verify", sender: self)
            }
            else {
                FBAuthService.shared.signInCustomer(withEmail: email, password: password) { (success) in
                    DispatchQueue.main.async {
                        if success {
                            let homeNavigationController = self.storyboard?.instantiateViewController(identifier: "homeNavigationController")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            self.view.window?.rootViewController = homeNavigationController
                        }
                        else {
                            // alert that the email and password were incorrect
                            let alert = UIAlertController(title: "Sign In Error", message: "Incorrect username and/or password", preferredStyle: .alert)
                             alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (nil) in
                                    self.clearSignInFields()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        else {
            if signUpMode {
                guard let storeID = storeIDTextField.text else {return}
                FBAuthService.shared.signUpEmployee(email: email, password: password, storeID: storeID) { (success) in
                    let employeeHomeViewController = self.storyboard?.instantiateViewController(identifier: "employeeHomeViewController")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.view.window?.rootViewController = employeeHomeViewController
                }
            }
            else {
                FBAuthService.shared.signInEmployee(withEmail: email, password: password) { (success) in
                    DispatchQueue.main.async {
                        if success {
                            let employeeHomeViewController = self.storyboard?.instantiateViewController(identifier: "employeeHomeViewController")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            self.view.window?.rootViewController = employeeHomeViewController
                        }
                        else {
                            // alert that the email and password were incorrect
                            let alert = UIAlertController(title: "Sign In Error", message: "Incorrect username and/or password", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (nil) in
                                self.clearSignInFields()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func clearSignInFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        submitButton.isEnabled = false
        submitButton.setTitleColor(.gray, for: .normal)
    }
    
    @IBAction func didPressToggle(_ sender: UIButton) {
        // if we're in customer mode
        if userTypeSegmentedControl.selectedSegmentIndex == 0 {
            if signUpMode {
                customerSignInMode()
            }
            else {
                customerSignUpMode()
            }
        }
        else {
            if signUpMode {
                employeeSignInMode()
            }
            else {
                employeeSignUpMode()
            }
        }
        signUpMode = !signUpMode
    }
    
    func setMode() {
        if userTypeSegmentedControl.selectedSegmentIndex == 0 {
            if signUpMode {
                customerSignUpMode()
            }
            else {
                customerSignInMode()
            }
        }
        else {
            if signUpMode {
                employeeSignUpMode()
            }
            else {
                employeeSignInMode()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
