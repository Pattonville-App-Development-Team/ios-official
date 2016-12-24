//
//  Calendar.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit
import MXLCalendarManager

class Calendar{
    
    var datesList: [Event]
    
    var dates: [Date:[Event]]
    
    init(){
        datesList = [Event]()
        dates = [Date:[Event]]()
    }
    
    init(mxlCalendar: MXLCalendar){
        
        datesList = [Event]()
        dates = [Date:[Event]]()
        
        for event in mxlCalendar.events{
            
            let theEvent = Event(mxlEvent: (event as! MXLCalendarEvent))
            
            datesList.append(theEvent);
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let theDateString = dateFormatter.string(from: theEvent.date!)
            let theDate = dateFormatter.date(from: theDateString)
            
            if dates.keys.contains(theEvent.date!){
                dates[theDate!]?.append(theEvent)
            }else{
                dates[theDate!] = [theEvent]
            }
        }
        
    }
    
    /// adds a date to to the dates list array
    /// - event: the event to add to the list
    /// - returns: the event that was added
    
    func addDate(event: Event) -> Event{
        datesList.append(event);
        
        if dates.keys.contains(event.date!){
            dates[event.date!]?.append(event)
        }else{
            dates[event.date!] = [event]
        }
        
        print("DATES LIST: \(datesList) \n")
        print("DATES: \(dates) \n")
        
        return event
    }
    
    /// Gets the events from the dates list that are for a given date
    /// - date: the date to look for
    /// - returns: an array of events that occur on the specified date
    
    func eventsForDate(date: String) -> [Event]{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDate = dateFormatter.date(from: date)
        
        var eventsList = [Event]()
        
        if dates.keys.contains(theDate!){
            eventsList = dates[theDate!]!
        }
        
        return eventsList
        
    }
    
}
