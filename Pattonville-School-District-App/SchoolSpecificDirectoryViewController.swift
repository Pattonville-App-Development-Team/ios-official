//
//  SchoolSpecificDirectoryViewController.swift
//  Pattonville School District App
//


//  Created by Kevin Bowers on 11/30/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

class SchoolSpecificDirectoryViewController: UIViewController{
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var mainNumber: UIButton!
    @IBOutlet weak var attendanceNumber: UIButton!
    @IBOutlet weak var faxNumber: UILabel!
    @IBOutlet weak var schoolPicture: UIImageView!
    
    @IBAction func callMainNumber(_ sender: UIButton) {
        
        let school = SchoolsArray.allSchools[self.indexOfSchool]
        
        let mainNumber = school.mainNumber
        
        if let phoneCallURL:URL = URL(string: "tel:\(mainNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: school.name, message: "Are you sure you want to call \n the main office", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                })
                let noPressed = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    
                })
                alertController.addAction(noPressed)
                alertController.addAction(yesPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func callAttendanceNumber(_ sender: Any) {
        
        let school = SchoolsArray.allSchools[self.indexOfSchool]
        
        let attendanceNumber = school.attendanceNumber
        
        if let phoneCallURL:URL = URL(string: "tel:\(attendanceNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: school.name, message: "Are you sure you want to call \n the attendance office", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                })
                let noPressed = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    
                })
                alertController.addAction(noPressed)
                alertController.addAction(yesPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    // Set by the "prepare" function in DirectoryViewController.swift
    var indexOfSchool: Int!
    
    // Variable is used in StaffListViewController.swift to identify which school was selected and determine which StaffMember array in Directory.directoyDictionary should be used
    static var staticSchoolIndex: Int!
    
    /// Function to display proper information on the School Specific Directory View Controller Scene for the school that was selected in the Directory View Controller Scene
    override func viewDidLoad() {
        super.viewDidLoad()
        SchoolSpecificDirectoryViewController.staticSchoolIndex = indexOfSchool
        let school = SchoolsArray.allSchools[indexOfSchool]
        navigationItem.title = school.name
        address.text = school.address
        location.text = school.city + ", " + school.state + " " + school.zip
        mainNumber.setTitle("Main: " + school.mainNumber, for: .normal)
        if school.attendanceNumber != "N/A" {
            attendanceNumber.setTitle("Attendance: " + school.attendanceNumber, for: .normal)
        } else {
            attendanceNumber.isHidden = true
        }
        faxNumber.text = "Fax: " + school.faxNumber
        schoolPicture.image = UIImage(named: school.schoolPicture)
        
    }
}


