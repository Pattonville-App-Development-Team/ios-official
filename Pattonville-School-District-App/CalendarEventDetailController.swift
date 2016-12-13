//
//  CalendarEventDetailController.swift
//  Pattonville School District App
//
//  Created by Joshua Zahner on 11/21/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class CalendarEventDetailController: UIViewController{
    
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventTime: UILabel!
    
    var event: Event!
    
    ///Sets up the look of the ViewController upon loading. Sets the eventName, eventLocation, eventDate, and eventTime UILabels to the corresponding values of the event variable.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventName.text = event.name
        eventLocation.text = event.location
        eventDate.text = event.dateString
        eventTime.text = event.timeString
        
    }
    
}
