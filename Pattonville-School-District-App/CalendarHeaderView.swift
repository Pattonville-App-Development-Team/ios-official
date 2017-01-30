//
//  CalendarHeaderView.swift
//  Pattonville School District App
//
//  Created by Developer on 10/27/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarHeaderView: JTAppleHeaderView{
    
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var backOneMonth: UIButton!
    @IBOutlet var forwardOneMonth: UIButton!
    
    /// Defines how the header cell should initally appear on screen
    /// - date: the date correlated with a given cell
 
    func setupCellBeforeDisplay(date: Date) {
        // Setup Cell text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let month = dateFormatter.string(from: date)
        
        monthLabel.text = "\(month)"
        monthLabel.textColor = .white
    }
    
    
}
