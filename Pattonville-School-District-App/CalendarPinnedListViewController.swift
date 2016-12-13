//
//  CalendarPinnedListViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class CalendarPinnedListViewController: UITableViewController{
    
    var eventsList: [Event]!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DateCell", bundle:nil), forCellReuseIdentifier: "DateCell")

    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let event = eventsList[indexPath.row]
        
        cell.event = event
        cell.setUp()
        
        cell.pinButton.tag = indexPath.row;
        cell.pinButton.addTarget(self, action: #selector(CalendarPinnedListViewController.unPinned(sender:)), for: UIControlEvents.touchUpInside);
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetail"{
            let destination = segue.destination as! CalendarEventDetailController
            let event = tableView.indexPathForSelectedRow?.row
            destination.event = eventsList[event!]
        }
    }
    
    func unPinned(sender: UIView){
        
        let event = eventsList[sender.tag]
        
        eventsList = eventsList.filter({
            $0 != event
        })
        tableView.reloadData()
    }
    
}
