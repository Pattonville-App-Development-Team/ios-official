//
//  SchoolsArray.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/14/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// SchoolsArray class to be used throughout the app to iterate over the value in the SchoolsEnum
class SchoolsArray {
    
    /// The array that belongs to SchoolsArray to be used as array that is iterated over
    var allSchools: [School] = [School]()
    
    /// The initializer that adds in all the schools from the Schools.Enum
    init() {
        
        allSchools.append(SchoolsEnum.earlyChildhood)
        allSchools.append(SchoolsEnum.bridgewayElementary)
        allSchools.append(SchoolsEnum.drummondElementary)
        allSchools.append(SchoolsEnum.parkwoodElementary)
        allSchools.append(SchoolsEnum.remingtonTraditional)
        allSchools.append(SchoolsEnum.roseAcresElementary)
        allSchools.append(SchoolsEnum.willowBrookElementary)
        allSchools.append(SchoolsEnum.holmanMiddleSchool)
        allSchools.append(SchoolsEnum.heightsMiddleSchool)
        allSchools.append(SchoolsEnum.pattonvilleHighSchool)
        
    }
    
}
