//
//  ProfessorSettingViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/28/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit

class ProfessorSortSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ascendSwitch: UISwitch!
    
    var sortField = ["Class", "Number of Students"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortField.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortField[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let setting = UserDefaults.standard
        if(sortField[row] == "Class"){
            setting.set(DBConstants.adminClassTitle, forKey: SortField.sortByFieldProfessor)
        }
        else if(sortField[row] == "Number of Students"){
            setting.set(DBConstants.adminNumberOfStudents, forKey: SortField.sortByFieldProfessor)
        }
        setting.synchronize()
    }

    /**
      Switch ascending sorting order when user clicks the button.
    */
    @IBAction func switchAscending(_ sender: Any) {
        let setting = UserDefaults.standard
        setting.set(ascendSwitch.isOn, forKey: SortField.sortByAscendingProfessor)
        setting.synchronize()
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
