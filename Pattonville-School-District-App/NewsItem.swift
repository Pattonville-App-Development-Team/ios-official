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
    
    /// Initializer to create individual NewsItems
    ///
    /// - parameter title:    the title of the given NewsItem
    /// - parameter content:  the news story for the reader to absorb
    /// - parameter the_date: the date of the news story
    ///
    init(title: String, the_date: String){
        self.title = title
        self.content = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy kk:mm:ss Z"
        
        self.date = dateFormatter.date(from: the_date)!

        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "EEE, MMMM dd, yyyy"
        self.dateString = dateStringFormatter.string(from: date)
        
        
    }
    
}
