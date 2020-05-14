//
//  HomeNavigationViewController.swift
//  LineSaver
//
//  Created by Cat  on 5/5/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class HomeNavigationViewController: UIViewController {
    
    var store:Store!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(displayReportWaitTimeView(notification:)), name: NSNotification.Name(rawValue: "reportWaitTimeSelected"), object: nil)
        
    }
    
    @objc func displayReportWaitTimeView(notification: NSNotification) {
        if let store = notification.userInfo?["store"] as? Store {
            self.store = store
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }


}
