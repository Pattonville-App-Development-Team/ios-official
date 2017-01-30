//
//  FirstViewController.swift
//  Pattonville School District App
//
//  Created by Joshua Zahner on 9/27/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import iCarousel

class PSDViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var homeCarousel: iCarousel!
    @IBOutlet var tableView: UITableView!
    
    var newsReel: NewsReel!
    
    var carouselWidth: CGFloat = 0
    var carouselHeight: CGFloat = 0
    
    var images : [[Any]] = []
    
    let circle = #imageLiteral(resourceName: "circle.jpg")
    let java = #imageLiteral(resourceName: "java.jpg")
    let lines = #imageLiteral(resourceName: "lines.jpg")
    let natureDear = #imageLiteral(resourceName: "nature- dear.jpg")
    let illusion = #imageLiteral(resourceName: "illusion.jpg")
    let diamond = #imageLiteral(resourceName: "diamond.jpg")
    
    var schools: [School] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Width of height of the carousel. Used in later calculations
        carouselWidth = UIScreen.main.bounds.size.width;
        carouselHeight = homeCarousel.bounds.size.height;
        
        images.append([circle, "Circle"])
        images.append([java, "java"])
        images.append([lines, "lines"])
        images.append([natureDear, "Deer"])
        images.append([illusion, "Illusion"])
        images.append([diamond, "Diamond"])
        
        homeCarousel.type = iCarouselType.linear
        homeCarousel.isPagingEnabled = true
        homeCarousel.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var carouselTimer: Timer!
        carouselTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)

        let newsParser = NewsParser(newsReel: newsReel, schools: schools)
        
        newsParser.getDataInBackground(completionHandler: {
            self.tableView.reloadData()
        })
        
        
    }
    
    func scroll(){
        homeCarousel.scroll(byNumberOfItems: 1, duration: 2.0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        tableView.reloadData()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //***************************** TABLE VIEW STUFF *****************************\\
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /*func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["Recent News", "Upcoming Events", "Pinned Events"]
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let sectionTitles = ["Recent News", "Upcoming Events", "Pinned Events"]
        
        var view: UIView
        var label: UILabel
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 22))
        
        view.backgroundColor = UIColor(red:0.00, green:0.48, blue:0.20, alpha:1.0)
        
        label = UILabel(frame: CGRect(x: 15, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        label.text = sectionTitles[section]
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .white
        
        view.addSubview(label)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        
        if newsReel.news.count > 0{
            let newsItem = newsReel.news[indexPath.row]
            
            cell.title.text = newsItem.title
            cell.date.text = newsItem.dateString
            cell.school.backgroundColor = newsItem.school.color
        }
        
        return cell
        
    }
    
    //***************************** CAROUSEL STUFF *****************************\\
    
    /// Defines the number of elements present in the carousel
    ///
    /// - parameter carousel: The home screen carousel used to display clickable stories
    ///
    /// - returns: the number of images to have in the carousel from the images array
    func numberOfItems(in carousel: iCarousel) -> Int{
        return images.count
    }
    
    //Defines the look of carousel items
    /// Builds a carousel of images for the Home Storyboard
    ///
    /// - parameter carousel: The home screen carousel used to display clickable stories
    /// - parameter index:    the index of the story in the carousel
    /// - parameter view:     View that is being cycled in the carousel
    ///
    /// - returns: mainView which contains the carousel item, that has the image of story, the bar on the image and the text on the bar
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        //print(index);
        
        //Initialization of views
        var mainView: UIView
        var imageView: UIImageView
        var captionView: UIView
        var captionLabel: UILabel
        
        // Create new UIView the same dimensions as the carousel view
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: carouselWidth, height: 200));
        let mainViewHeight = mainView.bounds.size.height
        
        //Create new UIImageView the same dimensions as the mainView. Set image content mode to Aspect Fill. Clip to bounds.
        imageView = UIImageView(frame: CGRect(x:0, y:0, width: carouselWidth, height: mainViewHeight))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        //Create new UIView to hold captionLabel at the bottom of the imageView that is 30pts tall
        captionView = UIView(frame: CGRect(x: 0, y: imageView.bounds.size.height - 30, width: carouselWidth, height: 30))
        captionView.backgroundColor = .black;
        captionView.alpha = 0.5
       
        //Create new UILabel indented 10pts from the left side of the captionView
        captionLabel = UILabel(frame: CGRect(x: 10, y: 0, width: carouselWidth - 20, height: 30))
        captionLabel.textColor = UIColor.white
        
        
        imageView.image = images[index][0] as? UIImage
        captionLabel.text = images[index][1] as? String
        
        //Add imageView to the mainView container
        mainView.addSubview(imageView)
        
        //Add captionView to the imageView container
        imageView.addSubview(captionView)
        
        //Add captionLabel to the captionView container
        captionView.addSubview(captionLabel)
        
        //Add mainView to the carousel view container
        homeCarousel.addSubview(mainView)
    
        //return main view as the
        return mainView;
    }
    
    //Creates wrapping functionality for carousel
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if(option == iCarouselOption.wrap){
            return 1.0
        }
        return value
        
    }


}

