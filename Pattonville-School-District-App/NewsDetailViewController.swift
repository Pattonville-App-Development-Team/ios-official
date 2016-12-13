//
//  NewsDetailViewController.swift
//  Pattonville School District App
//
//  Created by Developer on 10/4/16.
//  Copyright © 2016 Pattonville School Distrcit. All rights reserved.
//

import UIKit

/// The ViewController for the View that appears after a user selects a news story in the main News page
class NewsDetailViewController: UIViewController{
    
    /// The image at the top of the news article before the text
    @IBOutlet var ivDisplayImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivDisplayImage.image = UIImage(named: "flowers")
        
        // Do any additional setup after loading the view.
    }

    
}
