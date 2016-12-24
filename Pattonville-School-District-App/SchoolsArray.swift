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
    static var allSchools: [School] = [School]()
    
    /// The initializer that adds in all the schools from the Schools.Enum
    init() {
        
        SchoolsArray.allSchools.append(SchoolsEnum.earlyChildhood)
        SchoolsArray.allSchools.append(SchoolsEnum.bridgewayElementary)
        SchoolsArray.allSchools.append(SchoolsEnum.drummondElementary)
        SchoolsArray.allSchools.append(SchoolsEnum.parkwoodElementary)
        SchoolsArray.allSchools.append(SchoolsEnum.remingtonTraditional)
        SchoolsArray.allSchools.append(SchoolsEnum.roseAcresElementary)
        SchoolsArray.allSchools.append(SchoolsEnum.willowBrookElementary)
        SchoolsArray.allSchools.append(SchoolsEnum.holmanMiddleSchool)
        SchoolsArray.allSchools.append(SchoolsEnum.heightsMiddleSchool)
        SchoolsArray.allSchools.append(SchoolsEnum.pattonvilleHighSchool)
        
    }
   
}
