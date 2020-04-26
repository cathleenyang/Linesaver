//
//  StoreListTableViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/22/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor( red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}

class StoreListTableViewController: UITableViewController{
    
    let storesModel = StoresModel.shared
    var selectedIndexPath:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        storesModel.getStores(onSuccess: {  (stores: [Store]) ->
            Void in
            DispatchQueue.main.async {
                //let sortedStores = stores.sorted(by: Store.storeSorter)
                self.storesModel.setStores(stores: stores)
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesModel.getNumStores()
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if let store = storesModel.store(at: indexPath.row) {
            if selectedIndexPath == indexPath.row {
                if store.isQueingEnabled() {
                     cell = tableView.dequeueReusableCell(withIdentifier: "SelectedQueuing", for: indexPath) as! UnselectedTableViewCell
                    return cell
                }
                else {
                     cell = tableView.dequeueReusableCell(withIdentifier: "SelectedNonQueuing", for: indexPath) as! UnselectedTableViewCell
                    return cell
                }
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Unselected", for: indexPath) as! UnselectedTableViewCell

                if let store = storesModel.store(at: indexPath.row) {
                    cell.nameLabel?.text = store.getName()
                    if let wait = store.getWait() {
                        cell.waitTimeLabel.text = "Current Wait: \(wait) min"
                    } else {cell.waitTimeLabel.text = "No data" }
                    cell.distanceLabel?.text = String(format: "%.2f mi", store.getDistance())
                    cell.initialLabel?.text = String(store.getName().prefix(1))
                    cell.imageView?.backgroundColor = .random()
                }
                return cell
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
