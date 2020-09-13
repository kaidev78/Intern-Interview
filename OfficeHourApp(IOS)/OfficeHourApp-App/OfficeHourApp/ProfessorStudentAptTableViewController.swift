//
//  ProfessorStudentAptTableViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/27/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class ProfessorStudentAptTableViewController: UITableViewController {

    var appointments: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var professorClass: AdminsInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "professorStudentAptCell", for: indexPath) as! ProfessorStudentAptTableViewCell

        // Configure the cell...
        let appointment = appointments[indexPath.row] as! StudentsInfo
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        cell.datelbl.text = dateformatter.string(from: appointment.appointmentTime ?? Date())
        dateformatter.dateFormat = "HH:mm"
        cell.timelbl.text = dateformatter.string(from: appointment.appointmentTime ?? Date())
        cell.studentnamelbl.text = "\(indexPath.row + 1). \(appointment.firstName ?? "nil") \(appointment.lastName ?? "nil")"
        return cell
    }
    
    /**
     Load the list of appointments for the specific class of the admin.
     */
    func loadData(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.studentInfo)
        let predicate = NSPredicate(format: "appointedClass == %@ AND professor == %@", argumentArray: [professorClass?.classTitle ?? "", professorClass?.userName ?? ""])
        let sortDescriptor = NSSortDescriptor(key: DBConstants.studentAppointmentTime, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        do{
            appointments = try context.fetch(request)
        }catch let error as NSError{
            print("Fail to fetch appointments: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "professorStudentAptInfoSegue"){
            let controller = segue.destination as! ProfessorStudentAptInfoViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            controller.studentAptInfo = appointments[selectedRow!] as? StudentsInfo
            controller.professorClass = professorClass
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
