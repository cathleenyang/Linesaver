//
//  LineReservationTableViewCell.swift
//  
//
//  Created by Cat  on 5/6/20.
//

import UIKit

class LineReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var linePositionLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var reservation:Reservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func cancelWasSelected(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(reservation:Reservation) {
        self.reservation = reservation
        let store = reservation.store
        storeNameLabel.text =  store.name
        storeAddressLabel.text = store.address
        distanceLabel.text = String(format: "%.2f mi", store.distanceFromCurrentUser)
        guard let position = reservation.placeInLine else {return}
        guard let waitTime = reservation.currentWaitTime else {return}
        linePositionLabel.text = String(position)
        waitTimeLabel.text = String(waitTime * position)
        notificationLabel.text = String("You'll be notified \(reservation.notificationTime) min before")
        
    }
}
