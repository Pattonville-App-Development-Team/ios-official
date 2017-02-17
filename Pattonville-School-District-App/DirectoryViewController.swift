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
    
    /// Method to specify how many rows the TableView has
    ///
    /// - Parameters:
    ///   - tableView: the TableView that displays the list of schools
    ///   - section: The integer index for which section of the table view is being referenced
    /// - Returns: the number of schools in the allSchools array in the SchoolArray class
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SchoolsArray.allSchools.count
        
    }
    
    /// Method to display the proper schools in each row of the TableView
    ///
    /// - Parameters:
    ///   - tableView: the TableView that displays the list of schools
    ///   - indexPath: 
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let school = SchoolsArray.allSchools[indexPath.row]
        
        cell.textLabel?.text = school.name
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SSDSegue" {
            
            let row = tableView.indexPathForSelectedRow?.row
            
            let destination = segue.destination as! SSDViewController
            
            destination.indexOfSchool = row
            
        }
        
    }
    
}
