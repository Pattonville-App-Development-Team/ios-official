//
//  StaffMember.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 11/8/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// The Model class for type StaffMember to be used in the Directory 
class StaffMember: NSObject, NSCoding {
    
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
    
    required init(coder decoder: NSCoder) {
        
        fName = (decoder.decodeObject(forKey: "fName") as? String)!
        lName = (decoder.decodeObject(forKey: "lName") as? String)!
        pcn = (decoder.decodeObject(forKey: "pcn") as? String)!
        long_desc = (decoder.decodeObject(forKey: "long_desc") as? String)!
        location = (decoder.decodeObject(forKey: "location") as? String)!
        email = (decoder.decodeObject(forKey: "email") as? String)!
        office1 = (decoder.decodeObject(forKey: "office1") as? String)!
        ext1 = (decoder.decodeObject(forKey: "ext1") as? String)!
        office2 = (decoder.decodeObject(forKey: "office2") as? String)!
        ext2 = (decoder.decodeObject(forKey: "ext2") as? String)!
        office3 = (decoder.decodeObject(forKey: "office3") as? String)!
        ext3 = (decoder.decodeObject(forKey: "ext3") as? String)!
        
        super.init()
        
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
    
    func encode(with coder: NSCoder) {
        coder.encode(fName, forKey: "fName")
        coder.encode(lName, forKey: "lName")
        coder.encode(pcn, forKey: "pcn")
        coder.encode(long_desc, forKey: "long_desc")
        coder.encode(location, forKey: "location")
        coder.encode(email, forKey: "email")
        coder.encode(office1, forKey: "office1")
        coder.encode(ext1, forKey: "ext1")
        coder.encode(office2, forKey: "office2")
        coder.encode(ext2, forKey: "ext2")
        coder.encode(office3, forKey: "office3")
        coder.encode(ext3, forKey: "ext3")
    }
    
}
