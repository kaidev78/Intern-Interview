//
//  StudentProfessorNavigationController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/26/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit

class StudentProfessorNavigationController: UINavigationController {

    var useraccount: UserAccount?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLoad() {
        let tabbarcontroller = self.tabBarController as! StudentHomeTabBarView
        useraccount = tabbarcontroller.useraccount
    }

}
