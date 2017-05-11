//
//  CalendarDateView.swift
//  Pattonville School District App
//
//  Created by Developer on 10/26/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import JTAppleCalendar

class CalendarDateView: JTAppleDayCellView{
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateDelineater: UIView!
    
    let todayBackgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 51/255.0, alpha: 1.0)
    let selectedBackgroundColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1)
    let unselectedBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    let delineatorColor = UIColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1)
    
    var normalDayColor = UIColor.black
    var weekendDayColor = UIColor.gray
    
    let calendar = Calendar.instance
    
    /// Defines how the date cell should initally appear on screen
    /// - cellState: the CellState for a given cell (used to decipher between weekdays and weekends)
    /// - date: the date correlated with a given cell
    
    func setup(cellState: CellState, date: Date) {
        // Setup Cell text
        
        configureView(cellState: cellState)
        
        if isToday(date: date){
            styleToday()
        }else{
            deselect(date: date, cellState: cellState)
        }
        
        
        styleDelineator(date: date)
        
    }
    
    /// Defines the text color of a given cell
    /// - cellState: the CellState of the given cell
    

    func configureView(cellState: CellState) {
        dateLabel.text = cellState.text
        if cellState.dateBelongsTo == DateOwner.thisMonth {
            dateLabel.textColor = normalDayColor
        } else {
            dateLabel.textColor = weekendDayColor
        }
        
        dateDelineater.layer.cornerRadius = dateDelineater.frame.width/2
        dateDelineater.backgroundColor = delineatorColor
        
    }
    
    /// Sets the look for the cell when it is selected
    /// - color: the color to set the background of the cell to
    
    func select(date: Date){
        
        if isToday(date: date){
            styleToday()
        }else{
            self.backgroundColor = selectedBackgroundColor
            dateLabel.textColor = .white
            dateDelineater.backgroundColor = .white
        }
        
        styleDelineator(date: date)
    }
    
    /// Sets the look for the cell when it is unselected
    /// - cellState: the CellState of the given cell (used to ensure the cell returns to its weekday/weekend state)
    
    func deselect(date: Date, cellState: CellState){
        self.backgroundColor = unselectedBackgroundColor
        configureView(cellState: cellState)
        dateDelineater.backgroundColor = delineatorColor
        
        styleDelineator(date: date)
        
    }
    
    func styleToday(){
        self.backgroundColor = todayBackgroundColor
        dateLabel.textColor = .white
        dateDelineater.backgroundColor = .white
    }
    
    /// Compares two dates for equality
    /// - date1: the first date
    /// - date2: the date to compare to
    
    func isToday(date: Date) -> Bool{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let theDate = dateFormatter.string(from: date)
        let today = dateFormatter.string(from: Date())
        
        if theDate.compare(today) == .orderedSame{
            return true
        }else{
            return false
        }
        
    }
    
    func styleDelineator(date: Date){
        
        if calendar.hasEvents(for: date){
            showDelineator()
        }else{
            hideDelineator()
        }
        
    }
    
    func showDelineator(){
        dateDelineater.alpha = 1
    }
    
    func hideDelineator(){
        dateDelineater.alpha = 0
    }
    
    
}
