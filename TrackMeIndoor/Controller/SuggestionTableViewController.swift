//
//  SuggestionTableViewController.swift
//  TrackMeIndoor
//
//  Created by Wing yan Tsui on 23/12/2017.
//  Copyright © 2017 Team 22. All rights reserved.
//

import UIKit

class SuggestionTableViewController: UITableViewController {
    
    

    
    var stores = [Store]()
    var filteredStores = [Store]()
    var selectedStore = [Store]()
    
    let searchController = UISearchController(searchResultsController: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadStore()
        filteredStores = stores
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = Constants.filterType
        searchController.searchBar.delegate = self
        
    }
    
    private func loadStore() {
        
        for i in 0..<Constants.storesDB.count{
            if Constants.storesDB[i][4] == "0" {
                continue
            }
            let store = Store(name: Constants.storesDB[i][1], image: Constants.storeTypeImage[Constants.filterType.index(of: Constants.storesDB[i][2])!], nodeID: Int(Constants.storesDB[i][0])!, coordinates: Coordinates(Double(SearchPath.coordinates[i][0]), Double(SearchPath.coordinates[i][1])), distance: 0, category: Constants.storesDB[i][2], floor: Int(Constants.storesDB[i][3])!)
            stores.append(store!)
        }
        
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
       
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStores = stores.filter({( store : Store) -> Bool in
            let doesCategoryMatch = (scope == "All") || (store.category == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && store.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isFiltering() {
            return filteredStores.count
        }
        
        return stores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "SuggestionTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SuggestionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SuggestionTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        var store = stores[indexPath.row]
        
        if isFiltering() {
            store = filteredStores[indexPath.row]
        } else {
            store = stores[indexPath.row]
        }
        
        cell.storeName.text = store.name
        cell.storeImage.image = store.image
       cell.storeDetails.text = store.category
        
        return cell
        


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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is StoreDetailsViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let vc = segue.destination as? StoreDetailsViewController
                //let value = values[.row]
                print (stores[indexPath.row].name)
                vc?.store = stores[indexPath.row]
            //    vc?.storeDetailsTextView.text = stores[indexPath.row].category
            }
    }
    }
    
    
}

extension SuggestionTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}


extension SuggestionTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

