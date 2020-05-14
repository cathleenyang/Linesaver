//
//  BrowseStoreViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/22/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class BrowseStoreViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var storeSearchBar: UISearchBar!
    
    @IBOutlet weak var storeListContainerView: UIView!
    var searching = false
    var searchStore = [Store]()
    var child: StoreListTableViewController?

    // outlet for container view 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        child = children.first as? StoreListTableViewController
        child?.browseStoreViewController = self
        storeSearchBar.delegate = self
        // Do any additional setup after loading the view.

        
        
    }
    @IBAction func shouldDismissKeyboard(_ sender: Any) {
        self.storeSearchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.storeSearchBar.endEditing(true)
    }
    
    // Swift Singleton pattern
    //static let shared = BrowseStoreViewController()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStore = StoresModel.shared.stores.filter({$0.name.prefix(searchText.count) == searchText})
        searching = true
        child?.tableView.reloadData()
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
