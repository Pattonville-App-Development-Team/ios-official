//
//  SelectSchoolsViewController.swift
//  Pattonville School District App
//
//  Created by Micah Thompkins on 11/16/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//
import UIKit

/// The TableViewController for selecting which schools a user wants to be subscribed to
class SelectSchoolsTableViewController: UITableViewController{
   //var schools: SchoolsArray! = SchoolsArray.init()
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
        
        return SchoolsArray.getSchools().count
        
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
        
        let school = SchoolsArray.getSchools()[indexPath.row]
        cell.schoolNameLabel.text = school.name
        cell.schoolColorView.backgroundColor = school.color
        cell.schoolEnabledSwitch.setOn(school.isSubscribedTo, animated: false)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.schoolEnabledSwitch.tag = indexPath.row;
        cell.schoolEnabledSwitch.addTarget(self, action: #selector(SelectSchoolsTableViewController.switchIsChanged(sender:)), for: UIControlEvents.valueChanged)
        
        return cell
        
    }
    
    /// The method that activates when the schoolEnabledSwithc is activated in SelectSchoolsTableView. Gets the school from the tableVeiw cellForRowAt method with the tag and then sets the School's isSubscribedTo value to the opposite of its current value. Then saves the data using UserDefaults and the key of the school name.
    ///
    /// - Parameter sender: The school selescted switch
    func switchIsChanged(sender: UISwitch){
        let school = SchoolsArray.allSchools[sender.tag + 1]
        school.isSubscribedTo = !school.isSubscribedTo
        print("switchIsChanged method is being called")
        
        UserDefaults.standard.set(school.isSubscribedTo, forKey: school.name)
        print("Saved \(school.name)'s isSubscribedTo bool val to \(UserDefaults.standard.bool(forKey: school.name))")
        for school in SchoolsArray.allSchools {
            print(school.isSubscribedTo)
            
        }
        
    }
    
  
  
}

