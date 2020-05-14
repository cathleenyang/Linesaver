//
//  ReportWaitTimeViewController.swift
//  LineSaver
//
//  Created by Cat  on 5/6/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class ReportWaitTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        // Do any additional setup after loading the view.
        pickerData = ["Very Short: < 5 Minutes", "Short: 5-10 Minutes", "Medium: 10-20 Minutes", "High: 20-40 Minutes", "Very High: > 60 Minutes"]
        
    }
    
    @IBAction func didPressSubmit(_ sender: Any) {
        let alert = UIAlertController(title: "Thank You", message: "Thank you for helping shoppers with up to date info", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (nil) in
                // write to database the updated wait time 
        }))
        
        FBAuthService.shared.currentLSStore.lastUpdate = 0
        refreshLabel()
        self.present(alert, animated: true, completion: nil)
    }
    
    func refreshLabel() {
        
        lastUpdatedLabel.text = "LAST UPDATED \(FBAuthService.shared.currentLSStore.lastUpdate) MINUTES AGO"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
