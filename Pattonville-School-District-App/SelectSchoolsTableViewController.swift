//
//  SelectSchoolsViewController.swift
//  Pattonville School District App
//
//  Created by Micah Thompkins on 11/16/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//
import UIKit
import Firebase

/// The TableViewController for selecting which schools a user wants to be subscribed to
class SelectSchoolsTableViewController: UITableViewController{
   
    /// Set up how the tableView appears on screen
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialSelectSchoolsTableViewCotroller()
        
        tableView.delegate = self
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Give the number of rows used in the SelectSchoolsTableView
    ///
    /// - parameter tableView: the SelectSchoolsTableView
    /// - parameter section:   number of sections, is 1
    ///
    /// - returns: A count from the schools array that gives the number of schools.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SchoolsArray.getSchools().count
        
    }
    
    /// Populates the Prototype cells of the SelectSchoolsTableView with the School name, color, and switch value
    ///
    /// - parameter tableView: the SelectSchoolsTableView
    /// - parameter indexPath: the current row it is populating
    ///
    /// - returns: the completed cell populated with the school name, color, and switch to determine wheter a user is subscribed or not
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSchoolsCell",
                                                 for: indexPath) as! SelectSchoolsTableCell
        setUpSelectSchoolsCell(row: indexPath.row, selectSchoolCell: cell)
        cell.schoolEnabledSwitch.tag = indexPath.row;
        cell.schoolEnabledSwitch.addTarget(self, action: #selector(SelectSchoolsTableViewController.switchIsChanged(sender:)), for: UIControlEvents.valueChanged)
        return cell
        
    }
    
    /// The method that activates when the schoolEnabledSwitch is activated in SelectSchoolsTableView. Gets the school from the tableVeiw cellForRowAt method with the tag and then sets the School's isSubscribedTo value to the opposite of its current value. Then saves the data using UserDefaults and the key of the school name.
    ///  set the Done button to appear on the selectSchoolsTableViewController the first time the application is opened
    func tutorialSelectSchoolsTableViewCotroller(){
        let selectSchoolsOpenedBefore = UserDefaults.standard.bool(forKey: "selectSchoolsOpenedBefore")
        if !selectSchoolsOpenedBefore{
            let rightNavigationBarDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector (SelectSchoolsTableViewController.goToHomeViewController(_:)))
        
            self.navigationItem.rightBarButtonItem = rightNavigationBarDoneButton
            let alert = UIAlertController(title: "Please select schools", message: "After selecting schools you will be able to receieve notifications, view calendar events, and view news stories.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss ", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "selectSchoolsOpenedBefore")
            
        }
    }
    
    
    /// The method to set up the visuals of the selectSchoolTableCell
    ///
    /// - Parameters:
    ///   - row: The row that the cell is being set in
    ///   - selectSchoolCell: the actual cell being set up
    func setUpSelectSchoolsCell(row: Int, selectSchoolCell: SelectSchoolsTableCell){
    
        let school = SchoolsArray.getSchools()[row]
        selectSchoolCell.schoolNameLabel.text = school.name
        selectSchoolCell.schoolColorView.backgroundColor = school.color
        selectSchoolCell.schoolEnabledSwitch.setOn(school.isSubscribedTo, animated: false)
        selectSchoolCell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    /// Opens the UITabBarControlle that contains all of the project and hides the current Navgation Bar
    ///
    /// - Parameter sender: the Done button that shows upon the Navigation Bar
    func goToHomeViewController(_ sender: UIBarButtonItem){
        let viewController = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 51/255.0, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(viewController, animated:true)
        
        NewsReel.instance.getInBackground(beforeStartHandler: nil, onCompletionHandler: nil)
        Calendar.instance.getEvents(completionHandler: nil)
        
    }
    /// The method that activates when the schoolEnabledSwithc is activated in SelectSchoolsTableView. Gets the school from the tableVeiw cellForRowAt method with the tag and then sets the School's isSubscribedTo value to the opposite of its current value. Then saves the data using UserDefaults and the key of the school name.
    ///
    /// - Parameter sender: The school selescted switch
    func switchIsChanged(sender: UISwitch){
        let school = SchoolsArray.getSchools()[sender.tag]
        school.isSubscribedTo = !school.isSubscribedTo
        
        UserDefaults.standard.set(school.isSubscribedTo, forKey: school.name)
        print("Saved \(school.name)'s isSubscribedTo bool val to \(UserDefaults.standard.bool(forKey: school.name))")
        for school in SchoolsArray.allSchools {
            print(school.isSubscribedTo)
            
        }
        
        
        if UserDefaults.standard.bool(forKey: school.name){
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\(school.name.replacingOccurrences(of: " ", with: "-"))")
            print("SUBSCRIBING TO \(school.name.replacingOccurrences(of: " ", with: "-"))")
        }else{
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\(school.name.replacingOccurrences(of: " ", with: "-"))")
        }
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/District")
        FIRMessaging.messaging().subscribe(toTopic: "/topics/test")
        
        
        let subscribed = SchoolsArray.getSubscribedSchools()
        
        if(subscribed.contains(SchoolsEnum.bridgewayElementary) || subscribed.contains(SchoolsEnum.drummondElementary) || subscribed.contains(SchoolsEnum.parkwoodElementary) || subscribed.contains(SchoolsEnum.remingtonTraditional) || subscribed.contains(SchoolsEnum.roseAcresElementary) || subscribed.contains(SchoolsEnum.willowBrookElementary)){
            
            FIRMessaging.messaging().subscribe(toTopic: "/topics/All-Elementary-Schools")
            
        }else{
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/All-Elementray-Schools")
        }
        
        if(subscribed.contains(SchoolsEnum.heightsMiddleSchool) || subscribed.contains(SchoolsEnum.holmanMiddleSchool) || subscribed.contains(SchoolsEnum.remingtonTraditional)){
            
            FIRMessaging.messaging().subscribe(toTopic: "/topics/All-Middle-Schools")
            
        }else{
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/All-Middle-Schools")
        }
        
        
    }
    
  
  
}

