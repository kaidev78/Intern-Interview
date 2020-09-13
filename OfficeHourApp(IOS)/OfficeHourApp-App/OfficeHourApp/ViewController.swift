//
//  ViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/24/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwne Chen
// ID: 111968628

import UIKit
import CoreData

struct accountLogin{
    var username: String
    var password: String
}

class ViewController: UIViewController {

    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorlbl: UILabel!
    
    var login: accountLogin?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        login = accountLogin(username: "", password: "")
        let textFields: [UITextField] = [usernametxt, passwordtxt]
        for textField in textFields{
            textField.addTarget(self, action: #selector(self.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
        
    }
    
    /**
     Record user inputs
     
     - Parameter textField: the field that the user inputs on.
     
     - Returns: true whenever user finish typing
        
     */
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        login?.username = usernametxt.text ?? ""
        login?.password = passwordtxt.text ?? ""
        return true
    }
    
    /**
     Validate login informations. If valid, direct to user home view
     
     - Parameter sender: the source event
             
     */
    @IBAction func logInCheck(_ sender: Any) {
        usernametxt.resignFirstResponder()
        passwordtxt.resignFirstResponder()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.userAccount)
        let predicate = NSPredicate(format: "userName == %@", login!.username)
        request.predicate = predicate
        var accounts: [NSManagedObject] = []
        do{
            accounts = try context.fetch(request)
        }catch let error as NSError{
            print("fail to fetch: \(error)")
        }
        if(accounts.count == 0){
            print("Account is not existed")
            errorlbl.text = "Account is not existed"
            errorlbl.isHidden = false
            return
        }
        let accountobj = accounts[0] as! UserAccount
        if(accountobj.password != login?.password){
            print("Wrong password")
            errorlbl.text = "Wrong password"
            errorlbl.isHidden = false
            return
        }
        else{
            if(accountobj.accountType == accountType.student){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "HomeTabBarController") as StudentHomeTabBarView
                controller.useraccount = accountobj
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true) {}
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "AdminHomeTabBarController") as! ProfessorTabBarView
                controller.firstName = accountobj.firstName
                controller.lastName = accountobj.lastName
                controller.userName = accountobj.userName
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true) {}
            }
        }
    
    }
    
    /**
     Resets the textfields
     */
    func cleanTextFields(){
        usernametxt.text = ""
        passwordtxt.text = ""
        login?.username = ""
        login?.password = ""
    }
    
    // MARK: - Keyboard Control
    // Codes from Textbook Chapter 10
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
        self.cleanTextFields()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()
        errorlbl.isHidden = true
    }
    
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func  unregisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardDidShow(notification: NSNotification){
        let userInfor: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfor = userInfor[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfor.cgRectValue.size

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
        
    }

    @objc func keyboardWillHide(notification: NSNotification){
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0

        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - For testing purpose
    /**
     Remove everyting from database
     */
    func removeAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAccount")
        let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentsInfo")
        let request3 = NSFetchRequest<NSFetchRequestResult>(entityName: "AdminsInfo")
        let deleterequest = NSBatchDeleteRequest(fetchRequest: request)
        let deleterequest2 = NSBatchDeleteRequest(fetchRequest: request2)
        let deleterequest3 = NSBatchDeleteRequest(fetchRequest: request3)
        do{
            try appDelegate.persistentContainer.viewContext.execute(deleterequest)
            try appDelegate.persistentContainer.viewContext.execute(deleterequest2)
            try appDelegate.persistentContainer.viewContext.execute(deleterequest3)
        }
        catch{
            print("error")
        }
        print("data deleted")
    }
    
    /**
     Remove all StudentInfo from database
     */
    func remoeveStudentInfo(){
        let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentsInfo")
        let deleterequest2 = NSBatchDeleteRequest(fetchRequest: request2)
        do{
            try appDelegate.persistentContainer.viewContext.execute(deleterequest2)
        }  catch{
            print("error")
        }
        print("studentInfo deleted")
    }
    
}

