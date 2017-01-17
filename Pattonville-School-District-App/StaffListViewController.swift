//
//  StaffListViewController.swift
//  Pattonville-School-District-App
//
//  Created by D3vel0per on 12/15/16.
//  Copyright © 2016 Joshua Zahner. All rights reserved.
//

import UIKit
import MessageUI

class StaffListViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, MFMailComposeViewControllerDelegate {

    var staffList = phsStaffArray.init().phsStaffList
    var filteredStaffList = [StaffMember]()
    var searchText: String!
    let searchController = UISearchController(searchResultsController: nil)
    var staffMember: StaffMember!
    
    @IBAction func sendEmailButton(_ sender: UIButton) {
        self.staffMember = staffList[sender.tag]
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
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
        
        if searchController.isActive && searchController.searchBar.text != "" {
            staffMember = filteredStaffList[indexPath.row]
        } else {
            staffMember = staffList[indexPath.row]
        }
        
        cell.nameLabel.text = staffMember.firstName + " " + staffMember.lastName
        cell.departmentLabel.text = staffMember.department
        cell.extensionLabel.text = "x" + staffMember.ext
        cell.emailButton.tag = indexPath.row
        
        return cell
    
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredStaffList = staffList.filter{ staffMember in
            return staffMember.firstName.appending(" ").appending(staffMember.lastName).lowercased().contains(searchText.lowercased()) || staffMember.lastName.appending(" ").lowercased().contains(searchText.lowercased()) || staffMember.department.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([self.staffMember.email])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
