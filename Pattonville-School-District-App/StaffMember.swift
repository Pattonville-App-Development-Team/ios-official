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
    var pcn: String
    
    /// Job Title
    var long_desc: String
    
    var location: String
    var email: String
    var office1: String
    var ext1: String
    var office2: String
    var ext2: String
    var office3: String
    var ext3: String
    
    // Associating each of these job types with a value which is used to sort the StaffMember array in the Directory class
    static let PRINCIPAL: Int = 0, ASSOCIATE_PRINCIPAL: Int = 1, ASSISTANT_PRINCIPAL:Int = 2,
    TEACHER: Int = 3, SECRETARY: Int = 4, SUPPORT_STAFF: Int = 5
    
    /// A two or three letter abbreviation of the location of the staff member
    lazy var directoryKey: String = self.getSchoolByLocation(location: self.location)
    
    /// Integer representation of the rank of a staff member used to sort the array of staff members
    lazy var rank: Int = self.getRank()
    
    /// Default constructor for a StaffMember object
    ///
    /// - Parameters:
    ///   - fName: First name
    ///   - lName: Last name
    ///   - long_desc: Job title
    ///   - location: Building or School where the staff member works
    ///   - email: District given email address
    ///   - office1: First direct phone number
    ///   - ext1: First phone extension number
    ///   - office2: Second direct phone number
    ///   - ext2: Second phone extension number
    ///   - office3: Third direct phone number
    ///   - ext3: Third phone extension number
    init(fName: String, lName: String, pcn: String, long_desc: String, location: String, email: String, office1: String, ext1: String, office2: String, ext2: String, office3: String, ext3: String) {
        
        self.fName = fName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.lName = lName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.pcn = pcn.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
    
    /// Initializer used when reading from directoy CSV file
    ///
    /// - Parameter values: Array of all of the fields available on each staff member
    convenience init(values: [String]){
        self.init(
            fName: values[0],
            lName: values[1],
            pcn: values[2],
            long_desc: values[3],
            location: values[4],
            email: values[5],
            office1: values[6],
            ext1: values[7],
            office2: values[8],
            ext2: values[9],
            office3: values[10],
            ext3: values[11])
    }
    
    /// Identifies which school shortName should be used to add the staff member to the directoryDictionary based on a key which matches a school shortName
    ///
    /// - Parameter location: Building or school where the staff member works given by the directory CSV file
    /// - Returns: shortName of the building or school where the staff member works
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
        default:
            school = "PSD"
        }
        return school
    }
    
    /// Determines what integer a staff member should be associated with when sorted in the Directory class
    ///
    /// - Returns: Integer representing what typing of job a staff member has
    func getRank() -> Int{
        if self.long_desc.contains("PRINCIPAL"){
            if self.long_desc.contains("ASSISTANT"){
                return StaffMember.ASSISTANT_PRINCIPAL
            }else if self.long_desc.contains("ASSOCIATE"){
                return StaffMember.ASSOCIATE_PRINCIPAL
            }else{
                return StaffMember.PRINCIPAL
            }
        }else if self.long_desc.contains("TEACHER") || self.long_desc.contains("TEACH"){
            return StaffMember.TEACHER
        }else if self.long_desc.contains("SECRETARY"){
            return StaffMember.SECRETARY
        }else{
            return StaffMember.SUPPORT_STAFF
        }
    }
    
    
    
}
