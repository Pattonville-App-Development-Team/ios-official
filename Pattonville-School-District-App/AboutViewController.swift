//
//  AboutViewController.swift
//  Pattonville-School-District-App
//
//  Created by Joshua Zahner on 5/14/17.
//  Copyright © 2017 Pattonville R-3 School District. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        switch row{
        /// Link to the Athletics and Activites Website
        case 1:
            openUrlWithCheckForCompatibility(URLToBeOpened: "https://docs.google.com/forms/d/e/1FAIpQLSdqXNE4Wo8lsWuH9Ku8763B0NWqis3xoV4d5pNHoFfplJvMhw/viewform")
        /// Link to the District Website
        case 2:openUrlWithCheckForCompatibility(URLToBeOpened: "https://www.iubenda.com/privacy-policy/8085303")
        default:
            print("ROW: \(row)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func openUrlWithCheckForCompatibility(URLToBeOpened: String){
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: URLToBeOpened)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(NSURL(string: URLToBeOpened)! as URL)
        }
        
    }

    
}
