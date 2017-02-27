//
//  SSDViewController.swift
//  Pattonville School District App
//


//  Created by Kevin Bowers on 11/30/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class SSDViewController: UIViewController{
    
    //var schools = SchoolsArray.init().allSchools
    
    //var staffList = StaffArray.init().staffList
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var mainNumber: UILabel!
    @IBOutlet weak var attendanceNumber: UILabel!
    @IBOutlet weak var faxNumber: UILabel!
    @IBOutlet weak var schoolPicture: UIImageView!
    
    @IBAction func unwindSegue(forSegue: UIStoryboardSegue) {
    }
    
    
    var indexOfSchool: Int!
    
    static var staticSchoolIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(indexOfSchool)
        SSDViewController.staticSchoolIndex = indexOfSchool
        let school = SchoolsArray.allSchools[indexOfSchool]
        schoolName.text = school.name
        address.text = school.address
        location.text = school.city + ", " + school.state + " " + school.zip
        mainNumber.text = "Main - " + school.mainNumber
        attendanceNumber.text = "Attendance - " + school.attendanceNumber
        faxNumber.text = "Fax - " + school.faxNumber
        schoolPicture.image = UIImage(named: school.schoolPicture)
        
    }
    
    func getSchoolShortName() -> String {
        return SchoolsArray.allSchools[indexOfSchool].shortName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}


