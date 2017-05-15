
//
//  SecondViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/27/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import JTAppleCalendar
import MXLCalendarManager

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var pinButton: UIBarButtonItem!
    @IBOutlet var listButton: UIBarButtonItem!
    
    @IBAction func goToList(sender: UIBarButtonItem){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "CalendarListViewSegue", sender: sender)
        }
    }
    
    var calendar: Calendar! = Calendar.instance
    
    var selectedDate: Date = Date(){
        didSet{
            print("SELECTED DATE: \(selectedDate)")
        }
    }
    
    var selectedDateEvents = [Event]()
    
    var prevSchools: [School]!
    
    var todayCell: CalendarDateView! = CalendarDateView()
    var selectedCell: CalendarDateView!{
        didSet{
            print("SELECTED CELL: \(selectedCell)")
        }
    }
    
    /// Sets up look of view controller upon loading. Completes basic setup of Calendar and TableView appearances and sorts the events list for pinned events
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pinButton.width = -2.0;
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DateCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        calendarView.registerCellViewXib(file: "DateView")
        calendarView.registerHeaderView(xibFileNames: ["CalendarHeaderView"])
        calendarView.cellInset = CGPoint(x: 0, y: 0.25)
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false)
        
        
        // Do any additional setup after loading the view, typically from a nib.
//        print("VIEW DID LOAD")
        
        prevSchools = SchoolsArray.getSubscribedSchools()
        
    }
    
    /// Establishes appearance of view controller upon appearance on screen. Reloads calendar and tableview data and filter calendar events for teh current date.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Reachability.isConnectedToNetwork() && SchoolsArray.getSubscribedSchools() != prevSchools{
            
            calendar.getInBackground(completionHandler: {
                self.calendarView.reloadData()
                self.filterCalendarData(for: self.selectedDate)
                self.tableView.reloadData()
            })
            
            prevSchools = SchoolsArray.getSubscribedSchools()
            
        }
        
        calendarView.reloadData()
        
        calendarView.selectDates([selectedDate])
        
        filterCalendarData(for: selectedDate)
        
        tableView.reloadData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Sets up basic configuration for the calendar
    /// - calendar: the instance of the calendar onscreen
    /// - returns: a ConfigurationParameters object that is used by the calendar to complete intialization
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let firstDate = formatter.date(from: "2016 01 01")
        let secondDate = formatter.date(from: "2020 12 31")
        let numberOfRows = 6
        let aCalendar = NSCalendar.current
        
        return ConfigurationParameters(startDate: firstDate!,
                                       endDate: secondDate!,
                                       numberOfRows: numberOfRows,
                                       calendar: aCalendar,
                                       generateInDates: InDateCellGeneration.forAllMonths,
                                       generateOutDates: OutDateCellGeneration.tillEndOfGrid,
                                       firstDayOfWeek: DaysOfWeek.sunday)
        
    }
    
    /// Sets up a cell instance for each date on the calendar
    /// - calendar: the instance of the calendar onscreen
    /// - cell: the cell that is being setup
    /// - date: a date object associated with the cell
    /// - cellState: the state of the cell (used to determine weekday from weekend)
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState){
        
        let cell = (cell as! CalendarDateView)
        
        cell.setup(cellState: cellState, date: date)
        
        if compareDates(date1: date, date2: Date()){
            todayCell = cell
        }
        
        if compareDates(date1: date, date2: selectedDate){
            selectedCell = cell
            selectedCell.select(date: date)
        }

    }
    
    /// Sets the size of the header of the clanedar
    /// - calendar: the instance of the calendar onscreen
    /// - range: the date range associated with the particular header
    /// - month: the month associated with the header view
    /// - returns: the size of the header
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: 65)
        
    }
    
    /// Sets up the instance of a header view for the clanedar
    /// - calendar: the instance of the clanedar onscreen
    /// - header: the header view object
    /// - range: the range of dates for which a given header is shown
    /// - identifier: teh unique identifier of the section header
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        
        let header = (header as! CalendarHeaderView)
        
        header.setupCellBeforeDisplay(date: range.end)
        
        header.forwardOneMonth.tag = 1
        header.backOneMonth.tag = 0
        
        header.forwardOneMonth.addTarget(self, action: #selector(CalendarViewController.forwardMonth(sender:)), for: UIControlEvents.touchUpInside)
        header.backOneMonth.addTarget(self, action: #selector(CalendarViewController.backMonth(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    
    /// Defines the actions to undertake when a given cell is selected
    /// - calendar: the instance of the calendar onscreen
    /// - date: the date associated with the selected cell
    /// - cell: the cell that was selected
    /// - cellState: the state of the cell after being selected
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let cell = (cell as? CalendarDateView)
        
        cell?.select(date: date)
        
        selectedDate = date
        selectedCell = cell
        
        filterCalendarData(for: date)
        
        tableView.reloadData()
        
    }
    
    /// Defines the actions to undertake when a given cell is deselected
    /// - calendar: the instance of the calendar onscreen
    /// - date: the date associated with the selected cell
    /// - cell: the cell that was selected
    /// - cellState: the state of the cell after being deselected
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let cell = (cell as? CalendarDateView)
        
        cell?.deselect(date: date, cellState: cellState)
        
        todayCell.styleToday()
    
    }
    
    
    /// Establishes the number of cells to show in the tableview section
    /// - tableView: the instance of the tableview onscreen
    /// - section: the section of the tableview
    /// - returns: the number of cells in a given section of the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDateEvents.count
    }
    
    /// Sets up the cell for a given row in the tableview
    /// - tableView: the instance of the tableview onscreen
    /// - indexPath: the indexPath for the particular cell
    /// - returns: the setup cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let event = selectedDateEvents[indexPath.row]
        
        cell.setup(event: event, indexPath: indexPath, type: .normal)
        
        cell.pinButton.addTarget(self, action: #selector(CalendarViewController.changePinValue), for: UIControlEvents.touchUpInside);
        
        return cell
    }
    
    /// Defines the functionality of a selected cell in the table
    /// - tableeView: the instance of teh teableview onscreen
    /// - indexPath: the indexPath of the selected cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
    /// Defines preparation steps for segues leaving this view controller
    /// - segue: the segue that was triggered
    /// - sender: the object that triggered the segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarListViewSegue"{
            let destination = (segue.destination as! UINavigationController).viewControllers[0] as! CalendarListViewController
            destination.calendar = calendar
        }else if segue.identifier == "PinnedListSegue"{
            let destination = (segue.destination as! UINavigationController).viewControllers[0] as! CalendarPinnedListViewController
            destination.calendar = calendar
        }else if segue.identifier == "EventDetail"{
            let destination = segue.destination as! CalendarEventDetailController
            let event = tableView.indexPathForSelectedRow?.row
            destination.event = selectedDateEvents[event!]
        }
    }
    
    /// Filters the calendar events list for events on a specific date
    /// - date: the date to look for
    
    private func filterCalendarData(for date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDateString = dateFormatter.string(from: date)
        let theDate = dateFormatter.date(from: theDateString)
        
        selectedDateEvents = calendar.eventsForDate(date: theDate!)
        
        selectedDateEvents.sort(by: {
            ($0.school?.rank)! < ($1.school?.rank)!
        })
        
    }
    
    /// Compares two dates to check for equality
    /// - date1: the first date to compare
    /// - date2: the date to compare to
    /// - returns: whether ot not the dates are equal
    
    private func compareDates(date1: Date, date2: Date) -> Bool{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDate = dateFormatter.string(from: date1)
        let today = dateFormatter.string(from: date2)
        
        if theDate.compare(today) == .orderedSame{
            return true
        }else{
            return false
        }
        
    }
    
    /// Establishes actions for when an event becomes pinned
    /// - sender: the event that was pinned
    
    func changePinValue(sender: UIView){
        let event = selectedDateEvents[sender.tag];
        
        if event.pinned && !calendar.pinnedEvents.contains(event){
            calendar.pinEvent(event: event)
        }else if(!event.pinned && calendar.pinnedEvents.contains(event)){
            calendar.unPinEvent(event: event)
        }
        
        tableView.reloadData()
        
    }
    
    /// Scrolls calendar forward one month
    /// - sender: the button that triggers the function
    
    func forwardMonth(sender: UIView){
        
        calendarView.deselectAllDates()
        
        var dateComponent = DateComponents()
        dateComponent.month = 1
        
        calendarView.scrollToDate((NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: calendarView.visibleDates().monthDates[0], options: []))!)
    }
    
    /// Scrolls calendar backward one month
    /// - sender: the button that triggers the function
    
    func backMonth(sender: UIView){
        
        calendarView.deselectAllDates()

        var dateComponent = DateComponents()
        dateComponent.month = -1
        
        calendarView.scrollToDate((NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: calendarView.visibleDates().monthDates[0], options: []))!)
    
    }
    
    /// Formats date a given date object as a string (useful for date comparison and formatting dates to have the same time)
    /// - date: the date object to format as a string
    
    private func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDateString = dateFormatter.string(from: date)
        
        return theDateString
        
    }
    
    /*private func refreshData(){
        
        parser.updateSchools(schools: currentSchools)
        
        parser.getEventsInBackground(completionHandler: {
            
            self.selectedDateEvents = self.calendar.eventsForDate(date: self.selectedDate)
            
            self.calendarView.reloadData()
            self.tableView.reloadData()
        })

    }*/
    
}

