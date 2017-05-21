//
//  CalendarListViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 11/15/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class CalendarListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var exit: UIBarButtonItem!
    
    @IBAction func exitView(sender: UIBarButtonItem!){
        self.dismiss(animated: true, completion: nil)
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    var calendar: Calendar!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    ///Sets up the look of the ViewController upon loading.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "DateCell", bundle:nil), forCellReuseIdentifier: "DateCell")
        
        let sectionIndex = getIndexForSectionName(sectionName: dateFormatter.string(from: Date()))
        
        let indexPath = IndexPath(row: 0, section: sectionIndex)

        tableView.scrollToRow(at: indexPath, at: .top, animated: true)

        tableView.reloadData()

        print(Thread.current)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(Date()) LIST VIEW WILL APPEAR")
        print(Thread.current)
    }
    
    ///Sets up the look of the ViewController upon appearing on screen.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(Date()) LIST VIEW DID APPEAR")
        print(Thread.current)        
    }
    
    /// Determines functionality when the view controller stack is modified. If parent = nil then the view controller was popped
    /// OFF the stack, otherwise the view controller was added to the stack
    ///
    /// This function is specifically used to keep the calendarList associated with this view controller and the calendarList
    /// associated with the CalendarViewController in sync when modifications are made in this controller.
    ///
    /// - parent: the parent of the current view controller
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return calendar.allEventsDictionary.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: getKeyForIndex(index: section))
    }
    
    /// Defines the number of rows in the tableview
    /// - returns: the number of rows for the tableview to display
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let theKey = getKeyForIndex(index: section)
        
        return calendar.allEventsDictionary[theKey]!.count
        
    }
    
    /// Defines the look for a given cell in the table
    /// - tableView: the tableview object
    /// - indexPath: the indexPath for the given cell
    /// - returns: the established cell object
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        calendar.allEventsDictionary[getKeyForIndex(index: indexPath.section)]?.sort(by: {
            ($0.school?.rank)! < ($1.school?.rank)!
        })
        
        let event = calendar.allEventsDictionary[getKeyForIndex(index: indexPath.section)]?[indexPath.row]
        
        cell.setup(event: event!, indexPath: indexPath, type: .normal)
        
        return cell
        
    }
    
    /// Defines action to take when a cell in teh table is selected
    /// - tableView: the tableView object
    /// - indexPath: the index path for the selected cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
    /// Defines actions to undertake immediately prior to undertaking a segue
    /// - segue: the segue object that is triggered
    /// - sender: the object that invokes teh segue request
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetail"{
            let destination = segue.destination as! CalendarEventDetailController
            let event = tableView.indexPathForSelectedRow
            destination.event = calendar.allEventsDictionary[getKeyForIndex(index: (event?.section)!)]?[(event?.row)!]
        }
    }
    
    private func getKeyForIndex(index: Int) -> Date{
        var keys = Array(calendar.allEventsDictionary.keys)
        keys = keys.sorted{
            $0 < $1
        }
        
        return keys[index]
    }
    
    private func getIndexForSectionName(sectionName: String) -> Int{
        
        var keys = Array(calendar.allEventsDictionary.keys)

        keys = keys.sorted()
        print(dateFormatter.date(from: sectionName)!)
        let key = keys.index(of: dateFormatter.date(from: sectionName)!)
        print("THE KEY IS \(key)")
        if let theKey = key{
            return theKey
        }else{
            
            let day = dateFormatter.date(from: sectionName)!
            print("ADDING ONE TO DAY")
            var dateComponent = DateComponents()
            dateComponent.day = 1
            
            // Find the date for one hour ago
            let lastDay = NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: day, options: [])

            return getIndexForSectionName(sectionName: dateFormatter.string(from: lastDay!))
        }
        
        
    }
    
    
}
