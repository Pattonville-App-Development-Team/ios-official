//
//  SSDViewController.swift
//  Pattonville School District App
//


//  Created by Kevin Bowers on 11/30/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class SSDViewController: UIViewController{
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var mainNumber: UILabel!
    @IBOutlet weak var attendanceNumber: UILabel!
    @IBOutlet weak var faxNumber: UILabel!
    @IBOutlet weak var schoolPicture: UIImageView!
    
    // Set by the "prepare" function in DirectoryViewController.swift
    var indexOfSchool: Int!
    
    // Variable is used in StaffListViewController.swift to identify which school was selected and determine which StaffMember array in Directory.directoyDictionary should be used
    static var staticSchoolIndex: Int!
    
    /// Function to display proper information on the School Specific Directory View Controller Scene for the school that was selected in the Directory View Controller Scene
    override func viewDidLoad() {
        super.viewDidLoad()
        SSDViewController.staticSchoolIndex = indexOfSchool
        let school = SchoolsArray.allSchools[indexOfSchool]
        navigationItem.title = school.name
        address.text = school.address
        location.text = school.city + ", " + school.state + " " + school.zip
        mainNumber.text = "Main - " + school.mainNumber
        attendanceNumber.text = "Attendance - " + school.attendanceNumber
        faxNumber.text = "Fax - " + school.faxNumber
        schoolPicture.image = UIImage(named: school.schoolPicture)
        
    }
}


