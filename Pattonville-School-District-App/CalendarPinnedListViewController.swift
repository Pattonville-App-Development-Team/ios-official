//
//  CalendarPinnedListViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class CalendarPinnedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var exit: UIBarButtonItem!
    
    @IBAction func exit(sender: UIBarButtonItem!){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var eventsList: [Event]!
    var eventsDictionary = [Date:[Event]]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DateCell", bundle:nil), forCellReuseIdentifier: "DateCell")
        //eventsDictionary = makeEventDictionary(list: eventsList)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        
    }
    
    /// Determines functionality when the view controller stack is modified. If parent = nil then the view controller was popped
    /// OFF the stack, otherwise the view controller was added to the stack
    ///
    /// This function is specifically used to keep the eventsList associated with this view controller and the pinnedDateEvents 
    /// associated with the CalendarViewController in sync when modifications are made in this controller.
    ///
    /// - parent: the parent of the current view controller
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            // The back button was pressed or interactive gesture used
            ((self.parent as! UINavigationController).viewControllers[0] as! CalendarViewController).pinnedDateEvents = eventsList
        }
    }
    
    /// the number of sections in the tableview
    /// - tableView: the tableview object
    ///
    /// - returns: the number of sections in the tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// sets the title for a given section
    /// - tableview: the tableview object
    /// - section: the section in the tableview
    ///
    /// - returns: the title for the section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section"
    }
    
    /// the number of rows in a given section
    /// - tableview: the tableview object
    /// - section: the section in teh tableview
    ///
    /// - returns: the number of rows to show for the given section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (eventsDictionary[getKeyForIndex(index: section)]?.count)!
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        //let event = eventsDictionary[getKeyForIndex(index: indexPath.section)]?[indexPath.row]
        let event = eventsList[indexPath.row]
        
        cell.event = event
        cell.setUp(indexPath: indexPath)
        
        cell.pinButton.tag = indexPath.row;
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
            destination.event = eventsDictionary[getKeyForIndex(index: (event?.section)!)]?[(event?.row)!]
        }
    }
    
    /// Unpins an event
    /// - sender: the pinButton that was tapped
    
    func unPinned(sender: UIView){
        
        let event = eventsList[sender.tag]
        
        print(eventsList.count)
        eventsList = eventsList.filter({
            $0 != event
        })
        
        print(eventsList.count)
        print(eventsDictionary.count)
        
        //eventsDictionary = makeEventDictionary(list: eventsList)
        
        tableView.reloadData()
        
    }
    
    /// Make a dictionary of events from a supplied list of events
    /// - list: the list of events to create a dictionary for
    
    private func makeEventDictionary(list: [Event]) -> [Date: [Event]]{
        
        var dict = [Date: [Event]]()
        
        for event in list{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let theDateString = dateFormatter.string(from: event.date!)
            let theDate = dateFormatter.date(from: theDateString)
            
            if dict.keys.contains(theDate!){
                
                dict[theDate!]?.append(event)
                
            }else{
                dict[theDate!] = [event]
            }
        }
        
        return dict

    }
    
    private func removeEventFromDictionary(event: Event) -> [Date: [Event]]{
        
        print(eventsDictionary.count)
        for (key, _) in eventsDictionary{
            var events = eventsDictionary[key]

            if (events?.contains(event))!{
                events?.remove(at: (events?.index(of: event))!)
                
                if (events?.count)! < 1{
                    eventsDictionary.removeValue(forKey: key)
                }
                
                print("Removed")
                break
            }
            
        }
        
        print(eventsDictionary.count)
        
        return eventsDictionary
        
    }
    
    /// Gets the eventDictionary key for a given index, so as to use section and row indices with the eventsDictionary
    /// - index: the index we want the key for
    ///
    /// - returns: the key at the supplied index
    
    private func getKeyForIndex(index: Int) -> Date{
        var keys = Array(eventsDictionary.keys)
        keys = keys.sorted{
            $0 < $1
        }
        
        return keys[index]
    }
    
}
