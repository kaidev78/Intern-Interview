//
//  StudentDatePickViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/26/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

import UIKit

//Date Delegate follows the template in testbook chapter 10
protocol DatePickDelegate {
    func dateChanged(date: Date)
}

class StudentDatePickViewController: UIViewController {

    var setDate: Date?
    
    @IBOutlet weak var datepicker: UIDatePicker!
    var delegate: DatePickDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datepicker.setDate(setDate ?? Date(), animated: false)
    }
    
    /**
     pass the changed date to the delegate.
     */
    @IBAction func datesave(_ sender: Any) {
        delegate?.dateChanged(date: datepicker.date)
        self.navigationController?.popViewController(animated: true)
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
