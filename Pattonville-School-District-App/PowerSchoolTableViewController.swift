//
//  PowerSchoolTableViewController.swift
//  Pattonville-School-District-App
//
//  Created by Micah Thompkins on 2/6/17.
//  Copyright © 2017 Pattonville R-3 School District. All rights reserved.
//

import UIKit
class PowerSchoolTableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        print(row)
        switch row{
            case 0:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "https://powerschool.psdr3.org/admin/pw.html")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://powerschool.psdr3.org/admin/pw.html")! as URL)
                }
            case 1:
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: "https://powerschool.psdr3.org/public/")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: "https://powerschool.psdr3.org/public/")! as URL)
                }
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
