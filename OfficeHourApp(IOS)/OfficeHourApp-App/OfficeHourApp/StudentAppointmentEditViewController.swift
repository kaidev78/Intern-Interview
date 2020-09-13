//
//  StudentAppointmentEditViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/26/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class StudentAppointmentEditViewController: UIViewController, DatePickDelegate {
    
    @IBOutlet weak var classlbl: UILabel!
    @IBOutlet weak var professorlbl: UILabel!
    @IBOutlet weak var registertimelbl: UILabel!
    @IBOutlet weak var appointmenttimelbl: UILabel!
    @IBOutlet weak var descriptionBox: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContent: UIStackView!
    
    var appointmentInfo: StudentsInfo?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var updateTime: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupEditPage()
        
        self.registerKeyboardNotifications()
    }
    
    /**
     Set up edit page for the appointment.
     */
    func setupEditPage(){
        classlbl.text = appointmentInfo?.appointedClass
        professorlbl.text = appointmentInfo?.professorName
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        registertimelbl.text = formatter.string(from: appointmentInfo?.registerTime ?? Date())
        appointmenttimelbl.text = formatter.string(from: appointmentInfo?.appointmentTime ?? Date())
        descriptionBox.text = appointmentInfo?.appointmentDescription
        descriptionBox.layer.borderColor = UIColor.black.cgColor
        descriptionBox.layer.borderWidth = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "studentEditAppointmentSegue"){
            let controller = segue.destination as! StudentDatePickViewController
            controller.delegate = self
            controller.setDate = appointmentInfo?.appointmentTime
        }
    }
    
    /**
     protocol method from DatePickDelegate. Update date whenver there's a change.
     */
    func dateChanged(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let formatteddate = formatter.string(from: date)
        appointmenttimelbl.text = formatteddate
        updateTime = date
    }
    
    /**
     set up the date, so that date picker can stay on the date the user picks.
     */
    @IBAction func updateChange(_ sender: Any) {
        if(updateTime != nil){
            appointmentInfo?.appointmentTime = updateTime
            print("date updated")
        }
        appointmentInfo?.appointmentDescription = descriptionBox.text
        appDelegate.saveContext()
        updatePositions()
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     delete the appoint when user clicks on the button.
     
     - Parameter sender: the event source.
     */
    @IBAction func deleteAppointment(_ sender: Any) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.adminInfo)
        let predicate = NSPredicate(format: "userName == %@ AND classTitle == %@", argumentArray: [appointmentInfo?.professor ?? "", appointmentInfo?.appointedClass ?? ""])
        request.predicate = predicate
        context.delete(appointmentInfo!)
        var adminInfo:[NSManagedObject] = []
        do{
            adminInfo = try context.fetch(request)
        }catch let error as NSError{
            print("failed to fetch professor info: \(error)")
        }
        let professorClass = adminInfo[0] as! AdminsInfo
        professorClass.numberOfStudents -= 1
        updatePositionAfterRemove(appointmentInfo: appointmentInfo!)
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     update the position of the appointment in the class
     
     - Parameter appointmentInfo: the appointment that is removed from class.
     */
    func updatePositionAfterRemove(appointmentInfo: StudentsInfo){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.studentInfo)
        let predicate = NSPredicate(format: "professor == %@ AND appointedClass == %@ AND appointmentTime >= %@", argumentArray: [appointmentInfo.professor!, appointmentInfo.appointedClass!, appointmentInfo.appointmentTime!])
        let sortDescriptor = NSSortDescriptor(key: DBConstants.studentAppointmentTime, ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        var appointments: [NSManagedObject] = []
        do{
            appointments = try context.fetch(request)
        }catch let error as NSError{
            print("fail to fetch appointments: \(error)")
        }
        for appointment in appointments{
            let apt = appointment as! StudentsInfo
            apt.position -= 1
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(StudentAppointmentEditViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StudentAppointmentEditViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    /**
     update the position of the appointments after appointment date change of the appointment
     */
    func updatePositions(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.studentInfo)
        let predicate = NSPredicate(format: "professor == %@ AND appointedClass == %@", argumentArray: [appointmentInfo?.professor ?? "", appointmentInfo?.appointedClass ?? ""])
        let sortDescriptor = NSSortDescriptor(key: DBConstants.studentAppointmentTime, ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        var appointments: [NSManagedObject] = []
        do{
            appointments = try context.fetch(request)
        }catch let error as NSError{
            print("fail to fetch appointments: \(error)")
        }
        var i = 1
        for appointment in appointments{
            let apt = appointment as! StudentsInfo
            apt.position = Int32(i)
            i += 1
        }
        appDelegate.saveContext()
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
