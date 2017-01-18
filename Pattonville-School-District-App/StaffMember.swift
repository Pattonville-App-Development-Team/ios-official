//
//  StaffMember.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/8/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

class StaffMember {
    
    var firstName: String
    var lastName: String
    var department: String
    var email: String
    var ext: String
    
    init(firstName: String, lastName: String, department: String, email: String, ext: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.department = department
        self.email = email
        self.ext = ext
        
        
    }
}
