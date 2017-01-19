//
//  NewsParser.swift
//  Pattonville-School-District-App
//
//  Created by Joshua Zahner on 1/19/17.
//  Copyright © 2017 Joshua Zahner. All rights reserved.
//

import UIKit

class NewsParser: NSObject, XMLParserDelegate{
    
    var newsReel: NewsReel!
    var schools = SchoolsArray.getSubscribedSchools()
    
    var element: String = ""
    var articleTitle: String = ""
    var articleDate: String = ""
    
    init(newsReel: NewsReel){
        self.newsReel = newsReel
    }
    
    func addNewsReel(newsReel: NewsReel){
        self.newsReel = newsReel
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if (elementName as NSString).isEqual(to: "item"){
            articleTitle = ""
            articleDate = ""
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title"{
            articleTitle = string
        }else if element == "pubDate"{
            articleDate = string
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        var newsItem: NewsItem?
        
        if (elementName as NSString).isEqual(to: "item") {
            if !articleTitle.isEqual(nil) && !articleDate.isEqual(nil) {
                newsItem = NewsItem(title: articleTitle, the_date: articleDate)
            }else{
                newsItem = nil
            }
            
            newsReel.addNews(newsItem: newsItem!)
        }
    }
    
    
    func beginParseing(url: URL){
        
        var parser = XMLParser()
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        
        
    }
    
    func getDataInBackground(completionHandler: (() -> Void)?){
        
        DispatchQueue.global(qos: .background).async {
            
            for school in self.schools{
                self.beginParseing(url: URL(string: school.newsURL)!)
            }
            
            DispatchQueue.main.async {
                completionHandler?()
            }
            
        }
        
    }
    
    
}
