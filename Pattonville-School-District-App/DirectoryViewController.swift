//
//  DirectoryViewController.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/15/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// The ViewController for the TableView of schools which have a directory the user can view
class DirectoryViewController: UITableViewController {
    
    
    // Initializing Directory here to prevent recurring directory parsing in the school specific directory pages
    static var directory = Directory()
    
    /// Specifies how many rows the TableView has
    ///
    /// - Parameters:
    ///   - tableView: the TableView that displays the list of schools
    ///   - section: The integer index for which section of the table view is being referenced
    /// - Returns: the number of schools in the allSchools array in the SchoolArray class
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SchoolsArray.allSchools.count
        
    }
    
    /// Displays the proper school in each row of the TableView
    ///
    /// - Parameters:
    ///   - tableView: the TableView that displays the list of schools
    ///   - indexPath: 
    /// - Returns: cell with the school name displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let school = SchoolsArray.allSchools[indexPath.row]
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Learning Center"
        } else if indexPath.row == 10 {
            cell.textLabel?.text = "All Staff"
        } else {
            cell.textLabel?.text = school.name
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 10 {
            performSegue(withIdentifier: "AllStaffSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "SchoolSpecificDirectorySegue", sender: nil)
        
        }
        
    }
    
    /// Passes the selected cell's row index to the SSDViewController class
    ///
    /// - Parameters:
    ///   - segue: Show segue linking the Directory View Controller to the School Specific Directory View Controller
    ///   - sender: Cell in the TableView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SchoolSpecificDirectorySegue" {
            
            let row = tableView.indexPathForSelectedRow?.row
            
            let destination = segue.destination as! SchoolSpecificDirectoryViewController
            
            // Sets the variable "indexOfSchool" located in the SSDViewController class equal to "row"
            destination.indexOfSchool = row
            
        }
        
    }
    
}
