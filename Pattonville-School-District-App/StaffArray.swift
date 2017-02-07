//
//  StaffArray.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 12/12/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// The array of Staff members for the Directory
class StaffArray {
    
    /// The array of Staff members used in the directory
    var staffList = [StaffMember]()
    
    init() {
        staffList.append(StaffMember(firstName: "Jeremiah", lastName: "Simmons", department: "CS", email: "jsimmons@psdr3.org", ext: "0000"))
        staffList.append(StaffMember(firstName: "Stephanie", lastName: "Frerker", department: "Modern Language", email: "sfrerker@psdr3.org", ext: "0001"))
        staffList.append(StaffMember(firstName: "Gay", lastName: "Lacy", department: "English", email: "glacy@psdr3.org", ext: "0002"))
        staffList.append(StaffMember(firstName: "Odetta", lastName: "Smith", department: "Assisstant Principle", email: "osmith@psdr3.org", ext: "0003"))
        staffList.append(StaffMember(firstName: "Justin", lastName: "Smiley", department: "Social Study", email: "jsmiley@psdr3.org", ext: "0004"))
        
    }
    
}
