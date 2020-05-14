//
//  StartScreenViewController.swift
//  LineSaver
//
//  Created by Cat  on 5/4/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var isCustomer:Bool = true
    

    @IBAction func didSelectCustomer(_ sender: UIButton) {
        isCustomer = true
        self.performSegue(withIdentifier: "SignInSignUp", sender: self)
        
    }
    
    @IBAction func didSelectEmployee(_ sender: UIButton) {
        isCustomer = false
        self.performSegue(withIdentifier: "SignInSignUp", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signInSignUpViewController = segue.destination  as? SignInSignUpViewController {
            if isCustomer {
                signInSignUpViewController.segmentedControlIndex = 0
                signInSignUpViewController.signUpMode = true
            }
            else {
                signInSignUpViewController.segmentedControlIndex = 1
                signInSignUpViewController.signUpMode = true
            }
        }
    }


}
