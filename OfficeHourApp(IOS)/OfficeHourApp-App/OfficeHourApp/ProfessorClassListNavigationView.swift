//
//  ProfessorClassListNavigationView.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit

class ProfessorClassListNavigationView: UINavigationController {

    var firstName: String?
    var lastName: String?
    var userName: String?
    
    override func viewDidLoad() {
        let tabarcontroller = self.tabBarController as! ProfessorTabBarView
        firstName = tabarcontroller.firstName
        lastName = tabarcontroller.lastName
        userName = tabarcontroller.userName
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
