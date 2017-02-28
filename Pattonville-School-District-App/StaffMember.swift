//
//  StaffMember.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/8/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// The Model class for type StaffMember to be used in the Directory 
class StaffMember {
    
    var fName: String
    var lName: String
    var long_desc: String
    var location: String
    var email: String
    var office1: String
    var ext1: String
    var office2: String
    var ext2: String
    var office3: String
    var ext3: String
    
    static let PRINCIPAL: Int = 0, ASSOCIATE_PRINCIPAL: Int = 1, ASSISTANT_PRINCIPAL:Int = 2,
    TEACHER: Int = 3, SECRETARY: Int = 4, SUPPORT_STAFF: Int = 5
    
    lazy var directoryKey: String = self.getSchoolByLocation(location: self.location)
    lazy var rank: Int = self.getRank()
    
    init(fName: String, lName: String, long_desc: String, location: String, email: String, office1: String, ext1: String, office2: String, ext2: String, office3: String, ext3: String) {
        
        self.fName = fName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.lName = lName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.long_desc = long_desc.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.location = location.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.email = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.office1 = office1.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.ext1 = ext1.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.office2 = office2.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.ext2 = ext2.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.office3 = office3.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.ext3 = ext3.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
    
    convenience init(values: [String]){
        self.init(
            fName: values[0],
            lName: values[1],
            long_desc: values[2],
            location: values[3],
            email: values[4],
            office1: values[5],
            ext1: values[6],
            office2: values[7],
            ext2: values[8],
            office3: values[9],
            ext3: values[10])
    }
    
    func getSchoolByLocation(location: String) -> String{
        var school = ""
        switch(location){
        case "BRIDGEWAY ELEMENTARY":
            school = "BW"
        case "ROBERT DRUMMOND ELEMENTARY":
            school = "DR"
        case "LEARNING CENTER":
            fallthrough
        case "DISTRICT WIDE":
            school = "PSD"
        case "HOLMAN MIDDLE SCHOOL":
            school = "HO"
        case "PATTONVILLE HEIGHTS":
            school = "HT"
        case "POSITIVE SCHOOL":
            fallthrough
        case "PATTONVILLE HIGH SCHOOL":
            school = "HS"
        case "PARKWOOD ELEMENTARY":
            school = "PW"
        case "ROSE ACRES ELEMENTARY":
            school = "RA"
        case "REMINGTON TRADITIONAL":
            school = "RE"
        case "WILLOW BROOK ELEMENTARY":
            school = "WB"
        case "EARLY CHILDHOOD SPECIAL ED":
            school = "EC"
//        case "Location":
//            break
        default:
            school = "PSD"
        }
        return school
    }
    
    func getRank() -> Int{
        if self.long_desc.contains("PRINCIPAL"){
            if self.long_desc.contains("ASSISTANT"){
                return StaffMember.ASSISTANT_PRINCIPAL
            }else if self.long_desc.contains("ASSOCIATE"){
                return StaffMember.ASSOCIATE_PRINCIPAL
            }else{
                return StaffMember.PRINCIPAL
            }
        }else if self.long_desc.contains("TEACHER"){
            return StaffMember.TEACHER
        }else if self.long_desc.contains("SECRETARY"){
            return StaffMember.SECRETARY
        }else{
            return StaffMember.SUPPORT_STAFF
        }
    }
    
    
    
}
