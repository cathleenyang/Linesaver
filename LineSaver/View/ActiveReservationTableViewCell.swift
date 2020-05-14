//
//  ActiveReservationTableViewCell.swift
//  LineSaver
//
//  Created by Cat  on 5/6/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class ActiveReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var storeIconImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var timeExpirationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var reservation:Reservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func cancelWasSelected(_ sender: UIButton) {
    }
    
    @IBAction func checkInWasSelected(_ sender: UIButton) {
         NotificationCenter.default.post(name: Notification.Name("checkInSelected"), object: nil)
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
        guard let timeWithBuffer = reservation.dateAndTime?.addingTimeInterval(15*60) else {return}
        let timeWithBufferString = DateService.shared.getReadableStringFromDate(date: timeWithBuffer)
        timeExpirationLabel.text = String("You can check in until \(timeWithBufferString)")
    }

}
