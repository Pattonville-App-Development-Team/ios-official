//
//  NewsDetailViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 10/4/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import Alamofire

/// The ViewController for the View that appears after a user selects a news story in the main News page or from the home page
class NewsDetailViewController: UIViewController, UIWebViewDelegate{
    
    /// The news story that is displayed on this page
    var news: NewsItem!
    
    /// The image at the top of the news article before the text
    @IBOutlet var titleLabel: UILabel!
    /// The Label below the title that displays the date of the news article
    @IBOutlet var date: UILabel!
    @IBOutlet var webView: UIWebView!
    /// The View used to create the identifying circle containing the schools color
    @IBOutlet var schoolView: UIView!
    /// Goes on top of school UIView and displays the shortName of the school associated with the news story
    @IBOutlet var schoolName: UILabel!
    
    @IBOutlet var webviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = news.title
        
        titleLabel.text = news.title
        date.text = news.dateString
        
        titleLabel.layoutIfNeeded()
        date.layoutIfNeeded()
        
        schoolView.layer.cornerRadius = schoolView.frame.height/2
        schoolView.backgroundColor = news.school.color
        schoolName.text = news.school.shortName
        
        webView.scrollView.isScrollEnabled = false;
        webView.delegate = self
        
        headerViewHeightConstraint.constant = titleLabel.frame.height + date.frame.height + 30
        
       
        /// The button used to open the Action menu at the top right of the Navigation bar
        let rightNavigationBarActionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(NewsDetailViewController.shareButtonClicked(_:)))
        
        
        self.navigationItem.rightBarButtonItem = rightNavigationBarActionButton
        
        if news.content == nil{
            getHTML()
        }else{
            webView.loadHTMLString(news.content!, baseURL: nil)
        }
        
        
        
        //content.text = news.content
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webviewHeightConstraint.constant = webView.scrollView.contentSize.height
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        print("LINK CLICKED")
        
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    
    /// Submits a GET request to a URL and is returned the HTML of the webpage
    
    func getHTML(){
        
        var contentString = "<style> font{font-family: 'Arial' !important; font-size: 0.85em !important;} img{width: 100% !important; height: auto !important;} tr:first-of-type, tr:last-of-type{display: none !important}</style>";
        
        Alamofire.request(news.url).responseString(completionHandler: { response in
            
            if let html = response.result.value {
                
                contentString.append(html)
                contentString = contentString.replacingOccurrences(of: "-Read-More-", with: "").replacingOccurrences(of: "-End-", with: "").replacingOccurrences(of: "â", with: "\"")
                
                self.news.content = contentString
                
                self.webView.loadHTMLString(contentString, baseURL: nil)
            }
            
        })
        
    }
    
     /// Opens Action activity that includes sharing options and copy and add to reading list actions
     ///
     /// - Parameter sender: the action icon at the top right of the NewsDetailView Navigation bar
     @objc func shareButtonClicked(_ sender: UIBarButtonItem) {
        let textToShare = news.title
        
        if let myWebsite = NSURL(string: news.sharingLinkURL){
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = schoolView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
}
