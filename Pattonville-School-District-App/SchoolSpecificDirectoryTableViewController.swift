//
//  SchoolSpecificDirectoryTableViewController.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 12/12/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class SchoolSpecificDirectoryTableViewController: UITableViewController, UISearchBarDelegate {
    
    var staffList = StaffArray.init().staffList
    let searchController = UISearchController(searchResultsController: nil)
    var filteredStaffMembers = [StaffMember]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStaffMembers.count
        } else {
            return staffList.count
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        //let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        let staffMember: StaffMember
        
        if searchController.isActive && searchController.searchBar.text != "" {
            staffMember = filteredStaffMembers[indexPath.row]
        } else {
            staffMember = staffList[indexPath.row]
        }
        
        cell.textLabel?.text = staffMember.firstName + " " + staffMember.lastName
        cell.detailTextLabel?.text = staffMember.department
        
        return cell
        
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredStaffMembers = staffList.filter { staffMember in
            return staffMember.firstName.lowercased().contains(searchText.lowercased()) || staffMember.lastName.lowercased().contains(searchText.lowercased()) ||   staffMember.department.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
    }
    
}

extension SchoolSpecificDirectoryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
