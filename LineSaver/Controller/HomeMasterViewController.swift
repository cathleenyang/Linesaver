//
//  HomeMasterViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/28/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class HomeMasterViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var sceneSelectorSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var browseContainerView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    
    var store:Store!
    var selectedIndex:Int = 0
    
    let backImage = UIImage(systemName: "arrow.left")
    
    
    override func viewDidLoad() {
        setUpView()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayVirtualLineScreen(notification:)), name: NSNotification.Name(rawValue: "joinVirtualLineSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayCalendarReservationScreen(notification:)), name: NSNotification.Name(rawValue: "makeReservationSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRScreen(notification:)), name: NSNotification.Name(rawValue: "checkInSelected"), object: nil)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back To Browse", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        guard let dateObj = DateService.shared.getDateFromDateComponents(year: 2020, month: 5, day: 6, hour: 3, minute: 0) else {return}
        let timestamp = DateService.shared.getFirebaseStringFromDate(date: dateObj)
        guard let translatedDateObj = DateService.shared.getDateFromUnixTimestamp(date: Double(timestamp) ?? 0 ) else {return}
        let readableString = DateService.shared.getReadableStringFromDate(date: translatedDateObj)
        print(readableString)
    }
    
    
    
    @objc func displayVirtualLineScreen(notification: NSNotification) {
        if let store = notification.userInfo?["store"] as? Store {
            self.store = store
            selectedIndex = 0
            self.performSegue(withIdentifier: "Reservation", sender: self)
        }
    }
    
    @objc func displayQRScreen(notification: NSNotification) {
        self.performSegue(withIdentifier: "CheckMeIn", sender: self)
    }
    
    @objc func displayCalendarReservationScreen(notification: NSNotification) {
        if let store = notification.userInfo?["store"] as? Store {
            self.store = store
            selectedIndex = 1
            self.performSegue(withIdentifier: "Reservation", sender: self)
        }
    }
    
    private func setUpView() {
        sceneSelectorSegmentedControl.selectedSegmentIndex = 0;
        sceneSelectorSegmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        updateView()
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    func updateView() {
        if sceneSelectorSegmentedControl.selectedSegmentIndex == 0 {
            browseContainerView.isHidden = false
            profileContainerView.isHidden = true
        }
        else {
            browseContainerView.isHidden = true
            profileContainerView.isHidden = false
        }
    }
    
    
    @IBAction func didPressSignOut(_ sender: Any) {
        let result = FBAuthService.shared.signOut()
        let startScreenViewController = self.storyboard?.instantiateViewController(identifier: "startScreenViewController")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        self.view.window?.rootViewController = startScreenViewController
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = (segue.destination as? ReservationMasterViewController) {
            if let id = segue.identifier {
                if id == "Reservation" {
                    viewController.store = self.store
                    viewController.segmentedControlIndex = self.selectedIndex
                }
            }
        }
    }
    
}
