//
//  CalendarParser.swift
//  Pattonville-School-District-App
//
//  Created by Joshua Zahner on 1/30/17.
//  Copyright © 2017 Pattonville R-3 School District. All rights reserved.
//

import UIKit
import MXLCalendarManager

class CalendarParser{
    
    var calendar: Calendar!
    
    var schools: [School]
    var school: School? = nil
    
    init(calendar: Calendar, schools: [School]){
        self.calendar = calendar
        self.schools = schools
    }
    
    /// Updates the school list for the parser to parse from
    ///
    /// - schools: the array of schools to parse from (SchoolsArray.getSubscribedSchools())
    func updateSchools(schools: [School]){
        self.schools = schools
    }

    func getEventsInBackground(completionHandler: (() -> Void)?){
        
        DispatchQueue.global(qos: .background).async{
            
            self.calendar.resetEvents()
            
            for school in self.schools{
                
                school.getCalendarData(onSucces: {
                    (calendar) -> Void in
                    
                    DispatchQueue.main.async{
                        
                        self.calendar.appendDates(mxlCalendar: calendar!, school: school)
                        completionHandler?()
                        
                    }
                    
                }, onError: {
                    (error) -> Void in
                    print(error ?? "Error")
                })
            }
            
            print("async done")
            
        }
        
    }
    
}
