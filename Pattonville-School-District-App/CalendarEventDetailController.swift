//
//  CalendarEventDetailController.swift
//  Pattonville School District App
//
//  Created by Joshua Zahner on 11/21/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit
import EventKit

class CalendarEventDetailController: UIViewController{
    
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventTime: UILabel!
    @IBOutlet var addToCalendar: UIButton!
    @IBOutlet var pinButton: UIButton!
    
    @IBAction func setPinned(){
        
        pinButton.isSelected = !pinButton.isSelected
        event.pinned = !event.pinned
        
    }
    
    @IBAction func add(sender: UIButton){
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            
            let ekEvent = EKEvent(eventStore: store)
            ekEvent.title = self.event.name!
            ekEvent.startDate = self.event.date!
            ekEvent.endDate = self.event.date!
            ekEvent.calendar = store.defaultCalendarForNewEvents
            
            do {
                try store.save(ekEvent, span: .thisEvent, commit: true)
                
                let alert = UIAlertController(title: "Event Added to Calendar", message: "The event \(ekEvent.title) was added to your calendar!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch {
                print(error)
            }
        }
    }
    
    var event: Event!
    
    ///Sets up the look of the ViewController upon loading. Sets the eventName, eventLocation, eventDate, and eventTime UILabels to the corresponding values of the event variable.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = event.name
        
        eventName.text = event.name
        eventLocation.text = event.location
        eventDate.text = event.dateString
        eventTime.text = event.timeString
        
        if event.pinned{
            pinButton.isSelected = true
        }else{
            pinButton.isSelected = false
        }
        
        print(event.school.name)
        
    }
    
}
