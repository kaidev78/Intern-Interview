//
//  RegisterViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/24/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwne Chen
// ID: 111968628

import UIKit
import CoreData

struct accountRegister{
    var userName: String
    var password: String
    var comfirmPassword: String
    var firstName: String
    var lastName: String
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernamelbl: UITextField!
    @IBOutlet weak var passwordlbl: UITextField!
    @IBOutlet weak var confirmpasswordlbl: UITextField!
    @IBOutlet weak var registerbtn: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var userType: UISegmentedControl!
    @IBOutlet weak var lastnametxt: UITextField!
    @IBOutlet weak var firstnametxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContent: UIStackView!
    
    
    
    var register: accountRegister?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        register = accountRegister(userName: "", password: "", comfirmPassword: "", firstName: "", lastName: "")
        
        let textFields: [UITextField] = [usernamelbl, passwordlbl, confirmpasswordlbl]
        for textField in textFields{
            textField.addTarget(self, action: #selector(self.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
        
        self.registerKeyboardNotifications()
    }
    
    /**
     Record user inputs
     
     - Parameter textField: the field that the user inputs on.
     
     - Returns: true whenever user finish typing
        
     */
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        register?.userName = usernamelbl.text ?? ""
        register?.password = passwordlbl.text ?? ""
        register?.comfirmPassword = confirmpasswordlbl.text ?? ""
        
        return true
    }
    
    // MARK: - Account Validation
    /**
     check if user inputs are validate. if yes, then account is sucessfully registered and return to the login view.
     
     - Parameter sender: the source event
             
     */
    @IBAction func validateInfo(_ sender: Any) {
        usernamelbl.resignFirstResponder()
        passwordlbl.resignFirstResponder()
        confirmpasswordlbl.resignFirstResponder()
        
        if(register?.userName == nil || checkEmptyString(text: register!.userName)){
            errorMsg.text = "You can't have empty username"
            errorMsg.isHidden = false
            return
        }
        else if(register?.password == nil || checkEmptyString(text: register!.password)){
            errorMsg.text = "You can't have empty password"
            errorMsg.isHidden = false
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.userAccount)
        var accounts: [NSManagedObject] = []
        do{
            accounts = try context.fetch(request)
        }catch let error as NSError{
            print("fail to fetch: \(error)")
        }
        
        if(checkDuplicateAccount(accounts: accounts)){
            errorMsg.text = "Account is already registered"
            errorMsg.isHidden = false
            return
        }
        
        if(register?.password != register?.comfirmPassword){
            errorMsg.text = "Passwords don't match"
            errorMsg.isHidden = false
            return
        }
        
        let registerAccount = UserAccount(context: context)
        registerAccount.userName = usernamelbl.text
        registerAccount.password = passwordlbl.text
        registerAccount.firstName = firstnametxt.text
        registerAccount.lastName = lastnametxt.text
        if(userType.selectedSegmentIndex == 0){
            registerAccount.accountType = accountType.student
        }
        else{
            registerAccount.accountType = accountType.admin
        }
        
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
        print("account registered")
    }
    
    /**
     Check if username or password is an empty string
     
     - Parameter text: the text string(username or password)
             
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
     Check if account name is already registered
     
     - Parameter accounts: all the accounts store in the database
             
     */
    func checkDuplicateAccount(accounts: [NSManagedObject]) -> Bool{
        for account in accounts{
            let accountobj = account as! UserAccount
            if(accountobj.userName == register?.userName){
                print("duplicate username")
                return true
            }
        }
        return false
    }
    
    // MARK: - Keyboard Control
    // Codes from Textbook Chapter 10
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotification()

    }

    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
