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
        
        switch row{
            /// Link to the Athletics and Activites Website
            case 0:
                openUrlWithCheckForCompatibility(URLToBeOpened: "http://pirates.psdr3.org")
            /// Link to the District Website
            case 2:
                openUrlWithCheckForCompatibility(URLToBeOpened: "http://moodle.psdr3.org")

            default:
                print("ROW: \(row)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    /// Used to open URL's in safari, checks iOS level then opens the given URL
    ///
    /// - Parameter URLToBeOpened: the URL to be opened, changes based upon which row selected
    func openUrlWithCheckForCompatibility(URLToBeOpened: String){
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: URLToBeOpened)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(NSURL(string: URLToBeOpened)! as URL)
        }
        
    }
    
    
}
