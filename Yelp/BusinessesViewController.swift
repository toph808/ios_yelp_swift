//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var businessSearchBar: UISearchBar!
    
    var isSearching: Bool = false
    var searchedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        businessSearchBar.delegate = self
        businessSearchBar.placeholder = "Search"
        
        performSearch("")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchText
        performSearch(searchedText)
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        endSearch()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        endSearch()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        endSearch()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        endSearch()
    }
    
    func endSearch() {
        businessSearchBar.endEditing(true)
        businessSearchBar.resignFirstResponder()
    }
    
    func performSearch(searchTerm: String) {
        Business.searchWithTerm(searchTerm, sort: .Distance, categories: [], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]) {
        var categories = filters["categories"] as? [String]
        var deals = filters["is_offering_deal_selected"] as? Bool
        var radius = filters["distance"] as? Double
        var sortMethod = filters["sort_method_index"] as? Int ?? 0
        var sortMode = YelpSortMode(rawValue: sortMethod)
        
        Business.searchWithTerm("Restaurants", sort: sortMode, categories: categories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

}
