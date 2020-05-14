//
//  UnselectedTableViewCell.swift
//  LineSaver
//
//  Created by Cat  on 4/22/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class UnselectedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var companyLogoIV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var initialLabel: UILabel!
    
    var store:Store?
    
    
    func update(store: Store) {
        self.store = store
        nameLabel?.text = store.name
        if let wait = store.currentWaitTime {
            waitTimeLabel.text = "Current Wait: \(wait) min"
        } else {waitTimeLabel.text = "No data" }
        distanceLabel?.text = String(format: "%.2f mi", store.distanceFromCurrentUser)
        initialLabel?.text = String(store.name.prefix(1))
        imageView?.backgroundColor = .random()
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
