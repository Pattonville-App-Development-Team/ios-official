//
//  Calendar.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//
import UIKit
import MXLCalendarManager

class Calendar{
    
    static var instance: Calendar = Calendar()
    
    // A lit and dictionary of all events
    var allEvents: [Event]
    var allEventsDictionary: [Date:[Event]]
    
    // A list and dictionary contained pinned events
    var pinnedEvents: [Event]
    var pinnedEventsDictionary: [Date:[Event]]
    
    // The URL of the cache file
    let fileURL: NSURL = {
        
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let document = directories.first!
        
        return document.appendingPathComponent("event.archive") as NSURL
        
    }()
    
    init(){
        
        allEvents = []
        allEventsDictionary = [:]
        
        pinnedEvents = []
        pinnedEventsDictionary = [:]
        
        readFromFile()
        
    }
    
    
    /// appends dates to the list and dictionary
    ///
    /// - mxlCalendar: an MXLCalendar calendar to pull dates from
    /// - school: the schools the event belongs to
    
    func appendDates(mxlCalendar: MXLCalendar, school: School){
        
        for event in mxlCalendar.events{
            
            let theEvent = Event(mxlEvent: (event as! MXLCalendarEvent), school: school)
            
            if pinnedEvents.contains(theEvent){
                theEvent.setPinned()
            }
            
            if !allEvents.contains(theEvent){
                addDate(event: theEvent)
            }
            
        }
        
    }
    
    /// Append all of the events of an array to allEvents
    ///
    /// - dates: the array of events to add
    func appendDates(dates: [Event]){
        
        for event in dates{
            if pinnedEvents.contains(event){
                event.setPinned()
            }
            
            if !allEvents.contains(event){
                addDate(event: event)
            }
        }
        
    }
    
    /// adds a date to to the dates list array
    /// - event: the event to add to the list
    /// - returns: the event that was added
    
    private func addDate(event: Event){
        allEvents.append(event)
        allEventsDictionary = addEventToDictionary(dict: allEventsDictionary, event: event)
    }
    
    /// Adds and event to the pinnedEvents dictinoary
    ///
    /// - event: the event to add
    func pinEvent(event: Event){
        
        if !pinnedEvents.contains(event){
            pinnedEvents.append(event)
            pinnedEventsDictionary = addEventToDictionary(dict: pinnedEventsDictionary, event: event)
        }
        
    }
    
    /// Removes an event from the pinnedEvents dictionary
    ///
    /// - event: the event to remove
    func unPinEvent(event: Event){
        
        pinnedEvents = pinnedEvents.filter({
            return $0 != event
        })
        
        pinnedEventsDictionary = removeEventFromDictionary(list: pinnedEvents, event: event)
        
    }
    
    /// get the index of a given event
    ///
    /// - event: the event
    /// - returns the index of the event
    func getIndexOfEvent(event: Event) -> Int{
        return pinnedEvents.index(of: event)!
    }
    
    /// Adds a given event to a given dictionary
    ///
    /// - dict: a dictionary of events
    /// - event: the event to add to the dictionary
    ///
    /// - returns a dictionary with the contents of original dictionary
    ///           plus the given event
    private func addEventToDictionary(dict: [Date:[Event]], event: Event) -> [Date:[Event]]{
        
        var dictionary = dict
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDateString = dateFormatter.string(from: event.start!)
        let theDate = dateFormatter.date(from: theDateString)
        
        if dictionary.keys.contains(theDate!){
            dictionary[theDate!]?.append(event)
        }else{
            dictionary[theDate!] = [event]
        }
        
        return dictionary
        
    }
    
    /// Removes the given event from given dictionary
    ///
    /// - list: the list of events to remove from
    /// - event: the event to remove
    ///
    /// - returns a new dictionary with the contents of the list except the
    ///           the passed event
    private func removeEventFromDictionary(list: [Event], event: Event) -> [Date: [Event]]{
        
        var dict = [Date: [Event]]()
        
        for event in list{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let theDateString = dateFormatter.string(from: event.start!)
            let theDate = dateFormatter.date(from: theDateString)
            
            if dict.keys.contains(theDate!){
                
                dict[theDate!]?.append(event)
                
            }else{
                dict[theDate!] = [event]
            }
        }
        
        return dict
        
    }
    
    
    /// Gets the events from the dates list that are for a given date
    /// - date: the date to look for
    /// - returns: an array of events that occur on the specified date
    
    func eventsForDate(date: Date) -> [Event]{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDateString = dateFormatter.string(from: date)
        let theDate = dateFormatter.date(from: theDateString)
        
        var eventsList = [Event]()
        
        if allEventsDictionary.keys.contains(theDate!){
            eventsList = allEventsDictionary[theDate!]!
        }
        
        return eventsList
        
    }
    
    /// Gets Events from the parser in background
    ///
    /// - onCompletionHandler: function to run on completion of parsing
    
    func getInBackground(completionHandler: (() -> Void)?){
        
        let parser = CalendarParser()
        
        parser.getEventsInBackground(completionHandler: {
            
            let success = self.saveToFile()
            
            if success{
                UserDefaults.standard.set(Date(), forKey: "lastCalendarUpdate")
            }
            
            completionHandler?()
        })
        
    }
    
    /// Get Events from the most resonable source
    ///
    /// - onCompletionHandler: function to run on completion of background parsing if necesarry
    func getEvents(completionHandler: (() -> Void)?){
        
        let mostRecentSave: Date
        
        // Get most recent save Date()
        if let recent = UserDefaults.standard.object(forKey: "lastCalendarUpdate") as! Date?{
            mostRecentSave = recent
        }else{
            mostRecentSave = Date()
        }
        
        var dateComponent = DateComponents()
        dateComponent.day = -1
        
        // Find the date for one hour ago
        let lastWeek = NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: Date(), options: [])
        
        //If the most recent save time is longer than one hour ago OR read from file is unsuccesful OR allEvents is empty
        if Reachability.isConnectedToNetwork() && mostRecentSave < lastWeek! || !readFromFile() || allEvents.count == 0{
            
            //Parse events in background
            getInBackground(completionHandler: {
                completionHandler?()
            })
            
        }
        
    }
    
    /// Save allNews to the Cache File
    /// - returns: if saving succeeded
    func saveToFile() -> Bool{

        //print("Saved to file \(fileURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allEvents, toFile: fileURL.path!)
        
    }
    
    /// Read data from cache file and append its contents into allEvents
    /// - returns: if reading from the file succeeded
    func readFromFile() -> Bool{
        if let archived = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path!) as? [Event]{
            //print("FROM ARCHIVED \(fileURL.path!)")

            if allEvents.count < 1{
                appendDates(dates: archived)
            }
            
            return true
            
        }
        
        return false
        
    }
    
    /// Whether or not a given date has any events
    ///
    /// - date: the date to look at
    /// - returns: Whether or not a given date has any events
    func hasEvents(for date: Date) -> Bool{
        return eventsForDate(date: date).count > 0
    }
    
    ///Resets the events list and events dictionary to empty
    func resetEvents(){
        allEvents = []
        allEventsDictionary = [:]
    }
    
    
}
