//
//  StudentAppointmentViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/26/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class StudentAppointmentViewController: UIViewController, DatePickDelegate {

    @IBOutlet weak var descriptionBox: UITextView!
    @IBOutlet weak var datelbl: UILabel!
    var useraccount: UserAccount?
    var professorusername: String?
    var professorname: String?
    var setdate: Date?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var appointmentDescription: String?
    var adminInfo: AdminsInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewPage()
        setdate = Date()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "datePickSegue"){
            let datePickController = segue.destination as! StudentDatePickViewController
            datePickController.delegate = self
            datePickController.setDate = setdate
        }
    }
    
    // MARK: - Appointment set up and creation
    /**
     Set up the student appointment view page. Fills the appointment informations for each text field.
     */
    func setupViewPage(){
        descriptionBox.layer.borderWidth = 1
        descriptionBox.layer.borderColor = UIColor.black.cgColor
        let today = Date()
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd/yyyy"
        let formattoday = dateformat.string(from: today)
        datelbl.text = formattoday
    }
    
    /**
     protocol method from DatePickDelegate. Update date whenver there's a change.
     */
    func dateChanged(date: Date) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd/yyyy"
        let formatday = dateformat.string(from: date)
        datelbl.text = formatday
        setdate = date
    }
    
    /**
     Create the appointment and store it in the database.
     
     - Parameter sender: the source event.
     */
    @IBAction func sendAppointment(_ sender: Any) {
        descriptionBox.resignFirstResponder()
        let context = appDelegate.persistentContainer.viewContext
        let appointment = StudentsInfo(context: context)
        appointment.firstName = useraccount?.firstName
        appointment.lastName = useraccount?.lastName
        appointment.userName = useraccount?.userName
        appointment.ready = false
        appointment.appointmentTime = setdate
        appointment.registerTime = Date()
        calculatePosition(appointment: appointment)
        appointment.professor = professorusername
        appointment.appointmentDescription = descriptionBox.text
        appointment.professorName = professorname ?? ""
        appointment.appointedClass = adminInfo?.classTitle
        adminInfo?.numberOfStudents += 1
        appDelegate.saveContext()
        self.navigationController?.popViewController(animated: true)
        print("Appointment assigned")
    }
    
    /**
     Assign the position of the appointment in the appointed class
     
     - Parameter appointment: the appointment that it's going to set position on
     */
    func calculatePosition(appointment: StudentsInfo){
        let contex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.studentInfo)
        let predicate = NSPredicate(format: "professor == %@ AND appointedClass == %@ AND appointmentTime > %@", argumentArray: [professorusername!, adminInfo!.classTitle!, setdate!])
        request.predicate = predicate
        var apppointments: [NSManagedObject] = []
        do{
            apppointments = try contex.fetch(request)
        }catch let error as NSError{
            print("Error fetching appointments: \(error)")
        }
        for appointment in apppointments{
            let apt = appointment as! StudentsInfo
            apt.position += 1
        }
        appointment.position = Int32(adminInfo!.numberOfStudents - Int32(apppointments.count)) + 1
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
