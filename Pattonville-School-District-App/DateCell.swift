//
//  DateCell.swift
//  Pattonville School District App
//
//  Created by Developer on 11/8/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell{
    
    var event: Event!
    
    @IBOutlet var title: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var schools: UILabel!
    @IBOutlet var pinButton: UIButton!
    
    @IBOutlet var schoolColorLine: UIView!
    
    @IBAction func setPinned(){
        
        pinButton.isSelected = !pinButton.isSelected
        event.pinned = !event.pinned

    }
    
    func setUp(indexPath: IndexPath){
        title.text = event.name
        location.text = event.location
        setTimes(start: event.startTime!, end: event.endTime!)
        
        if event.pinned{
            pinButton.isSelected = true
        }else{
            pinButton.isSelected = false
        }
        
        if(title.frame.height > 18){
            location.isHidden = true
        }
        
        schoolColorLine.backgroundColor = event.school.color
        
        pinButton.tag = indexPath.row;
        pinButton.addTarget(self, action: #selector(CalendarViewController.nowPinned(sender:)), for: UIControlEvents.touchUpInside);
        
    }
    
    private func setTimes(start: Date, end: Date){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        let startTimeString = formatter.string(from: start)
        let endTimeString = formatter.string(from: end)
        
        endTime.text = endTimeString
        startTime.text = startTimeString
        
        
    }
    
}
