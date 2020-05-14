//
//  ScheduleReservationTableViewCell.swift
//  LineSaver
//
//  Created by Cat  on 5/6/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class ScheduleReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var reservationDetailsLabel: UILabel!
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

    func update(reservation: Reservation) {
        self.reservation = reservation
        let store = reservation.store
        storeNameLabel.text =  store.name
        storeAddressLabel.text = store.address
        distanceLabel.text = String(format: "%.2f mi", store.distanceFromCurrentUser)
        // display a 15 minute buffer time
        guard let displayTime = reservation.dateAndTime else {return}
        let displayTimeString = DateService.shared.getReadableStringFromDate(date: displayTime)
        reservationDetailsLabel.text = displayTimeString
        notificationLabel.text = String("You'll be notified \(reservation.notificationTime) min before")
        
    }
}
