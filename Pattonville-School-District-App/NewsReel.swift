//
//  NewsReel.swift
//  Pattonville School District App
//
//  Created by Developer on 10/5/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// Class for the array of NewsItems used in NewsViewController to display news
class NewsReel{
    
    var news: [NewsItem] = [NewsItem]()
    
    func addNews(newsItem: NewsItem) {
        news.append(newsItem)
    }
    
    
    
}
