//
//  SchoolSpecificDirectoryTableViewController.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 12/12/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class SchoolSpecificDirectoryTableViewController: UITableViewController {
    
    var staffList = StaffArray.init().staffList
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return staffList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        //let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        
        let staffMember = staffList[indexPath.row]
        
        cell.textLabel?.text = staffMember.firstName + " " + staffMember.lastName
        cell.detailTextLabel?.text = staffMember.department
        
        return cell
        
    }

    
}
