//
//  SelectSchoolsViewController.swift
//  Pattonville School District App
//
//  Created by Micah Thompkins on 11/16/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//
import UIKit

/// The TableViewController for selecting which schools a user wants to be subscribed to
class SelectSchoolsTableViewController: UITableViewController{
    var merge: String = "Doing this to merge"
    var schools: SchoolsArray! = SchoolsArray.init()
    
    /// Set up how the tableView appears on screen
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.delegate = self
        
        tableView.reloadData()
        
        tableView.rowHeight = 44
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Give the number of rows used in the SelectSchoolsTableView
    ///
    /// - parameter tableView: the SelectSchoolsTableView
    /// - parameter section:   number of sections, is 1
    ///
    /// - returns: A count from the schools array that gives the number of schools.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return schools.allSchools.count
        
    }
    
    /// Populates the Prototype cells of the tableView with the School name
    ///
    /// - parameter tableView: the SelectSchoolsTableView
    /// - parameter indexPath: the current row it is populating
    ///
    /// - returns: the completed cell populated with the school name, color, and switch to determine wheter a user is subscribed or not
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSchoolsCell",
                                                 for: indexPath) as! SelectSchoolsTableCell
        
        let school = schools.allSchools[indexPath.row]
        cell.schoolNameLabel.text = school.name
        cell.schoolColorView.backgroundColor = school.color
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
  
  
}

