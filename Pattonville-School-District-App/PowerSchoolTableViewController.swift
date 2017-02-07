//
//  PowerSchoolTableViewController.swift
//  Pattonville-School-District-App
//
//  Created by Micah Thompkins on 2/6/17.
//  Copyright © 2017 Pattonville R-3 School District. All rights reserved.
//

import UIKit
/// The TableView Controller for the Powerschool options list
class PowerSchoolTableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /// The on Row selected method that is called and determines which PowerSchool link to send the user to based upon which type of user they are. Switches on the indexPath to decide which link to send the user to
    ///
    /// - Parameters:
    ///   - tableView: the PowerSchoolTableView listing powerschool options
    ///   - indexPath: the row that the user selects on the Powerschool tableView controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        print(row)
        switch row{
            /// Adminstrators
            case 0:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "https://powerschool.psdr3.org/admin/pw.html")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://powerschool.psdr3.org/admin/pw.html")! as URL)
                }
            /// Students and Parents
            case 1:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "https://powerschool.psdr3.org/public/")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://powerschool.psdr3.org/public/")! as URL)
                }
            /// Teachers
            case 2:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "https://powerschool.psdr3.org/teachers/pw.html")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://powerschool.psdr3.org/teachers/pw.html")! as URL)
                }
            default:
                print("ROW: \(row)")
        }
        

    }}
