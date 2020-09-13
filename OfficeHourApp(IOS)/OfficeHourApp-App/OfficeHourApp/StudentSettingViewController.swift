//
//  StudentSettingViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/28/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit

class StudentSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
      log out when user clicks the button
    */

    @IBAction func logOut(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(identifier: "LoginViewNavigationController")
//        controller.modalPresentationStyle = .fullScreen
//        self.navigationController?.present(controller, animated: true, completion: {
//        })
        self.parent?.dismiss(animated: true, completion: {})
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}
