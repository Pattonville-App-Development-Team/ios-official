//
//  NewsViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/28/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    
    var carouselWidth: CGFloat = 0
    var carouselHeight: CGFloat = 0
    
    var newsReel: NewsReel!
    var schools: [School]!
    var parser: NewsParser!
    
    var images : [[Any]] = []
    
    let circle = #imageLiteral(resourceName: "circle.jpg")
    let java = #imageLiteral(resourceName: "java.jpg")
    let lines = #imageLiteral(resourceName: "lines.jpg")
    let natureDear = #imageLiteral(resourceName: "nature- dear.jpg")
    let illusion = #imageLiteral(resourceName: "illusion.jpg")
    let diamond = #imageLiteral(resourceName: "diamond.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.append([circle, "Circle"])
        images.append([java, "java"])
        images.append([lines, "lines"])
        images.append([natureDear, "Deer"])
        images.append([illusion, "Illusion"])
        images.append([diamond, "Diamond"])
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        self.refreshControl.tintColor = .white
        self.refreshControl.addTarget(self, action: #selector(NewsViewController.refreshData), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            tableView.addSubview(refreshControl)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        schools = SchoolsArray.getSubscribedSchools()
        parser = NewsParser(newsReel: newsReel, schools: schools)
        
        refreshData()
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewsDetailViewSegue"{
            let destination = segue.destination as! NewsDetailViewController
            destination.news = newsReel.news[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    // TABLE VIEW STUFF
    
    /// Gives the number of rows needed for the table view under the carousel
    ///
    /// - parameter tableView: the TableView that displays the short news info pieces under the carousel
    /// - parameter section:   the number of sections in the Table View, is 1
    ///
    /// - returns: the number of news stories in the newsReel used to populated the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsReel.news.count
    }
    
   
    /// Method to create the cells for the table view under the carousel in News
    ///
    /// - parameter tableView: the table view under the carousel in News
    /// - parameter indexPath: the row the user selects on the table view under the carousel in News
    ///
    /// - returns: none
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        
        let newsItem = newsReel.news[indexPath.row]
        
        cell.title.text = newsItem.title
        cell.date.text = newsItem.dateString
        
        cell.school.layer.cornerRadius = cell.school.frame.height/2
        cell.school.backgroundColor = newsItem.school.color
        cell.schoolName.text = newsItem.school.shortName
        
        return cell
        
    }
    
    // PRIVATE FUNCTIONS
    
    //Refreshes the list of news articles
    @objc private func refreshData(){
        
        parser.updateSchools(schools: schools)
        
        parser.getDataInBackground(completionHandler: {
            print("REFRESHING")
            
            self.newsReel.news.sort(by: {
                return $0.date > $1.date
            })
            
            self.tableView.reloadData()
        })
        
        
        self.refreshControl.endRefreshing()
    }

    
}


