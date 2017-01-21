//
//  NewsDetailViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 10/4/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

/// The ViewController for the View that appears after a user selects a news story in the main News page
class NewsDetailViewController: UIViewController{
    
    var news: NewsItem!
    
    /// The image at the top of the news article before the text
    @IBOutlet var ivDisplayImage: UIImageView!
    @IBOutlet var content: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivDisplayImage.image = UIImage(named: "flowers")
        getHTML()
        
        print(news.content)
        content.text = news.content
        // Do any additional setup after loading the view.
    }

    func getHTML(){
        
        Alamofire.request(news.url).responseString(completionHandler: { response in
            
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        })
        
    }
    
    func parseHTML(html: String){
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            print("Parsing HTML")
            // Search for nodes by CSS selector
            print(doc.css("font"))
            
            var contentString = "";
            for text in doc.css("font"){
                contentString.append(text.text!)
            }
            
            print(contentString)
            
            news.content = contentString

            
        }
    }
    
}
