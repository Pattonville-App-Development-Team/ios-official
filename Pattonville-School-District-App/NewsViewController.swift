//
//  NewsViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/28/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    
    var carouselWidth: CGFloat = 0
    var carouselHeight: CGFloat = 0
    
    var news: NewsReel! = NewsReel.instance{
        didSet{
            if let table = tableView{
//                print("RELOADED IN DID SET")
                table.reloadData()
            }
        }
    }
    
    var parser: NewsParser!
    
    var prevSchools: [School] = []
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = []
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "NewsItemCell")
        
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
        
        if SchoolsArray.getSubscribedSchools() != prevSchools{
         
            news.getInBackground(beforeStartHandler: {
                self.tableView.reloadData()
            }, onCompletionHandler: {
                self.tableView.reloadData()
            })
            
            prevSchools = SchoolsArray.getSubscribedSchools()
            
        }
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewsDetailSegue"{
            let destination = segue.destination as! NewsDetailViewController
            
            if searchController.isActive && searchController.searchBar.text != ""{
                destination.news = news.filteredNews[(tableView.indexPathForSelectedRow?.row)!]
            }else{
                destination.news = news.allNews[(tableView.indexPathForSelectedRow?.row)!]
            }
            
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
        if searchController.isActive && searchController.searchBar.text != ""{
            return news.filteredNews.count
        }else{
            return news.allNews.count
        }
    }
    
   
    /// Method to create the cells for the table view under the carousel in News
    ///
    /// - parameter tableView: the table view under the carousel in News
    /// - parameter indexPath: the row the user selects on the table view under the carousel in News
    ///
    /// - returns: none
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        
        let newsItem: NewsItem?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            newsItem = news.filteredNews[indexPath.row]
        }else{
            newsItem = news.allNews[indexPath.row]
        }
        
        cell.setUp(news: newsItem!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NewsDetailSegue", sender: self)
    }
    
    
    func updateSearchResults(for: UISearchController) {
        
//        print(news.filteredNews.count)
        
        filterNewsForSearchText(searchText: searchController.searchBar.text!)
        
//        print(news.filteredNews.count)
        
    }
    
    // PRIVATE FUNCTIONS
    
    //Refreshes the list of news articles
    func refreshData(){
    
        news.getInBackground(beforeStartHandler: {
            self.tableView.reloadData()
        }, onCompletionHandler: {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
        
    }
    
    private func filterNewsForSearchText(searchText: String){
        
        news.filteredNews = news.allNews.filter({ newsItem in
            return newsItem.title.lowercased().contains(searchText.lowercased()) || newsItem.school.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        
    }

    
}


