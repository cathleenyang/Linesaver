//
//  ReservationMasterViewController.swift
//  LineSaver
//
//  Created by Cat  on 5/5/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class ReservationMasterViewController: UIViewController {

    @IBOutlet weak var switchSceneSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var lineContainerView: UIView!
    var segmentedControlIndex:Int = 0
    var store:Store!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = store.name
        addressLabel.text = store.address
        switchSceneSegmentedControl.selectedSegmentIndex = segmentedControlIndex
        updateView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sceneSwitchWasSelected(_ sender: UISegmentedControl) {
        updateView()
    }
    private func setUpView() {
        switchSceneSegmentedControl.selectedSegmentIndex = 0;
        updateView()
    }
    
    
    func updateView() {
        if switchSceneSegmentedControl.selectedSegmentIndex == 0 {
            lineContainerView.isHidden = false
            calendarContainerView.isHidden = true
        }
        else {
            lineContainerView.isHidden = true
            calendarContainerView.isHidden = false
        }
    }

    @IBAction func signOutWasPressed(_ sender: UIBarButtonItem) {
        let result = FBAuthService.shared.signOut()
        let startScreenViewController = self.storyboard?.instantiateViewController(identifier: "startScreenViewController")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        self.view.window?.rootViewController = startScreenViewController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
