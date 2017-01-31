//
//  SettingsViewController.swift
//  Pattonville School District App
//
//  Created by Micah Thompkins on 11/16/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
/// The UITableViewController that is used to display the list of application settings
class SettingsViewController: UITableViewController{
    
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
}
