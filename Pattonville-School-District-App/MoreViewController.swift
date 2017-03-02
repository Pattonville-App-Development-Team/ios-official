//
//  ExtrasViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/28/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// Table View Controller for the more tab view
class MoreViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Sends the user to a webview if user selects one of these link options, if statement to allow for iOS 9 compatibility
    ///
    /// - parameter tableView: the More tab table view that contains options below and other options that arent links
    /// - parameter indexPath: the row of the More table view that the user selects that the user selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
//        print(row)
        
        switch row{
            /// Link to the Athletics and Activites Website
            case 0:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://pirates.psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://pirates.psdr3.org")! as URL)
                }
            /// Link to the District Website
            case 1:
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(URL(string: "http://psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://psdr3.org" )! as URL)
                }
            /// Link to the Moodle
            case 3:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://moodle.psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://moodle.psdr3.org")! as URL)
                }
            /// Link to the Feedback form
            case 7:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdqXNE4Wo8lsWuH9Ku8763B0NWqis3xoV4d5pNHoFfplJvMhw/viewform")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdqXNE4Wo8lsWuH9Ku8763B0NWqis3xoV4d5pNHoFfplJvMhw/viewform")! as URL)
                }
            default:
                print("ROW: \(row)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}
