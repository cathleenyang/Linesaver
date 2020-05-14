//
//  ProfileTableViewController.swift
//  
//
//  Created by Cat  on 5/6/20.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    let reservationsModel = ReservationsModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        reservationsModel.getReservations { (reservations) in
            DispatchQueue.main.async {
                // sort reservations by soonest ending?
                self.reservationsModel.setReservations(reservations: reservations)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reservationsModel.getNumReservations()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let reservation = reservationsModel.reservation(at: indexPath.row) else {return UITableViewCell()}

        if reservation.active {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveReservation", for: indexPath) as! ActiveReservationTableViewCell 
            cell.update(reservation: reservation)
            return cell
        }
        else {
            if reservation.type == "schedule" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleReservation", for: indexPath) as! ScheduleReservationTableViewCell
                cell.update(reservation: reservation)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LineReservation", for: indexPath) as! LineReservationTableViewCell
                cell.update(reservation: reservation)
                return cell
            }
        }
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
