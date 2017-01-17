//
//  htStaffList.swift
//  Pattonville-School-District-App
//
//  Created by D3vel0per on 1/13/17.
//  Copyright © 2017 Joshua Zahner. All rights reserved.
//

import UIKit

class htStaffArray {
    
    var htStaffList = [StaffMember]()
    
    init() {
        htStaffList.append(StaffMember(firstName: "John", lastName: "Biever", department: "Science", email: "jsimmons@psdr3.org", ext: "0000"))
        htStaffList.append(StaffMember(firstName: "Stephanie", lastName: "Frerker", department: "Modern Language", email: "sfrerker@psdr3.org", ext: "0001"))
        htStaffList.append(StaffMember(firstName: "Gay", lastName: "Lacy", department: "English", email: "glacy@psdr3.org", ext: "0002"))
        htStaffList.append(StaffMember(firstName: "Odetta", lastName: "Smith", department: "Assisstant Principle", email: "osmith@psdr3.org", ext: "0003"))
        htStaffList.append(StaffMember(firstName: "Justin", lastName: "Smiley", department: "Social Study", email: "jsmiley@psdr3.org", ext: "0004"))
    }
    
}
