//
//  ProfessorStudentAptInfoViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/27/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class ProfessorStudentAptInfoViewController: UIViewController {

    @IBOutlet weak var studentnamelbl: UILabel!
    @IBOutlet weak var registertimelbl: UILabel!
    @IBOutlet weak var appointmenttimelbl: UILabel!
    @IBOutlet weak var descriptionBox: UITextView!
    @IBOutlet weak var readySwitch: UISwitch!
    var studentAptInfo: StudentsInfo?
    var professorClass: AdminsInfo?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    @IBAction func changeReadyStatus(_ sender: Any) {
        studentAptInfo?.ready = readySwitch.isOn
        appDelegate.saveContext()
    }
    
    /**
      Set up student appointment page view for amin.
    */
    func setupView(){
        studentnamelbl.text = "\(studentAptInfo?.firstName ?? "nil") \(studentAptInfo?.lastName ?? "nil")"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyy HH:mm"
        registertimelbl.text = dateformatter.string(from: studentAptInfo?.registerTime ?? Date())
        appointmenttimelbl.text = dateformatter.string(from: studentAptInfo?.appointmentTime ?? Date())
        descriptionBox.text = studentAptInfo?.appointmentDescription
        readySwitch.isOn = studentAptInfo?.ready ?? false
        descriptionBox.layer.borderColor = UIColor.black.cgColor
        descriptionBox.layer.borderWidth = 1
        descriptionBox.isEditable = false
    }
    
    
    @IBAction func removeStudentAppointment(_ sender: Any) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(studentAptInfo!)
        professorClass?.numberOfStudents -= 1
        updatePosition(appointmentInfo: studentAptInfo!)
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     update the position of the appointment in the class
     
     - Parameter appointmentInfo: the appointment that is removed from class.
     */
    func updatePosition(appointmentInfo: StudentsInfo){
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
