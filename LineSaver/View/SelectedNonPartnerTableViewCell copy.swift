//
//  SelectedNonPartnerTableViewCell.swift
//  
//
//  Created by Cat  on 4/22/20.
//

import UIKit

class SelectedNonPartnerTableViewCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var store:Store?
   
    @IBAction func reportWaitTimeWasSelected(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("joinVirtualLineSelected"), object: nil, userInfo: ["store" : store ?? Store()])
    }
    
    func update(store:Store) {
        self.store = store
        storeNameLabel.text = store.name
        addressLabel.text = store.address
        distanceLabel.text = String(format: "%.2f mi", store.distanceFromCurrentUser)
        if let wait = store.currentWaitTime {
            let min = wait-5
            let max = wait+5
            waitTimeLabel.text = ("\(min)-\(max) min")
        }
        else {
            waitTimeLabel.text = "No Data"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
