//
//  CalendarPinnedListViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 11/17/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class CalendarPinnedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var exit: UIBarButtonItem!
    
    @IBAction func exit(sender: UIBarButtonItem!){
        self.dismiss(animated: true, completion: nil)
    }

    var calendar: Calendar!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DateCell", bundle:nil), forCellReuseIdentifier: "DateCell")
        print(calendar.pinnedEvents.count)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    /// the number of sections in the tableview
    /// - tableView: the tableview object
    ///
    /// - returns: the number of sections in the tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendar.pinnedEventsDictionary.count
    }
    
    /// sets the title for a given section
    /// - tableview: the tableview object
    /// - section: the section in the tableview
    ///
    /// - returns: the title for the section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        
        return dateFormatter.string(from: getKeyForIndex(index: section))
    }
    
    /// the number of rows in a given section
    /// - tableview: the tableview object
    /// - section: the section in teh tableview
    ///
    /// - returns: the number of rows to show for the given section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (calendar.pinnedEventsDictionary[getKeyForIndex(index: section)]?.count)!
        //return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CELL FOR ROW AT INDEX PATH")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let event = calendar.pinnedEventsDictionary[getKeyForIndex(index: indexPath.section)]?[indexPath.row]
        
        cell.setup(event: event!, indexPath: indexPath, type: .normal)
        
        cell.pinButton.tag = calendar.getIndexOfEvent(event: event!)
        cell.pinButton.addTarget(self, action: #selector(CalendarPinnedListViewController.unPinned(sender:)), for: UIControlEvents.touchUpInside);
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetail"{
            let destination = segue.destination as! CalendarEventDetailController
            let event = tableView.indexPathForSelectedRow
            destination.event = calendar.pinnedEventsDictionary[getKeyForIndex(index: (event?.section)!)]?[(event?.row)!]
        }
    }
    
    /// Unpins an event
    /// - sender: the pinButton that was tapped
    
    func unPinned(sender: UIView){
        
        tableView.reloadData()
        
    }
    
    /// Gets the eventDictionary key for a given index, so as to use section and row indices with the eventsDictionary
    /// - index: the index we want the key for
    ///
    /// - returns: the key at the supplied index
    
    private func getKeyForIndex(index: Int) -> Date{
        var keys = Array(calendar.pinnedEventsDictionary.keys)
        keys = keys.sorted{
            $0 < $1
        }
        
        return keys[index]
    }

}
