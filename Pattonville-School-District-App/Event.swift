//
//  Event.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class Event: Equatable{
    
    var name: String
    var date: Date
    var startTime: Date = Date.init()
    var endTime: Date = Date.init()
    var dateString: String
    var timeString: String
    var location: String
    var pinned: Bool = false
    var eventID: String    
    init(name: String, dateString: String, startTime: String, endTime: String, location: String){
        
        self.name = name
        self.dateString = dateString
        self.location = location
        self.timeString = "\(start) - \(end)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let date = dateFormatter.date(from: dateString)
        self.date = date!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let startTime = timeFormatter.date(from: start)
        let endTime = timeFormatter.date(from: end)
        
        self.startTime = startTime!
        self.endTime = endTime!
        
        self.eventID = NSUUID().uuidString
        
    }
    
    func setPinned(){
        pinned = true
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool{
        return lhs.eventID == rhs.eventID
    }
    
}
