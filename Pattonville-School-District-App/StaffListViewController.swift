//
//  StaffListViewController.swift
//  Pattonville-School-District-App
//
//  Created by D3vel0per on 12/15/16.
//  Copyright © 2016 Joshua Zahner. All rights reserved.
//

import UIKit

class StaffListViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {

    var staffList = StaffArray.init().staffList
    var filteredStaffList = [StaffMember]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    
    
    var searchText: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        
        searchController.searchBar.sizeToFit()
        
        searchText = searchController.searchBar.text?.lowercased()
        
        searchController.searchBar.showsCancelButton = true
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStaffList.count
        } else {
            return staffList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ssdTableViewCell", for: indexPath) as! SSDTableViewCell

        let staffMember: StaffMember
        
        if searchController.isActive && searchController.searchBar.text != ""{
            staffMember = filteredStaffList[indexPath.row]
            cell.nameLabel.text = staffMember.firstName + " " + staffMember.lastName
            
            cell.departmentLabel.text = staffMember.department
            
            cell.extensionLabel.text = "x" + staffMember.ext
            
            cell.emailButton.tag = indexPath.row
        } else {
            staffMember = staffList[indexPath.row]
            cell.nameLabel.text = staffMember.firstName + " " + staffMember.lastName
            
            cell.departmentLabel.text = staffMember.department
            
            cell.extensionLabel.text = "x" + staffMember.ext
            
            cell.emailButton.tag = indexPath.row
        }
        
            
            //add code to make email button do stuff
        
        return cell
        
        
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredStaffList.removeAll()
        filteredStaffList = staffList.filter{ staffMember in
            return staffMember.firstName.lowercased().contains(self.searchText) || staffMember.lastName.lowercased().contains(searchText.lowercased()) || staffMember.department.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    @IBAction func emailAction(sender: UIButton) {
        _ = staffList[sender.tag].email
    }

}
