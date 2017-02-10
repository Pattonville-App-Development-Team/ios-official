//
//  NewsItemCell.swift
//  Pattonville School District App
//
//  Created by Developer on 10/5/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// Custom cell class for the TableView that displays the short info about each news story on the News Page under the News carousel
class NewsItemCell: UITableViewCell{
    
    /// Title of the news story
    @IBOutlet var title: UILabel!
    /// Date of the news story goes below the title
    @IBOutlet var date: UILabel!
    /// Identifying UIView for the school on the left of cell, is made a circle and background color set to the Schools identifying color
    @IBOutlet var school: UIView!
    /// Goes on top of school UIView and displays the shortName of the school associated with the news story
    @IBOutlet var schoolName: UILabel!
    
    var newsItem: NewsItem!
    
    func setUp(){
        title.text = newsItem.title
        date.text = newsItem.dateString
        
        school.backgroundColor = newsItem.school.color
        school.layer.cornerRadius = school.frame.height/2
        
        schoolName.text = newsItem.school.shortName
    }
    
    
}
