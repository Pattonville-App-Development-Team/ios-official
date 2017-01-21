//
//  NewsViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 9/28/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit
import iCarousel

class NewsViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var vwCarousel: iCarousel!
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
        
        schools = SchoolsArray.getSubscribedSchools()
        parser = NewsParser(newsReel: newsReel)
        
        carouselWidth = UIScreen.main.bounds.size.width;
        carouselHeight = vwCarousel.bounds.size.height;
        
        images.append([circle, "Circle"])
        images.append([java, "java"])
        images.append([lines, "lines"])
        images.append([natureDear, "Deer"])
        images.append([illusion, "Illusion"])
        images.append([diamond, "Diamond"])
        
        
        vwCarousel.type = iCarouselType.linear
        vwCarousel.isPagingEnabled = true
        vwCarousel.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = .red
        self.refreshControl.tintColor = .white
        self.refreshControl.addTarget(self, action: #selector(NewsViewController.refreshData), for: UIControlEvents.valueChanged)
        
        
        var carouselTimer: Timer!
        
        carouselTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        
    }
    
    func scroll(){
        vwCarousel.scroll(byNumberOfItems: 1, duration: 2.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE VIEW STUFF
    
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
        cell.image_view.image = UIImage(named: "flowers")
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewsDetailViewSegue"{
            let destination = segue.destination as! NewsDetailViewController
            destination.news = newsReel.news[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    //CAROUSEL STUFF
    
    /// Defines the number of elements present in the carousel
    ///
    /// - parameter carousel: The news screen carousel used to display clickable stories
    ///
    /// - returns: the number of images to have in the carousel from the images array
    func numberOfItems(in carousel: iCarousel) -> Int{
        return images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        
        var view: UIView
        var imageView: UIImageView
        var captionView: UIView
        var captionLabel: UILabel
        
        // Create new UIView the same dimensions as the carousel view
        view = UIView(frame: CGRect(x: 0, y: 0, width: carouselWidth, height: 200));
        let viewHeight = view.bounds.size.height
        
        //Create new UIImageView 30 units shorter than the main view. Set image content mode to Aspect Fill. Clip to bounds.
        imageView = UIImageView(frame: CGRect(x:0, y:0, width: carouselWidth, height: viewHeight))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        captionView = UIView(frame: CGRect(x: 0, y: imageView.bounds.size.height - 30, width: carouselWidth, height: 30))
        captionView.backgroundColor = .black;
        captionView.alpha = 0.5
        
        //Create new UILabel at the bottom of the view. Set textColor to black.
        captionLabel = UILabel(frame: CGRect(x: 10, y: 0, width: carouselWidth, height: 30))
        captionLabel.textColor = UIColor.white
        
        
        imageView.image = images[index][0] as? UIImage
        captionLabel.text = images[index][1] as? String
        
        //Add imageView and label to main view as subviews
        
        vwCarousel.addSubview(view)
        
        view.addSubview(imageView)
        imageView.addSubview(captionView)
        captionView.addSubview(captionLabel)
        
        //return main view as the
        return view;
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if(option == iCarouselOption.wrap){
            return 1.0
        }
        return value
        
    }
    
    func refreshData(){
        parser.getDataInBackground(completionHandler: {
            print("REFRESHING")
            self.tableView.reloadData()
        })
        
        self.refreshControl.endRefreshing()
    }

    
}


