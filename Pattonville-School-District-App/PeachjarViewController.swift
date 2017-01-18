//
//  PeachjarViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 10/3/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// TableViewControler for the peachjar links for the different schools
class PeachjarViewController: UITableViewController{
    
    //var schools: SchoolsArray! = SchoolsArray.init()
    @IBOutlet var webView: UIWebView!
    
    /// Gives the number of rows for the tableview
    ///
    /// - parameter tableView: the PeachJarTableView
    /// - parameter section:   the number of sections in the tableView, is 1
    ///
    /// - returns: the number of schools in the array for the umber of rows in the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SchoolsArray.allSchools.count
        
    }
    
    /// This func creates all the cells for the PeachJar tableview
    ///
    /// - parameter tableView: the PeachJarTableView
    /// - parameter indexPath: the row the for the cells
    ///
    /// - returns: the created cell with the school name in it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let school = SchoolsArray.allSchools[indexPath.row]
        
        cell.textLabel?.text = school.name
        
        return cell
        
    }
    
    /// Method for opening a webview with the link to peachjar for each individual school by using SchoolsEnum, if statement to allow for iOS 9 compatibility
    ///
    /// - parameter tableView: the Peachjar Tableview
    /// - parameter indexPath: the row of the peachjar tableview selected to send to peachjar URL of school
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: SchoolsArray.allSchools[row].peachjarURL)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(NSURL(string: SchoolsArray.allSchools[row].peachjarURL)! as URL)

            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
