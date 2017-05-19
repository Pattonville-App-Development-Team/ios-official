//
//  School.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/16/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import MXLCalendarManager

class School: NSObject, NSCoding {
 
    var name: String
    var shortName: String
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
    var newsURL: String
    var eventsList: [Event]
    var staffArray: [StaffMember]
    var sharingLinksURL: String
    var websiteURL: String
    var rank: Int
    
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
    /// - parameter staffArray:       Array of staff members to be used in Directory of School being initialized
    ///
    /// - parameter calendarURL:      .ics calendar file remote location
    /// - parameter color:            The Color used to identify the school throughout the app
    
    init(name: String,
         shortname: String,
         address: String,
         city: String, state: String, zip: String,
         mainNumber: String, attendanceNumber: String, faxNumber: String,
         schoolPicture: String,
         peachjarURL: String,
         nutriSliceURL: String,
         isSubscribedTo: Bool, color: UIColor,
         calendarURL: String,
         newsURL: String,
         staffArray: [StaffMember],
         sharingLinksURL: String,
         websiteURL: String,
         rank: Int) {
        
            self.name = name
            self.shortName = shortname
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
            self.staffArray = staffArray
            self.newsURL = newsURL

            self.eventsList = []
            self.sharingLinksURL = sharingLinksURL
        
            self.websiteURL = websiteURL
        
            self.rank = rank
        
        
    }
    
    required init(coder aDecoder: NSCoder){
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.shortName = aDecoder.decodeObject(forKey: "shortname") as! String
        self.address = aDecoder.decodeObject(forKey: "address") as! String
        self.city = aDecoder.decodeObject(forKey: "city") as! String
        self.state = aDecoder.decodeObject(forKey: "state") as! String
        self.zip = aDecoder.decodeObject(forKey: "zip") as! String
        self.mainNumber = aDecoder.decodeObject(forKey: "main_number") as! String
        self.attendanceNumber = aDecoder.decodeObject(forKey: "attendance_number") as! String
        self.faxNumber = aDecoder.decodeObject(forKey: "fax_number") as! String
        self.schoolPicture = aDecoder.decodeObject(forKey: "picture") as! String
        self.peachjarURL = aDecoder.decodeObject(forKey: "peachjar") as! String
        self.nutriSliceURL = aDecoder.decodeObject(forKey: "nutrislice") as! String
        self.isSubscribedTo = aDecoder.decodeObject(forKey: "subscribed") as! Bool
        self.color = aDecoder.decodeObject(forKey: "color") as! UIColor
        self.calendarURL = aDecoder.decodeObject(forKey: "calendar")  as! String
        self.staffArray = aDecoder.decodeObject(forKey: "staff") as! [StaffMember]
        self.newsURL = aDecoder.decodeObject(forKey: "news")  as! String
        self.eventsList = aDecoder.decodeObject(forKey: "events") as! [Event]
        self.sharingLinksURL = aDecoder.decodeObject(forKey: "sharingsURL") as! String
        self.websiteURL = aDecoder.decodeObject(forKey: "websiteURL") as! String
        self.rank = Int(aDecoder.decodeInt64(forKey: "rank"))
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.shortName, forKey: "shortname")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.state, forKey: "state")
        aCoder.encode(self.zip, forKey: "zip")
        aCoder.encode(self.mainNumber, forKey: "main_number")
        aCoder.encode(self.attendanceNumber, forKey: "attendance_number")
        aCoder.encode(self.faxNumber, forKey: "fax_number")
        aCoder.encode(self.schoolPicture, forKey: "picture")
        aCoder.encode(self.peachjarURL, forKey: "peachjar")
        aCoder.encode(self.nutriSliceURL, forKey: "nutrislice")
        aCoder.encode(self.isSubscribedTo, forKey: "subscribed")
        aCoder.encode(self.color, forKey: "color")
        aCoder.encode(self.calendarURL, forKey: "calendar")
        aCoder.encode(self.staffArray, forKey: "staff")
        aCoder.encode(self.newsURL, forKey: "news")
        aCoder.encode(self.eventsList, forKey: "events")
        aCoder.encode(self.sharingLinksURL, forKey: "sharingURL")
        aCoder.encode(self.websiteURL, forKey: "websiteURL")
        aCoder.encode(self.rank, forKey: "rank")
    }
    
    /// Gets calendar data from calendarURL for the school
    /// - onSuccess: completion handler called upon succesful downloading of calendar data from the URL (the '@escaping' syntax id required for nested closures as of Swift 3.0)
    /// - onFailure: completion handler called upon the rendering of an error in the downloading process (the '@escaping' syntax id required for nested closures as of Swift 3.0)
    
    func getCalendarData(onSucces: @escaping (MXLCalendar?) -> Void, onError: @escaping (Error?) -> Void){
        
        let mxlCalendarManager = MXLCalendarManager()
        
        mxlCalendarManager.scanICSFile(atRemoteURL: URL(string: calendarURL), withCompletionHandler: {
            (calendar, error) -> Void in
            
            if error == nil{
                onSucces(calendar)
                
            }else{
                onError(error)
                
            }
            
        })
        
    }
    
    static func == (lhs: School, rhs: School) -> Bool{
        return lhs.name == rhs.name
    }

    
}
