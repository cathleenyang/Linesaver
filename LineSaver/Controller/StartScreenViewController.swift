//
//  StartScreenViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/15/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit
import FirebaseAuth
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
    var withoutSpaceCharacters: String {
        let spaceLess = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined(separator: "")
        return spaceLess
    }
}


class StartScreenViewController: UIViewController, UITextFieldDelegate {
    
    let phoneNumberKit = PhoneNumberKit()
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var emailTF: BottomBorderTextField!{
        didSet {
            if let icon = UIImage(named: "icon-user") {
                emailTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var passwordTF: BottomBorderTextField!{
        didSet {
            if let icon = UIImage(named: "icon-lock") {
                passwordTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var confirmPassTF: BottomBorderTextField!{
        didSet {
            if let icon = UIImage(named: "icon-lock") {
                confirmPassTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var phoneTF: PhoneNumberTextField!{
        didSet {
            if let icon = UIImage(named: "icon-phone") {
                phoneTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var zipTF: BottomBorderTextField!{
        didSet {
            if let icon = UIImage(named: "icon-location") {
                zipTF.setIcon(icon)
            }
        }
    }
    @IBOutlet weak var submitButton: RoundedButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var flipButton: UIButton!
    
    var activeField: UITextField?
    var signUpView: Bool = true
    var submitEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toggleSubmitButton()
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.confirmPassTF.delegate = self
        self.phoneTF.delegate = self
        self.zipTF.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    func toggleSubmitButton() {
        //check all the text fields and make sure they're not empty
        guard let email = emailTF.text else {return}
        guard let password = passwordTF.text else {return}
        if signUpView {
            guard let confirm = confirmPassTF.text else {return}
            guard let phone = phoneTF.text else {return}
            guard let zip = zipTF.text else {return}
            if email.withoutSpaceCharacters.count > 0 && password.withoutSpaceCharacters.count > 0 && confirm.withoutSpaceCharacters.count > 0 && phone.withoutSpaceCharacters.count > 0 && zip.withoutSpaceCharacters.count > 0 && email.isValidEmail && zip.isValidZip{
                submitEnabled = true
                submitButton.isEnabled = true
                submitButton.setTitleColor(.white, for: .normal)
                return
            }
        }
        else {
            if email.withoutSpaceCharacters.count > 0 && password.withoutSpaceCharacters.count > 0 && email.isValidEmail{
                submitEnabled = true
                submitButton.isEnabled = true
                submitButton.setTitleColor(.white, for: .normal)
                return
            }
        }
        submitButton.isEnabled = false
        submitButton.setTitleColor(.gray, for: .normal)
    }
    
    // Delegate protocol functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        toggleSubmitButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let activeField = self.activeField {
            activeField.resignFirstResponder()
            self.activeField = nil
            toggleSubmitButton()
            return true
        }
        return false
    }
    
    // Toggle between SignUp and SignIn screen
    @IBAction func switchCurrentView(_ sender: UIButton) {
        if signUpView {
            let fadeOutAnimation = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
                self.accountLabel.alpha = 0.0
                self.confirmPassTF.alpha = 0.0
                self.phoneTF.alpha = 0.0
                self.zipTF.alpha = 0.0
                self.submitButton.titleLabel?.alpha=0.0
                self.questionLabel.alpha = 0.0
                self.flipButton.titleLabel?.alpha = 0.0
            }
            fadeOutAnimation.addCompletion { (position) in
                let fadeInAnimation = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
                    self.accountLabel.text = "Log in to your Account"
                    self.submitButton.setTitle("SIGN IN", for: .normal)
                    self.questionLabel.text = "New user?"
                    self.flipButton.setTitle("Sign Up", for: .normal)
                    self.accountLabel.alpha = 1.0
                    self.submitButton.titleLabel?.alpha=1.0
                    self.questionLabel.alpha = 1.0
                    self.flipButton.titleLabel?.alpha = 1.0
                }
                fadeInAnimation.startAnimation()
            }
            fadeOutAnimation.startAnimation()
        }
        else {
            let fadeOutAnimation2 = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
                self.accountLabel.alpha = 0.0
                self.submitButton.titleLabel?.alpha=0.0
                self.questionLabel.alpha = 0.0
                self.flipButton.titleLabel?.alpha = 0.0
            }
            fadeOutAnimation2.addCompletion { (position) in
                let fadeInAnimation2 = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
                    self.accountLabel.text = "Create Account"
                    self.submitButton.setTitle("SIGN UP", for: .normal)
                    self.questionLabel.text = "Returning user?"
                    self.flipButton.setTitle("Sign In", for: .normal)
                    self.confirmPassTF.alpha = 1.0
                    self.phoneTF.alpha = 1.0
                    self.zipTF.alpha = 1.0
                    self.accountLabel.alpha = 1.0
                    self.submitButton.titleLabel?.alpha=1.0
                    self.questionLabel.alpha = 1.0
                    self.flipButton.titleLabel?.alpha = 1.0
                }
                fadeInAnimation2.startAnimation()
            }
            fadeOutAnimation2.startAnimation()
            
        }
        signUpView = !signUpView
    }
    
    @IBAction func didPressSubmit(_ sender: RoundedButton) {
        guard let email = emailTF.text, !email.isEmpty else {return}
        guard let password = passwordTF.text, !password.isEmpty else {return}
        guard let zip = zipTF.text, !zip.isEmpty else {return}
        if signUpView {
            // create account through firebase
            let phone = "+16505557777"
            
            FBAuthService.shared.signUpInitial(email: email, password: password, phoneNum: phone, zip: Int(zip) ?? 0, onSuccess: { (verificationID) in DispatchQueue.main.async {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                }
            })
            self.performSegue(withIdentifier: "Verify", sender: self)
        }
        else {
            FBAuthService.shared.signIn(withEmail: email, password: password) { (success) in
                if success {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BrowseViewControllerID")
//                    self.present(nextViewController, animated: true, completion: nil)
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else {
                    
                }
            }
        }
    }

    // Segue, only when in SignUp mode
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


