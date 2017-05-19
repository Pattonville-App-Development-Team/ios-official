//
//  staffMemberTableViewCell.swift
//  Pattonville-School-District-App
//
//  Created by D3vel0per on 12/15/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit

/// Template for each staff member cell
class StaffMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var extButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
