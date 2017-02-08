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
    
    var allEvents: [Event]!
    var allEventsDictionary: [Date:[Event]]!
    
    var pinnedEvents: [Event]!
    var pinnedEventsDictionary: [Date:[Event]]!
    
    init(){
        
        allEvents = []
        allEventsDictionary = [:]
        
        pinnedEvents = []
        pinnedEventsDictionary = [:]
        
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
    
    /// adds a date to to the dates list array
    /// - event: the event to add to the list
    /// - returns: the event that was added
    
    private func addDate(event: Event){
        allEvents.append(event)
        allEventsDictionary = addEventToDictionary(dict: allEventsDictionary, event: event)
    }
    
    
    func pinEvent(event: Event){
        
        if !pinnedEvents.contains(event){
            pinnedEvents.append(event)
            pinnedEventsDictionary = addEventToDictionary(dict: pinnedEventsDictionary, event: event)
            
            print(pinnedEvents.count)
            
        }
        
    }
    
    func unPinEvent(event: Event){
        
        pinnedEvents = pinnedEvents.filter({
            return $0 != event
        })
        
        pinnedEventsDictionary = removeEventFromDictionary(list: pinnedEvents, event: event)
        
        
    }
    
    func getIndexOfEvent(event: Event) -> Int{
        return pinnedEvents.index(of: event)!
    }
    
    
    private func addEventToDictionary(dict: [Date:[Event]], event: Event) -> [Date:[Event]]{
        
        var dictionary = dict
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDateString = dateFormatter.string(from: event.date!)
        let theDate = dateFormatter.date(from: theDateString)
        
        if dictionary.keys.contains(theDate!){
            dictionary[theDate!]?.append(event)
        }else{
            dictionary[theDate!] = [event]
        }
        
        return dictionary

    }
    
    private func removeEventFromDictionary(list: [Event], event: Event) -> [Date: [Event]]{

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
