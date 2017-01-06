//
//  DirectoryViewController.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/15/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class DirectoryViewController: UITableViewController {
    
   // var schools: SchoolsArray! = SchoolsArray.init()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SchoolsArray.allSchools.count
        
    }
    
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
