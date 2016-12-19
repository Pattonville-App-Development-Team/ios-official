//
//  ExtrasViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/28/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
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
    
    /// Sends the user to a webview if user selects one of these link options
    ///
    /// - parameter tableView: the More tab table view that contains options below and other options that arent links
    /// - parameter indexPath: the row of the More table view that the user selects that the user selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        print(row)
        
        switch row{
            case 0:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://pirates.psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://pirates.psdr3.org")! as URL)
            }
            case 1:
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(URL(string: "http://psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://psdr3.org" )! as URL)
            }
            case 3:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://moodle.psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://moodle.psdr3.org")! as URL)
            }
            case 4:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://psdr3.nutrislice.com")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://psdr3.nutrislice.com")! as URL)
            }
            case 6:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "http://powerschool.psdr3.org")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "http://powerschool.psdr3.org")! as URL)
            }
            default:
                print("ROW: \(row)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}
