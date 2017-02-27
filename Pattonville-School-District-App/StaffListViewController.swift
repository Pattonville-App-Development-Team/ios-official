//
//  StaffListViewController.swift
//  Pattonville-School-District-App
//
//  Created by D3vel0per on 12/15/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import MessageUI

class StaffListViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, MFMailComposeViewControllerDelegate {

    var directory = Directory()
    var directoryDictionary = Directory.directoryDictionary
    var staffList: [StaffMember] = []
    var indexOfSchool: Int!
    var filteredStaffList = [StaffMember]()
    var searchText: String!
    let searchController = UISearchController(searchResultsController: nil)
    var staffMember: StaffMember!
    
    @IBAction func sendEmailButton(_ sender: UIButton) {
        if filteredStaffList.count > 0 {
            self.staffMember = filteredStaffList[sender.tag]
        } else {
            self.staffMember = staffList[sender.tag]
        }
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indexOfSchool = SSDViewController.staticSchoolIndex
        
        let currentSchool = SchoolsArray.allSchools[indexOfSchool!]
        
        let currentSchoolShortName = currentSchool.shortName
        
        print("Current Staff List: " + String(describing: directoryDictionary[currentSchoolShortName]))
        
        staffList = directoryDictionary[currentSchoolShortName]!
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolSpecificDirectoryTableViewCell", for: indexPath) as! SchoolSpecificDirectoryTableViewCell

        let staffMember: StaffMember
        
        if searchController.isActive && searchController.searchBar.text != "" {
            staffMember = filteredStaffList[indexPath.row]
        } else {
            staffMember = staffList[indexPath.row]
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.nameLabel.text = (staffMember.fName + " " + staffMember.lName).capitalized(with: NSLocale.current)
        cell.departmentLabel.text = staffMember.long_desc.capitalized(with: NSLocale.current)
        if(staffMember.ext1 != "") {
            cell.extensionLabel.text = "Ext: " + staffMember.ext1
        } else {
            cell.extensionLabel.text = ""
        }
        cell.emailButton.tag = indexPath.row
        
        return cell
    
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredStaffList = staffList.filter{ staffMember in
            return staffMember.fName.appending(" ").appending(staffMember.lName).lowercased().contains(searchText.lowercased()) || staffMember.lName.appending(" ").lowercased().contains(searchText.lowercased()) || staffMember.long_desc.lowercased().contains(searchText.lowercased())
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
//        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
