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
//        print(row)
        switch row{
            /// Adminstrators
            case 0:
                openUrlWithCheckForCompatibility(URLToBeOpened: "https://powerschool.psdr3.org/admin/pw.html")
            /// Students and Parents
            case 1:
                openUrlWithCheckForCompatibility(URLToBeOpened: "https://powerschool.psdr3.org/public/")
            /// Teachers
            case 2:
                openUrlWithCheckForCompatibility(URLToBeOpened: "https://powerschool.psdr3.org/teachers/pw.html")
            default:
                print("ROW: \(row)")
        }
        
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
