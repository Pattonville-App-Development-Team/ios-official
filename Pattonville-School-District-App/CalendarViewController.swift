
//
//  SecondViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/27/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit
import JTAppleCalendar
import MXLCalendarManager

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var calendar: JTAppleCalendarView!
    @IBOutlet var tableView: UITableView!
    
    var calendarList: Calendar!
    
    var selectedDate: Date = Date()
    
    var selectedDateEvents = [Event]()
    var pinnedDateEvents = [Event]()
    
    
    var mxlCalendarManager = MXLCalendarManager()
    
    /// Sets up look of view controller upon loading. Completes basic setup of Calendar and TableView appearances and sorts the events list for pinned events
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*mxlCalendarManager.scanICSFile(atRemoteURL: URL(string: "http://drummond.psdr3.org/ical/High%20School.ics"), withCompletionHandler: {
            (calendar, error) -> Void in
            
            if !(error != nil){
                self.calendarList.appendDates(mxlCalendar: calendar!)
                print(self.calendarList.dates)
            }else{
                print(error!)
            }
            
            self.calendar.reloadData()
            self.tableView.reloadData()
            
        })*/
        
        let schools = SchoolsArray.getSubscribedSchools()
        
        print(schools)
        
        
        for school in schools{
            school.getCalendarData(onSucces: {
                (calendar) -> Void in
                self.calendarList.appendDates(mxlCalendar: calendar!, school: school)
            }, onError: {
                (error) -> Void in
                print(error ?? "Error")
            })
            //print(mxlCal)
            self.calendar.reloadData()
            self.tableView.reloadData()
        }
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DateCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        calendar.registerCellViewXib(file: "DateView")
        calendar.registerHeaderView(xibFileNames: ["CalendarHeaderView"])
        
        calendar.cellInset = CGPoint(x: 0, y: 0.25)
        
        calendar.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /// Establishes appearance of view controller upon appearance on screen. Reloads calendar and tableview data and filter calendar events for teh current date.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pinnedDateEvents = calendarList.datesList.filter({
            return $0.pinned
        })
        
        calendar.reloadData()
        tableView.reloadData()
        
        filterCalendarData(for: selectedDate)
        calendar.selectDates([Date(), selectedDate])
        
        print("VIEW DID APPEAR")
        
        
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
        
        (cell as! CalendarDateView).setupCellBeforeDisplay(cellState: cellState, date: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        let theDate = dateFormatter.date(from: dateString)
        
        if calendarList.dates.keys.contains(theDate!){
            (cell as! CalendarDateView).showDelineator()
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
        
        if compareDates(date1: date, date2: Date()) && cellState.dateBelongsTo == .thisMonth{
            (cell as? CalendarDateView)?.setSelected(color: UIColor(red: 0/255.0, green: 122/255.0, blue: 51/255.0, alpha: 1.0))
        }else{
            //calendar.scrollToDate(date)
            (cell as? CalendarDateView)?.setSelected(color: UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1))
        }
        
        if !calendarList.eventsForDate(date: formatDate(date: date)).isEmpty{
            (cell as? CalendarDateView)?.dateDelineater.backgroundColor = .white
        }else{
            (cell as? CalendarDateView)?.dateDelineater.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0)
        }
        
        selectedDate = date
        
        filterCalendarData(for: date)
        
        tableView.reloadData()
        
    }
    
    /// Defines the actions to undertake when a given cell is deselected
    /// - calendar: the instance of the calendar onscreen
    /// - date: the date associated with the selected cell
    /// - cell: the cell that was selected
    /// - cellState: the state of the cell after being deselected
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CalendarDateView)?.setUnselected(cellState: cellState)
        
        if !calendarList.eventsForDate(date: formatDate(date: date)).isEmpty{
            (cell as? CalendarDateView)?.dateDelineater.backgroundColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
        }else{
            (cell as? CalendarDateView)?.hideDelineator()
        }

        
        calendar.selectDates([Date()])
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
        
        let event = calendarList.eventsForDate(date: formatDate(date: selectedDate))[indexPath.row]
        
        cell.event = event
        cell.setUp()
        cell.pinButton.tag = indexPath.row;
        cell.pinButton.addTarget(self, action: #selector(CalendarViewController.nowPinned(sender:)), for: UIControlEvents.touchUpInside);
        
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
            let destination = segue.destination as! CalendarListViewController
            destination.calendarList = calendarList
        }else if segue.identifier == "CalendarPinnedViewSegue"{
            let destination = segue.destination as! CalendarPinnedListViewController
            destination.eventsList = pinnedDateEvents
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
        
        selectedDateEvents = calendarList.eventsForDate(date: theDateString)
        
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
    
    func nowPinned(sender: UIView){
        let event = selectedDateEvents[sender.tag];
        
        if event.pinned && !pinnedDateEvents.contains(event){
            pinnedDateEvents.append(event)
        }else if(!event.pinned && pinnedDateEvents.contains(event)){
            pinnedDateEvents = pinnedDateEvents.filter({
                $0 != event
            })
        }
        
        tableView.reloadData()
        
    }
    
    /// Scrolls calendar forward one month
    /// - sender: the button that triggers the function
    
    func forwardMonth(sender: UIView){
        
        var dateComponent = DateComponents()
        dateComponent.month = 1
        
        calendar.scrollToDate((NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: calendar.visibleDates().monthDates[0], options: []))!)
    }
    
    /// Scrolls calendar backward one month
    /// - sender: the button that triggers the function
    
    func backMonth(sender: UIView){

        var dateComponent = DateComponents()
        dateComponent.month = -1
        
        calendar.scrollToDate((NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: calendar.visibleDates().monthDates[0], options: []))!)

    
    }
    
    /// Formats date a given date object as a string (useful for date comparison and formatting dates to have the same time)
    /// - date: the date object to format as a string
    
    private func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDateString = dateFormatter.string(from: date)
        
        return theDateString
        
    }
    
}

