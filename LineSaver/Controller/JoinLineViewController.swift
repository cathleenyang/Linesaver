//
//  JoinLineViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/29/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
class JoinLineViewController: UIViewController{

    

    @IBOutlet weak var squareLineView: UIView! {
        didSet {
            squareLineView.layer.cornerRadius = squareLineView.bounds.width/2.0
            squareLineView.layer.masksToBounds = true
            squareLineView.dropShadow()
        }
    }
    
    @IBOutlet weak var squareWaitTimeView: UIView!  {
        didSet {
            squareWaitTimeView.layer.cornerRadius = squareWaitTimeView.bounds.width/2.0
            squareWaitTimeView.layer.masksToBounds = true
            squareWaitTimeView.dropShadow()
        }
    }
    @IBOutlet weak var notificationTimePicker: UIDatePicker! 
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
