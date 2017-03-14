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
    
    /// The URL to the cache file
    let fileURL: NSURL = {
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let document = directories.first!
        
        return document.appendingPathComponent("newsitem.archive") as NSURL
        
    }()
    
    /// Initialize a new NewsReel by attempting to read from the cahe file
    init(){
        
        allNews = []
        filteredNews = []
        
        readFromFile()
        
    }
    
    /// Appends and array of news events to allEvents
    ///
    /// - news: an arrays of news items
    
    func appendNews(news: [NewsItem]){
        
        for item in news{
            addNews(newsItem: item)
        }
        
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
    
    /// Gets NewsEvents from the XML in background
    ///
    /// - beforeStartHandler: function to run prior to the start of parsing
    /// - onCompletionHandler: function to run on completion of parsing
    
    func getInBackground(beforeStartHandler: (() -> Void)?, onCompletionHandler: (() -> Void)?){
        
        let parser = NewsParser()
        
        parser.getDataInBackground(beforeStartHandler: {
            
            // Reset News to empty
            self.resetNews()
            
            beforeStartHandler?()
            
        }, onCompletionHandler: {
            
            // Sort News in reverse order
            self.allNews.sort(by: {
                $0.date > $1.date
            })
            
            // Save data to file
            let success = self.saveToFile()
            
            // If succesful save, store date in user defaults
            if success{
                UserDefaults.standard.set(Date(), forKey: "lastNewsUpdate")
            }
            
            onCompletionHandler?()
        })
    }
    
    /// Get NewsEvents from the most resonable source
    ///
    /// - beforeStartHandler: function to run prior to the start of parsing
    /// - onCompletionHandler: function to run on completion of parsing
    func getNews(beforeStartHandler: (() -> Void)?, onCompletionHandler: (() -> Void)?){
        
        let mostRecentSave: Date
        
        if let recent = UserDefaults.standard.object(forKey: "lastNewsUpdate") as! Date?{
            mostRecentSave = recent
        }else{
            mostRecentSave = Date()
        }
        
        var dateComponent = DateComponents()
        dateComponent.hour = -1
        
        let lastHour = NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: Date(), options: [])
        
        //Try to read from file, and then check if it added allNews
        if mostRecentSave < lastHour! || (!readFromFile() || allNews.count == 0){
//            print("Getting om Background")
            
            //Parse News from FCCMS
            getInBackground(beforeStartHandler: {
                beforeStartHandler?()
            }, onCompletionHandler: {
                onCompletionHandler?()
            })
            
        }
        
    }
    
    /// Save allNews to the Cache File
    /// - returns: if saving succeeded
    func saveToFile() -> Bool{
//        print("Saved to file \(fileURL.path!)")

        return NSKeyedArchiver.archiveRootObject(allNews, toFile: fileURL.path!)
    }
    
    /// Read data from cache file and append its contents into allNews
    /// - returns: if reading from the file succeeded
    func readFromFile() -> Bool{
        if let archived = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path!) as? [NewsItem]{
            
            if allNews.count < 1{
                appendNews(news: archived)
            }
            
            return true
        }
        
        return false
    }
    
    /// Resets news arrays to empty to stop duplication
    func resetNews(){
        allNews = []
        filteredNews = []
    }
    
}
