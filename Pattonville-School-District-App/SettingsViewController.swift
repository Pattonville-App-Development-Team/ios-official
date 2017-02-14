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
    
    @IBOutlet weak var newsStepper: UIStepper!
    
    
    @IBOutlet weak var carouselStepper: UIStepper!
    
    
    @IBOutlet weak var newsCounter: UILabel!
    
    @IBOutlet weak var carouselCounter: UILabel!
    
    @IBAction func newsValueChanged(_ sender: UIStepper) {
        
        newsCounter.text = Int(sender.value).description
    }
    
    @IBAction func carouselValueChanged(_ sender: UIStepper) {
        carouselCounter.text = Int(sender.value).description
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselStepper.maximumValue = 3
        newsStepper.maximumValue = 3
        
        tableView.delegate = self
        
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
