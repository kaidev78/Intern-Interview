//
//  StudentSortSettingViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/27/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit

// SettingViewController is following the template in textbook chapter 11
class StudentSortSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var sortPicker: UIPickerView!
    @IBOutlet weak var ascendSwitcher: UISwitch!
    let sortFields = ["Time", "Class", "Professor", "Ready Status"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortPicker.delegate = self
        sortPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    /**
      Change ascending status when user clicks the button
      
      - Parameter sender: the source event.
    */
    @IBAction func switchAcending(_ sender: Any) {
        let setting = UserDefaults.standard
        setting.set(ascendSwitcher.isOn, forKey: SortField.sortByAscending)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortFields.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortFields[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortFields[row]
        let setting = UserDefaults.standard
        if(sortField == "Time"){
            setting.set(DBConstants.studentAppointmentTime, forKey: SortField.sortByField)
        }
        else if(sortField == "Class"){
            setting.set(DBConstants.studentAppointedClass, forKey: SortField.sortByField)
        }
        else if(sortField == "Professor"){
            setting.set(DBConstants.studentProfessorName, forKey: SortField.sortByField)
        }
        else{
            setting.set(DBConstants.studentReady, forKey: SortField.sortByField)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let setting = UserDefaults.standard
        let sortField = setting.string(forKey: SortField.sortByField)
        if(sortField == DBConstants.studentAppointmentTime){
            sortPicker.selectRow(0, inComponent: 0, animated: false)
        }
        else if(sortField == DBConstants.studentAppointedClass){
            sortPicker.selectRow(1, inComponent: 0, animated: false)
        }
        else if(sortField == DBConstants.studentProfessorName){
            sortPicker.selectRow(2, inComponent: 0, animated: false)
        }
        else{
            sortPicker.selectRow(3, inComponent: 0, animated: false)
        }
        ascendSwitcher.isOn = setting.bool(forKey: SortField.sortByAscending)
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
