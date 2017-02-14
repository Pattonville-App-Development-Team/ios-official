//
//  Event.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import MXLCalendarManager

class Event: NSObject, NSCoding{
    
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
    
    override init(){
        
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
    
    required init(coder aDecoder: NSCoder){
        
        eventID = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as? String
        date = aDecoder.decodeObject(forKey: "date") as? Date
        startTime = aDecoder.decodeObject(forKey: "startTime") as? Date
        endTime = aDecoder.decodeObject(forKey: "endTime") as? Date
        dateString = aDecoder.decodeObject(forKey: "dateString") as? String
        timeString = aDecoder.decodeObject(forKey: "timeString") as? String
        location = aDecoder.decodeObject(forKey: "location") as? String
        pinned = aDecoder.decodeBool(forKey: "pinned")
        
        school = SchoolsArray.getSchoolByName(name: aDecoder.decodeObject(forKey: "school") as! String)
        
        super.init()
        
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(school?.name, forKey: "school")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(dateString, forKey: "dateString")
        aCoder.encode(timeString, forKey: "timeString")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(eventID, forKey: "id")
        aCoder.encode(pinned, forKey: "pinned")
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
