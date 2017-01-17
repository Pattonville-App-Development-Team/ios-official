//
//  phsStaffArray.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 12/12/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class phsStaffArray {
    
    var phsStaffList = [StaffMember]()
    
    init() {
        phsStaffList.append(StaffMember(firstName: "Jeremiah", lastName: "Simmons", department: "CS", email: "jsimmons@psdr3.org", ext: "0000"))
        phsStaffList.append(StaffMember(firstName: "Stephanie", lastName: "Frerker", department: "Modern Language", email: "sfrerker@psdr3.org", ext: "0001"))
        phsStaffList.append(StaffMember(firstName: "Gay", lastName: "Lacy", department: "English", email: "glacy@psdr3.org", ext: "0002"))
        phsStaffList.append(StaffMember(firstName: "Odetta", lastName: "Smith", department: "Assisstant Principle", email: "osmith@psdr3.org", ext: "0003"))
        phsStaffList.append(StaffMember(firstName: "Justin", lastName: "Smiley", department: "Social Study", email: "jsmiley@psdr3.org", ext: "0004"))
    }
    
}
