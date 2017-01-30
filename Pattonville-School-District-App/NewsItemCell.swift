//
//  NewsItemCell.swift
//  Pattonville School District App
//
//  Created by Developer on 10/5/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// Custom cell class for the TableView that displays the short info about each news story on the News Page under the News carousel
class NewsItemCell: UITableViewCell{
    
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var school: UIView!
    @IBOutlet var schoolName: UILabel!
    
    var newsItem: NewsItem!
    
    func setUp(){
        title.text = newsItem.title
        date.text = newsItem.dateString
        
        school.backgroundColor = newsItem.school.color
        school.layer.cornerRadius = school.frame.width/2
        
        schoolName.text = newsItem.school.shortName
    }
    
    
}
