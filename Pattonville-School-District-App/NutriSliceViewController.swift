//
//  NutriSliceViewController.swift
//  Pattonville-School-District-App
//
//  Created by Micah Thompkins on 12/19/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// TableViewControler for the nutriSlice links for the different schools
class NutriSliceViewController: UITableViewController{
    
   // var schools: SchoolsArray! = SchoolsArray.init()
    
    
    
    /// Gives the number of rows for the tableview
    ///
    /// - parameter tableView: the NutriSliceTableView
    /// - parameter section:   the number of sections in the tableView, is 1
    ///
    /// - returns: the number of schools in the array for the umber of rows in the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SchoolsArray.getSchools().count
        
    }
    
    /// This func creates all the cells for the NutriSlice tableview
    ///
    /// - parameter tableView: the NutriSliceTableView
    /// - parameter indexPath: the row the for the cells
    ///
    /// - returns: the created cell with the school name in it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let school = SchoolsArray.getSchools()[indexPath.row]
        
        cell.textLabel?.text = school.name
        
        return cell
        
    }
    
    /// Method for opening a webview with the link to nutrislice for each individual school by using SchoolsEnum, if statement to allow for iOS 9 compatibility
    ///
    /// - parameter tableView: the NutriSliceTableView
    /// - parameter indexPath: the row of the peachjar tableview selected to send to nutriSliceURL of school
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: SchoolsArray.getSchools()[row].nutriSliceURL)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(NSURL(string: SchoolsArray.getSchools()[row].nutriSliceURL)! as URL)
            
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
