//
//  Directory.swift
//  Pattonville School District App
//
//  Created by Kevin Bowers on 12/12/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// The array of Staff members for the Directory
class Directory {
    
    static var directoryDictionary = [String:[StaffMember]]()
    
    var studentDirectoryCSVContents = ""
    
    var phsStaffArray = [StaffMember]()
    var htStaffArray  = [StaffMember]()
    var hoStaffArray  = [StaffMember]()
    var reStaffArray  = [StaffMember]()
    var bwStaffArray  = [StaffMember]()
    var drStaffArray  = [StaffMember]()
    var pwStaffArray  = [StaffMember]()
    var raStaffArray  = [StaffMember]()
    var wbStaffArray  = [StaffMember]()
    var ecStaffArray  = [StaffMember]()
    
    var first = 0
    
    init() {
        studentDirectoryCSVContents = readDataFromFile(file: "Student_Directory")
        populateDictionary()
        createStaffMembers()
        print("***Initiation Complete***")
        
    }

    func populateDictionary() {
        
        Directory.directoryDictionary["HS"] = phsStaffArray
        Directory.directoryDictionary["HT"]  = htStaffArray
        Directory.directoryDictionary["HO"]  = hoStaffArray
        Directory.directoryDictionary["RE"]  = reStaffArray
        Directory.directoryDictionary["BW"]  = bwStaffArray
        Directory.directoryDictionary["DR"]  = drStaffArray
        Directory.directoryDictionary["PW"]  = pwStaffArray
        Directory.directoryDictionary["RA"]  = raStaffArray
        Directory.directoryDictionary["WB"]  = wbStaffArray
        Directory.directoryDictionary["EC"]  = ecStaffArray
        
    }
    
    func readDataFromFile(file:String)-> String!{
        guard let filepath = Bundle.main.path(forResource: file, ofType: "csv")
            else {
                return nil
        }
        do {
            return try String(contentsOfFile: filepath, encoding: String.Encoding.utf8)
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }

    func createStaffMembers() {

        let input = studentDirectoryCSVContents
        let lines: [String] = input.components(separatedBy: "\n")
        //let fields: [String] = lines[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        for line in lines{
            if line.characters.count > 0{
                let staffParams: [String] = line.components(separatedBy: ",")
                let staffMember = StaffMember(values: staffParams)
                
                assignStaffMembers(staffMember: staffMember)
                
            }
        }
    }
    
    func assignStaffMembers(staffMember: StaffMember) {
        
        if first < 2 {
        print(staffMember.fName + staffMember.location)
        
        }
        var school: String = "";
        switch staffMember.location {
            case "POSITIVE SCHOOL":
                school = "HS"
            case "PATTONVILLE HIGH SCHOOL":
                school = "HS"
            case "PATTONVILLE HEIGHTS":
               school = "HT"
            case "HOLMAN MIDDLE SCHOOL":
                school = "HO"
            case "REMINGTON TRADITIONAL":
                school = "RE"
            case "BRIDGEWAY ELEMENTARY":
                school = "BW"
            case "ROBERT DRUMMOND ELEMENTARY":
                school = "DR"
            case "PARKWOOD ELEMENTARY":
                school = "PW"
            case "ROSE ACRES ELEMENTARY":
                school = "RA"
            case "WILLOW BROOK ELEMENTARY":
                school = "WB"
            case "EARLY CHILDHOOD SPECIAL ED":
                school = "EC"
            default: break
        }
        
        print(school.characters.count)
//        if(Directory.directoryDictionary.contains(where: { (<#(key: String, value: [StaffMember])#>) -> Bool in
//            <#code#>
//        }))
        
        if(school.characters.count > 0){
            Directory.directoryDictionary[school]?.append(staffMember);
        }
        if first < 2 {
        print(Directory.directoryDictionary)
            first += 1
        }
    }
    
}

























