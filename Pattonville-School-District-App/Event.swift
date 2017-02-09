//
//  Event.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import MXLCalendarManager

class Event: Equatable{
    
    var name: String?
    var date: Date?
    var startTime: Date?
    var endTime: Date?
    var dateString: String?
    var timeString: String?
    var location: String?
    var pinned: Bool = false
    var eventID: String
    var school: School?
    
    init(){
        
        name = ""
        date = nil
        startTime = nil
        endTime = nil
        dateString = ""
        timeString = ""
        location = ""
        eventID = ""
        school = nil
        
    }
    
    init(name: String, dateString: String, start: String, end: String, location: String, school: School){
        
        self.name = name
        self.dateString = dateString
        self.location = location
        self.timeString = "\(start) - \(end)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let date = dateFormatter.date(from: dateString)
        self.date = date!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "YYYY-MM-dd h:mm a"
        
        let startTime = timeFormatter.date(from: "\(dateString) \(start)")
        let endTime = timeFormatter.date(from: "\(dateString) \(end)")
        
        self.startTime = startTime!
        self.endTime = endTime!
        
        self.school = school
        
        self.eventID = NSUUID().uuidString
        
    }
    
    init(mxlEvent: MXLCalendarEvent, school: School){
        
        self.school = school
        
        self.name = mxlEvent.eventSummary
        self.date = mxlEvent.eventStartDate
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"

        let startTimeString = timeFormatter.string(from: mxlEvent.eventStartDate)
        let endTimeString = timeFormatter.string(from: mxlEvent.eventStartDate)
        
        let theStartTime = timeFormatter.date(from: startTimeString)
        let theEndTime = timeFormatter.date(from: endTimeString)
        
        self.startTime = theStartTime!
        self.endTime = theEndTime!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY h:mm a"
        
        self.dateString = dateFormatter.string(from: mxlEvent.eventStartDate)
        self.timeString = dateFormatter.string(from: mxlEvent.eventStartDate)
        
        self.location = mxlEvent.eventLocation
        self.eventID = mxlEvent.eventUniqueID
        
    }
    
    func setPinned(){
        pinned = true
        Calendar.instance.pinEvent(event: self)
    }
    
    func setUnpinned(){
        pinned = false
        Calendar.instance.unPinEvent(event: self)
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool{
        return lhs.eventID == rhs.eventID && lhs.school == rhs.school
    }
    
}
