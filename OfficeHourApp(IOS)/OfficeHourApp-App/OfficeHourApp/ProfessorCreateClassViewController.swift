//
//  ProfessorCreateClassViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class ProfessorCreateClassViewController: UIViewController {

    @IBOutlet weak var addClass: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var classtxt: UITextField!
    @IBOutlet weak var errormsglbl: UILabel!
    
    var firstName: String?
    var lastName: String?
    var userName: String?
    var registerClass: String?
    var classList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadClassList()
        classtxt.addTarget(self, action: #selector(self.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        registerClass = classtxt.text ?? ""
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /**
     add a class for the admin
     
     - Parameter sender: the event source
    
     */
    @IBAction func addClassToDB(_ sender: Any) {
        classtxt.resignFirstResponder()
        let context = appDelegate.persistentContainer.viewContext
        if(registerClass == nil){
            errormsglbl.text = "Class name can't be empty"
            errormsglbl.isHidden = false
            return
        }
        if(checkEmptyString(text: registerClass!)){
            errormsglbl.text = "Class name can't be empty"
            errormsglbl.isHidden = false
            return
        }
        if(checkDuplicateClass(name: registerClass!)){
            return
        }
        let registerClass = AdminsInfo(context: context)
        registerClass.classTitle = self.registerClass
        registerClass.firstName = firstName
        registerClass.lastName = lastName
        registerClass.numberOfStudents = 0
        registerClass.userName = userName
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
        print("class added: \(registerClass.classTitle ?? "nil")")
    }
    
    /**
     Load the list of the classes for the admin
     */
    func loadClassList(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.adminInfo)
        let predicate = NSPredicate(format: "userName == %@", userName ?? "")
        request.predicate = predicate
        do{
            classList = try context.fetch(request)
        }catch let error as NSError{
            print("fetching class list error: \(error)")
        }
    }
    
    /**
     Check if the class name is an empty string
     
     - Parameter text: the class name
     
     - Returns: if string is empty return true, else false
        
     */
    func checkEmptyString(text: String) -> Bool{
        if(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            return true
        }
        else{
            return false
        }
    }
    
    /**
     Check is there's duplicate class name in the list
     
     - Parameter text: the class name
     
     - Returns: if class name is duplicate return true, else false
        
     */
    func checkDuplicateClass(name: String) -> Bool{
        for classobj in classList{
            let classElement = classobj as! AdminsInfo
            if(classElement.classTitle == registerClass){
                errormsglbl.text = "Class name is already exist"
                errormsglbl.isHidden = false
                return true
            }
        }
        return false
    }
}
