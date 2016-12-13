//
//  Calendar.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class Calendar{
    
    var datesList = [Event]()
    
    /// adds a date to to the dates list array
    /// - event: the event to add to the list
    /// - returns: the event that was added
    
    func addDate(event: Event) -> Event{
        datesList.append(event);
        return event
    }
    
    /// Gets the events from the dates list that are for a given date
    /// - date: the date to look for
    /// - returns: an array of events that occur on the specified date
    
    func eventsForDate(date: Date) -> [Event]{
        
        var eventsList = [Event]()
        
        for event in datesList{
            if event.date == date{
                eventsList.append(event)
            }
        }
        
        return eventsList
        
    }
    
}
