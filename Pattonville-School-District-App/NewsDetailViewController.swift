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
class NewsDetailViewController: UIViewController, UIWebViewDelegate{
    
    var news: NewsItem!
    
    /// The image at the top of the news article before the text
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var schoolView: UIView!
    @IBOutlet var schoolName: UILabel!
    
    @IBOutlet var webviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    
    //@IBOutlet var content: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = news.title

        titleLabel.text = news.title
        date.text = news.dateString
        
        schoolView.layer.cornerRadius = schoolView.frame.height/2
        schoolView.backgroundColor = news.school.color
        schoolName.text = news.school.shortName
        
        webView.scrollView.isScrollEnabled = false;
        webView.delegate = self
        
        headerViewHeightConstraint.constant = titleLabel.frame.height + date.frame.height + 30
        
        getHTML()

        //content.text = news.content
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        print("Web view did finish")
        
        print(webviewHeightConstraint.constant)
        
        webviewHeightConstraint.constant = webView.scrollView.contentSize.height
        
        print(webView.scrollView.contentSize.height)
        print(webviewHeightConstraint.constant)
        
    }
    

    /// Submits a GET request to a URL and is returned the HTML of the webpage

    func getHTML(){
        
        Alamofire.request(news.url).responseString(completionHandler: { response in
            
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        })
        
    }
    
    /// Parses the supplied HTML for all the text contained within <font></font> tags
    ///
    /// - html: the html string to parse (supploed by getHTML())
    ///
    func parseHTML(html: String){
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            var contentString = "<style> font{font-family: 'Arial' !important; font-size: 0.85em !important;} img{width: 100% !important; height: auto !important;}</style>";
            
            for text in doc.css("td").dropFirst(4).dropLast(2){
                contentString.append(text.innerHTML!)
                contentString.append("<br /><br />")
            }
            
            print(contentString)
            
            contentString = contentString.replacingOccurrences(of: "-Read-More-", with: "").replacingOccurrences(of: "-End-", with: "")
            
            webView.loadHTMLString(contentString, baseURL: nil)

            
        }
    }
    
}
