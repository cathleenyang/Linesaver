//
//  SelectedPartnerStoreTableViewCell.swift
//  
//
//  Created by Cat  on 4/22/20.
//

import UIKit

class SelectedPartnerStoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var joinQueueButton: RoundedButton!
    @IBOutlet weak var makeReservationButton: RoundedButton!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var placeInLineLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var store:Store?
    
    @IBAction func didSelectJoinLine(_ sender: RoundedButton) {
        NotificationCenter.default.post(name: Notification.Name("joinVirtualLineSelected"), object: nil, userInfo: ["store" : store])
    }
    
    
    @IBAction func didSelectMakeReservation(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("makeReservationSelected"), object: nil, userInfo: ["store": store])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(store:Store) {
        //update the iboutlets
        self.store = store
        storeNameLabel.text = store.name
        let line = store.queue
        if line.isEmpty {
            placeInLineLabel.text = "No wait!"
        }
        else {
            placeInLineLabel.text = String("\(store.queue.count) Shoppers Ahead")
        }
        addressLabel.text = store.address
        if let wait = store.currentWaitTime {
            let min = wait-5
            let max = wait+5
            waitTimeLabel.text = ("\(min)-\(max) min")
        }
        else {
            waitTimeLabel.text = "No Data"
        }
        distanceLabel.text = String(format: "%.2f mi", store.distanceFromCurrentUser)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
