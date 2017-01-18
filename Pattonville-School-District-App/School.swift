//
//  School.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/16/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit
import MXLCalendarManager

class School: NSObject {
 
    var name: String
    var address: String
    var city: String
    var state: String
    var zip: String
    var mainNumber: String
    var attendanceNumber: String
    var faxNumber: String
    var schoolPicture: String
    var peachjarURL: String
    var isSubscribedTo: Bool
    var color: UIColor
    var nutriSliceURL: String
    var calendarURL: String
    var eventsList: [Event]
    
    
    /// The School Object initializer, to be used in the Schools Enum
    ///
    /// - parameter name:             Name of School being initialized
    /// - parameter address:          Address of School being initialized
    /// - parameter city:             City of School being initialized
    /// - parameter state:            State of School being initialized
    /// - parameter zip:              Zip of School being initialized
    /// - parameter mainNumber:       Regular Contact number of School being initialized
    /// - parameter attendanceNumber: Attendance hotline of School being initialized
    /// - parameter faxNumber:        Fax Number of School being initialized
    /// - parameter //schoolPicture:  School Picture to be used in Directory of School being initialized
    /// - parameter peachjarURL:      PeachJar URL used in the PeachJar Feature of School being initialized
    /// - parameter nutriSliceURL:    NutriSlice URL used in the NutriSlice Feature, being intialized
    /// - parameter isSubscribedTo:   Boolean to determine whether or not a user is subscribed to a schools news feed, will be set based upon the switch in the SelectSchools feautre in Settings and then accessed for the news feed
    ///
    
    init(name: String,
         address: String,
         city: String, state: String, zip: String,
         mainNumber: String, attendanceNumber: String, faxNumber: String,
         schoolPicture: String,
         peachjarURL: String,
         nutriSliceURL: String,
         isSubscribedTo: Bool, color: UIColor,
         calendarURL: String) {
        
            self.name = name
            self.address = address
            self.city = city
            self.state = state
            self.zip = zip
            self.mainNumber = mainNumber
            self.attendanceNumber = attendanceNumber
            self.faxNumber = faxNumber
            self.schoolPicture = schoolPicture
            self.peachjarURL = peachjarURL
            self.nutriSliceURL = nutriSliceURL
            self.isSubscribedTo = isSubscribedTo
            self.color = color
            self.calendarURL = calendarURL
        
            self.eventsList = []
        
    }
    
    func getCalendarData(onSucces: @escaping (MXLCalendar?) -> Void, onError: @escaping (Error?) -> Void){
        
        let mxlCalendarManager = MXLCalendarManager()
        
        var theCalendar: MXLCalendar?
        
        mxlCalendarManager.scanICSFile(atRemoteURL: URL(string: calendarURL), withCompletionHandler: {
            (calendar, error) -> Void in
            
            if error == nil{
                theCalendar = calendar
                print("THE CALENDAR: \(theCalendar)")
                onSucces(calendar)
                
            }else{
                print("ERROR: \(error)")
                theCalendar = nil
                onError(error)
            }
            
        })
        
    }
    
}
