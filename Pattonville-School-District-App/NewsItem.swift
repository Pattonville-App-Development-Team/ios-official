//
//  NewsItem.swift
//  Pattonville School District App
//
//  Created by Developer on 10/4/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// Class used to create NewsItems in NewsViewController
class NewsItem: NSObject, NSCoding{
    
    var id: String
    var title: String
    var content: String?
    
    var date: Date
    var dateString: String
    
    var url: String
    var school: School
    var sharingLinkURL: String
    
    /// Initializer to create individual NewsItems
    ///
    /// - parameter id:       the id of the news item
    /// - parameter title:    the title of the given NewsItem
    /// - parameter content:  the news story for the reader to absorb
    /// - parameter the_date: the date of the news story
    /// - parameter school:   the school that the news Story is about
    ///
    init(id: String, title: String, the_date: String, url: String, school: School){
        
        self.id = id
        self.title = title
        
        self.content = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy kk:mm:ss Z"
        
        self.date = dateFormatter.date(from: the_date)!

        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "EEE, MMMM dd, yyyy"
        self.dateString = dateStringFormatter.string(from: date)
        
        self.url = "http://fccms.psdr3.org\(url)"
        self.school = school
        self.sharingLinkURL = school.sharingLinksURL + url
        
    }
    
    override init(){
        
        self.id = NSUUID().uuidString
        self.title = ""
        self.content = nil
        
        self.date = Date()
        self.dateString = ""
        
        self.url = ""
        self.school = SchoolsEnum.district
        self.sharingLinkURL = ""
        
    }
    
    required init(coder aDecoder: NSCoder){
        
        id = aDecoder.decodeObject(forKey: "id") as! String
        title = aDecoder.decodeObject(forKey: "title") as! String
        content = aDecoder.decodeObject(forKey: "content") as? String
        date = aDecoder.decodeObject(forKey: "date") as! Date
        dateString = aDecoder.decodeObject(forKey: "dateString") as! String
        
        url = aDecoder.decodeObject(forKey: "url") as! String
        school = SchoolsArray.getSchoolByName(name: aDecoder.decodeObject(forKey: "school") as! String)
        sharingLinkURL = aDecoder.decodeObject(forKey: "shareURL") as! String
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(dateString, forKey: "dateString")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(school.name, forKey: "school")
        aCoder.encode(sharingLinkURL, forKey: "shareURL")
    }
    
    /// Overrides the == method for comparison of news items
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool{
        return lhs.id == rhs.id
    }
    
}
