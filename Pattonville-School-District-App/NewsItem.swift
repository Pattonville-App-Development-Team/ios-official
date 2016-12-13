//
//  NewsItem.swift
//  Pattonville School District App
//
//  Created by Developer on 10/4/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// Class used to create NewsItems in NewsViewController
class NewsItem{
    
    var title: String
    var content: String
    
    var date: Date
    var dateString: String
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    
    let dateStringFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-DD-yyyy"
        return formatter;
    }()
    
    /// Initializer to create individual NewsItems
    ///
    /// - parameter title:    the title of the given NewsItem
    /// - parameter content:  the news story for the reader to absorb
    /// - parameter the_date: the date of the news story
    ///
    init(title: String, content: String, the_date: String){
        self.title = title
        self.content = content
        self.date = dateStringFormatter.date(from: the_date)!
        
        print(self.date)
        
        self.dateString = dateFormatter.string(from: date)
        
    }
    
}
