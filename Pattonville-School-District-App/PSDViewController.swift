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
    
    @IBOutlet var settings: UIBarButtonItem!
    
    @IBAction func goToSettings(sender: UIBarButtonItem!){
        
        self.tabBarController?.selectedIndex = 3
        
        ((self.tabBarController?.viewControllers?[3] as! UINavigationController).viewControllers[0] as! MoreViewController).tableView(tableView, didSelectRowAt: IndexPath(row: 8, section: 0))
        
    }
    
    var news: NewsReel! = NewsReel.instance{
        didSet{
            if let table = tableView{
                table.reloadData()
            }
        }
    }
    var calendar: Calendar! = Calendar.instance{
        didSet{
            if let table = tableView{
                getUpcomingEvents()
                table.reloadData()
            }
        }
    }
    
    var carouselWidth: CGFloat = 0
    var carouselHeight: CGFloat = 0
    
    var images : [[Any]] = []
    
    let image0 = #imageLiteral(resourceName: "image.jpg")
    let image1 = #imageLiteral(resourceName: "image1.jpg")
    let image2 = #imageLiteral(resourceName: "image2.jpg")
    let image3 = #imageLiteral(resourceName: "image3.jpg")
    let image4 = #imageLiteral(resourceName: "image4.jpg")
    let image5 = #imageLiteral(resourceName: "image5.jpg")
    
    var prevSchools: [School]! = []
    var filteredEvents: [Event] = []
    
    let newsParser = NewsParser()
    let calendarParser = CalendarParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Width of height of the carousel. Used in later calculations
        carouselWidth = UIScreen.main.bounds.size.width;
        carouselHeight = homeCarousel.bounds.size.height;
        
        images.append([image0, ""])
        images.append([image1, ""])
        images.append([image2, ""])
        images.append([image3, ""])
        images.append([image4, ""])
        images.append([image5, ""])
        
        homeCarousel.type = iCarouselType.linear
        homeCarousel.isPagingEnabled = true
        homeCarousel.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "DateCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        tableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "NewsItemCell")
        
        
        Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let current = SchoolsArray.getSubscribedSchools()
        
        if current != prevSchools{
            
            /*calendar.getEvents(completionHandler: {
                self.tableView.reloadData()
            })*/
            
            /*news.getNews(beforeStartHandler: nil, onCompletionHandler: {
                self.tableView.reloadData()
            })*/
            
            prevSchools = current
            
        }
        
        getUpcomingEvents()

        tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //***************************** TABLE VIEW STUFF *****************************\\
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let sectionTitles = ["Recent News", "Upcoming Events", "Pinned Events"]
        
        var view: UIView
        var label: UILabel
        var seeMore: UIButton
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 22))
        
        view.backgroundColor = UIColor(red:0.00, green:0.48, blue:0.20, alpha:1.0)
        
        label = UILabel(frame: CGRect(x: 15, y: 2, width: view.bounds.size.width/2, height: view.bounds.size.height))
        label.text = sectionTitles[section]
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .white
        
        view.addSubview(label)
        
        seeMore = UIButton(frame: CGRect(x: view.bounds.size.width/1.75, y: 2, width: view.bounds.size.width/1.65, height: view.bounds.size.height))
        
        seeMore.setTitle("See More >", for: .normal)
        seeMore.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        seeMore.tag = section
        
        seeMore.addTarget(self, action: #selector(PSDViewController.goToView), for: .touchUpInside)
        
        view.addSubview(seeMore)

        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 60
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == 0{
            if news.allNews.count > 0 {
                
                let newsItem = news.allNews[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
                
                cell.setUp(news: newsItem)
                
                return cell
            
            }
        } else if section == 1{
            if filteredEvents.count > 0 {
                
                let event = filteredEvents[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
                
                print(event.date!)
                
                cell.setup(event: event, indexPath: indexPath, type: .normal)
                
                cell.pinButton.addTarget(self, action: #selector(PSDViewController.addEventToPinned), for: .touchUpInside)
                
                return cell
                
            }
        }else{
            if calendar.pinnedEvents.count > 0 {
                
                let event: Event!
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! DateCell
                
                if indexPath.row < calendar.pinnedEvents.count{
                    event = calendar.pinnedEvents[indexPath.row]
                    cell.setup(event: event, indexPath: indexPath, type: .normal)
                }else{
                    event = Event()
                    cell.setup(event: event, indexPath: indexPath, type: .empty)
                }
                
                cell.pinButton.addTarget(self, action: #selector(PSDViewController.removeEventFromPinned), for: .touchUpInside)
                
                return cell
                
            }
        }
        
        // return cell
        return UITableViewCell()
    }
    
 
    /// Defines preparation steps for segues leaving this view controller
    /// - segue: the segue that was triggered
    /// - sender: the object that triggered the segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailFromHome"{
            let destination = segue.destination as! CalendarEventDetailController
            let event = tableView.indexPathForSelectedRow?.row
            
            if tableView.indexPathForSelectedRow?.section == 1{
                destination.event = filteredEvents[event!]
            }else{
                destination.event = calendar.pinnedEvents[event!]
            }
            
        } else if segue.identifier == "NewsDetailFromHome" {
            let destination = segue.destination as! NewsDetailViewController
            destination.news = news.allNews[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    /// Defines the functionality of a selected cell in the table
    /// - tableView: the instance of the tableview onscreen
    /// - indexPath: the indexPath of the selected cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            performSegue(withIdentifier: "NewsDetailFromHome", sender: self)
        }else{
            performSegue(withIdentifier: "EventDetailFromHome", sender: self)
        }
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
        //imageView.addSubview(captionView)
        
        //Add captionLabel to the captionView container
        captionView.addSubview(captionLabel)
        
        //Add mainView to the carousel view container
        homeCarousel.addSubview(mainView)
    
        //return main view as the
        return mainView;
    }
    
    /// Creates wrapping functionality for carousel
    ///
    /// - carousel: the carousel object
    /// - option: the option we want to modify on our carousel
    /// - value: the default value of the option
    ///
    /// - returns the modified value/values of the carousel object
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if(option == iCarouselOption.wrap){
            return 1.0
        }
        return value
        
    }
    
    /// Scrolls the carousel by one item over the course of two seconds
    @objc private func scroll(){
        homeCarousel.scroll(byNumberOfItems: 1, duration: 2.0)
    }
    
    @objc private func addEventToPinned(){
        
        calendar.pinnedEvents.sort(by: {
            $0.date! < $1.date!
        })
        
        tableView.reloadData()
    }
    
    @objc private func removeEventFromPinned(){
        
        calendar.pinnedEvents.sort(by: {
            $0.date! < $1.date!
        })
        
        tableView.reloadData()
    }
    
    @objc private func goToView(sender: UIButton){
        
        self.tabBarController?.selectedIndex = sender.tag + 1
        
    }
    
    private func getUpcomingNews(){
        
        news.allNews.sort(by: {
            $0.date > $1.date
        })
        
    }
    
    private func getUpcomingEvents(){
        
        filteredEvents = calendar.allEvents.filter({
            return $0.date! > Date()
        })
        
        filteredEvents.sort(by: {
            $0.date! < $1.date!
        })
        
    }


}

