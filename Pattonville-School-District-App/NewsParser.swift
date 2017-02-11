//
//  NewsParser.swift
//  Pattonville-School-District-App
//
//  Created by Joshua Zahner on 1/19/17.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class NewsParser: NSObject, XMLParserDelegate{
    
    var news: NewsReel! = NewsReel.instance
    var schools: [School] = SchoolsArray.getSubscribedSchools()
    var school: School? = nil
    
    var element: String = ""
    var articleTitle: String = ""
    var articleDate: String = ""
    var articleURL: String = ""
    var id: String = ""
    
    /// Updates the school list for the parser to parse from
    ///
    /// - schools: the array of schools to parse from (SchoolsArray.getSubscribedSchools())
    func updateSchools(schools: [School]){
        self.schools = schools
    }
    
    /// When the parser finds the beginning of an element in XML
    ///
    /// - parser: the parser to use
    /// - elementName: the name of the XML element you are looking for
    /// - nameSpaceURI: the XML namespace to use
    /// - qName: 
    /// - attributeDict: a dictionary of XML attributes associated with the current element
    ///
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if (elementName as NSString).isEqual(to: "item"){
            articleTitle = ""
            articleDate = ""
            articleURL = ""
            id = ""
        }else if (elementName as NSString).isEqual(to: "source"){
            
            //Build up a three letter identifier for the school being parsed from
            
            let sourceURL = attributeDict["url"]
            
            var name = ""
            let indexOne = sourceURL?.index(articleURL.startIndex, offsetBy: 23)
            let indexTwo = sourceURL?.index(articleURL.startIndex, offsetBy: 24)
            let indexThree = sourceURL?.index(articleURL.startIndex, offsetBy: 25)
            
            name.append((sourceURL?.characters[indexOne!])!)
            name.append((sourceURL?.characters[indexTwo!])!)
            name.append((sourceURL?.characters[indexThree!])!)
            
            school = SchoolsArray.getSchoolByName(name: name)
        }
        
        
    }
    
    /// When the parser is between start and end XML tags
    ///
    /// - parser: the parser to use
    /// - string: the string between the start and end element tags
    ///
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title"{
            articleTitle = string
        }else if element == "pubDate"{
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy kk:mm:ss Z"
            
            var dateComponent = DateComponents()
            dateComponent.year = -1
            
            let lastYear = NSCalendar(calendarIdentifier: .gregorian)?.date(byAdding: dateComponent, to: Date(), options: [])
            
            if formatter.date(from: string)! < lastYear!{
                parser.abortParsing()
            }else{
                articleDate = string
            }
            
        }else if element == "link"{
            articleURL = string
        }else if element == "guid"{
            id = string
        }
    }
    
    /// When the parse finds the end of an element
    ///
    /// - parser: the parser to use
    /// - elementName: the name of the XML element you are looking for
    /// - nameSpaceURI: the XML namespace to use
    /// - qName:
    ///
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        var newsItem: NewsItem?
        
        if (elementName as NSString).isEqual(to: "item") {
            if !articleTitle.isEqual(nil) && !articleDate.isEqual(nil) && !articleURL.isEqual(nil) {
                newsItem = NewsItem(id: id, title: articleTitle, the_date: articleDate, url: articleURL, school: school!)
            }else{
                newsItem = nil
            }
            
            news.addNews(newsItem: newsItem!)
        }
    }
    
    /// Start the process of processing an XML file (parser.parse() handles this ability)
    ///
    /// - url: the external URL to parse from
    ///
    func beginParseing(url: URL){
        
        var parser = XMLParser()
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        
    }
    
    /// Parses news events on the background thread
    ///
    /// - completionHandler: function to undertake after completeing background tasks
    ///
    func getDataInBackground(completionHandler: (() -> Void)?){
        
        DispatchQueue.global(qos: .background).async {
            
            for school in self.schools{
                
                self.beginParseing(url: URL(string: school.newsURL)!)
                
                self.news.allNews = self.news.allNews.filter({
                    return SchoolsArray.getSubscribedSchools().contains($0.school)
                }).sorted(by: {
                    $0.date > $1.date
                })
                
                DispatchQueue.main.async {
                    completionHandler?()
                }
                
            }
            
        }
        
    }
    
}
