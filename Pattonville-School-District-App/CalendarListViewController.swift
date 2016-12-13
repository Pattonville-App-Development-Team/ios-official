//
//  CalendarListViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class CalendarListViewController: UITableViewController{
    
    var calendarList: Calendar!
    
    ///Sets up the look of the ViewController upon loading.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "DateCell", bundle:nil), forCellReuseIdentifier: "DateCell")
        
        calendarList.datesList.sort{
            $0.date.compare($1.date) == ComparisonResult.orderedAscending
        }
        
    }
    
    ///Sets up the look of the ViewController upon appearing on screen.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    /// Defines the number of rows in the tableview
    /// - returns: the number of rows for the tableview to display
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarList.datesList.count
    }
    
    /// Defines the look for a given cell in the table
    /// - tableView: the tableview object
    /// - indexPath: the indexPath for the given cell
    /// - returns: the established cell object
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let event = calendarList.datesList[indexPath.row]
        
        cell.title.text = event.name
        cell.location.text = event.location
        cell.setTimes(start: event.startTime, end: event.endTime)
        
        return cell
        
    }
    
    /// Defines action to take when a cell in teh table is selected
    /// - tableView: the tableView object
    /// - indexPath: the index path for the selected cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
    /// Defines actions to undertake immediately prior to undertaking a segue
    /// - segue: the segue object that is triggered
    /// - sender: the object that invokes teh segue request
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetail"{
            let destination = segue.destination as! CalendarEventDetailController
            let event = tableView.indexPathForSelectedRow?.row
            destination.event = calendarList.datesList[event!]
        }
    }
    
}
