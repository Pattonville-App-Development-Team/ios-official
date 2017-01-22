//
//  NewsItem.swift
//  Pattonville School District App
//
//  Created by Developer on 10/4/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// Class used to create NewsItems in NewsViewController
class NewsItem: Equatable{
    
    var title: String
    var content: String
    
    var date: Date
    var dateString: String
    
    var url: String
    var school: School
    
    var id: String
    
    /// Initializer to create individual NewsItems
    ///
    /// - parameter id:       the id of the news item
    /// - parameter title:    the title of the given NewsItem
    /// - parameter content:  the news story for the reader to absorb
    /// - parameter the_date: the date of the news story
    ///
    init(id: String, title: String, the_date: String, url: String, school: School){
        
        self.id = id
        
        self.title = title
        self.content = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy kk:mm:ss Z"
        
        self.date = dateFormatter.date(from: the_date)!

        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "EEE, MMMM dd, yyyy"
        self.dateString = dateStringFormatter.string(from: date)
        
        self.url = "http://fccms.psdr3.org/\(url)"
        self.content = ""
        self.school = school
        
    }
    
    /// Overrides the == method for comparison of news items
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool{
        return lhs.id == rhs.id
    }
    
}
