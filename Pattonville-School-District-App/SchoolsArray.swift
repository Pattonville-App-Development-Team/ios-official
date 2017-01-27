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
    static var allSchools: [School] = [SchoolsEnum.district, SchoolsEnum.pattonvilleHighSchool, SchoolsEnum.heightsMiddleSchool, SchoolsEnum.holmanMiddleSchool, SchoolsEnum.remingtonTraditional, SchoolsEnum.bridgewayElementary, SchoolsEnum.drummondElementary, SchoolsEnum.parkwoodElementary, SchoolsEnum.roseAcresElementary, SchoolsEnum.willowBrookElementary, SchoolsEnum.earlyChildhood]
    
    
    static func getSchoolByName(name: String) -> School{
        
        return allSchools.filter({
            $0.name.contains(name)
        }).first!
        
    }
    
    static func getSubscribedSchools() -> [School]{
        return allSchools.filter({
            $0.isSubscribedTo
        })
    }
    
    static func getSchools() -> [School]{
        return allSchools.filter({
            $0 != SchoolsEnum.district
        })
    }
   
}
