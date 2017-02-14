//
//  NewsReel.swift
//  Pattonville School District App
//
//  Created by Developer on 10/5/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// Class for the array of NewsItems used in NewsViewController to display news
class NewsReel{
    
    static var instance: NewsReel = NewsReel()
    
    var allNews: [NewsItem]
    var filteredNews: [NewsItem]
    
    init(){
        allNews = []
        filteredNews = []
    }
    
    /// Adds a news item to the news array
    ///
    /// - newsItem: the news item to add
    ///
    func addNews(newsItem: NewsItem) {
        if !allNews.contains(newsItem){
            allNews.append(newsItem)
        }
    }
    
    func getNews(beforeStartHandler: (() -> Void)?, onCompletionHandler: (() -> Void)?){
        
        NewsParser().getDataInBackground(beforeStartHandler: {
            
            self.resetNews()
            beforeStartHandler?()
            
        }, onCompletionHandler: {
            
            self.allNews.sort(by: {
                $0.date > $1.date
            })
            
            onCompletionHandler?()
        })
        
    }
    
    func resetNews(){
        allNews = []
        filteredNews = []
    }
    
}
