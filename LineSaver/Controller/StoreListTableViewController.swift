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
    var browseStoreViewController: BrowseStoreViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        storesModel.getStores(onSuccess: {  (stores: [Store]) ->
            Void in
            DispatchQueue.main.async {
                let sortedStores = stores.sorted(by: Store.storeSorter)
                self.storesModel.setStores(stores: sortedStores)
                //self.storesModel.updateZips()
                self.tableView.reloadData()
            }
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let browseStoreViewController = browseStoreViewController {
            if browseStoreViewController.searching {
                return browseStoreViewController.searchStore.count
            }
        }
        return storesModel.getNumStores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add code to refresh the table when the tab is pressed
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var store: Store!
        if let browseStoreViewController = browseStoreViewController {
            if browseStoreViewController.searching {
                store = browseStoreViewController.searchStore[indexPath.row]
            }
            else {
                guard let potentialStore = storesModel.store(at: indexPath.row) else {return UITableViewCell()}
                store = potentialStore
            }
        }
        else
        {
            guard let potentialStore = storesModel.store(at: indexPath.row) else {return UITableViewCell()}
            store = potentialStore
        }
        // if reloading selected cell to expand
        if selectedIndexPath == indexPath.row {
            if store.queuingEnabled {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedQueuing", for: indexPath) as!
                    SelectedPartnerStoreTableViewCell
                cell.update(store: store)
                return cell
            }
            else {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedNonQueuing", for: indexPath) as! SelectedNonPartnerTableViewCell
                cell.update(store: store)
                return cell
            }
        }
        else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Unselected", for: indexPath) as! UnselectedTableViewCell
                cell.update(store: store)
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // if we have a currently selected row
        if let selectedIndexPath = selectedIndexPath {
            // this means we're "deselecting the selected row"
            if selectedIndexPath == indexPath.row {
                self.selectedIndexPath = nil
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            // we're selecting a new row but need to reload the previously selected row & the newly selected row
            else {
                let previousRow = selectedIndexPath
                self.selectedIndexPath = indexPath.row
                tableView.reloadRows(at: [IndexPath(row: previousRow, section: 0), indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
        // selecting a row for the first time
        else {
            self.selectedIndexPath = indexPath.row
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath = nil
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPath == indexPath.row {
            return 220
        }
        else {
            return 90
        }
    }

    
    // Notification.default.host 
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
