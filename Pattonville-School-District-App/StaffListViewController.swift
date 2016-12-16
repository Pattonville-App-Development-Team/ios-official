//
//  StaffListViewController.swift
//  Pattonville-School-District-App
//
//  Created by D3vel0per on 12/15/16.
//  Copyright © 2016 Joshua Zahner. All rights reserved.
//

import UIKit

class StaffListViewController: UITableViewController, UISearchResultsUpdating {

    var staffList = StaffArray.init().staffList
    var filteredStaffList = [StaffMember]()
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
      searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "staffMemberCell", for: indexPath) as! SSDTableViewCell

        let staffMember: StaffMember
        
        if searchController.isActive && searchController.searchBar.text != ""{
            staffMember = filteredStaffList[indexPath.row]
        } else {
            staffMember = staffList[indexPath.row]
        }
        
            cell.nameLabel.text = staffMember.firstName + " " + staffMember.lastName
            
            cell.departmentLabel.text = staffMember.department
            
            cell.extLabel.text = "x" + staffMember.ext
            
            cell.emailButton.tag = indexPath.row
            
            //add code to make email button do stuff
        
        return cell
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredStaffList = staffList.filter{ staffMember in
            return staffMember.firstName.lowercased().contains(searchText.lowercased()) || staffMember.lastName.lowercased().contains(searchText.lowercased()) || staffMember.department.lowercased().contains(searchText.lowercased())
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
        tableView.reloadData()
        
        
        
    }
    
    @IBAction func emailAction(sender: UIButton) {
        _ = staffList[sender.tag].email
    }

}
