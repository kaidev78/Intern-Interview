//
//  StudentProfessorClassTableViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/26/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class StudentProfessorClassTableViewController: UITableViewController {
    
    @IBOutlet weak var classlbl: UILabel!
    
    var classList: [NSManagedObject] = []
    var username: String?
    var useraccount: UserAccount?
    var professorname: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //print(username)
        classlbl.text = "\(professorname ?? "nil")'s classes"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classList.count
    }

    func loadData(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.adminInfo)
        let predicate = NSPredicate(format: "userName == %@", username ?? "")
        request.predicate = predicate
        do{
            classList = try context.fetch(request)
        }catch let error as NSError{
            print("fail to fecth class list: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentProfessorClassCell", for: indexPath) as! StudentProfessorClassTableViewCell

        // Configure the cell...
        let classObj = classList[indexPath.row] as! AdminsInfo
        cell.classnamelbl.text = classObj.classTitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectClass = classList[indexPath.row] as! AdminsInfo
        let className = selectClass.classTitle
        let makeAppointment = {(action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "appointmentSegue", sender: tableView.cellForRow(at: indexPath))
        }
        let alertController = UIAlertController(title: "Select Class",message: "Do you want to make appointment in \(className ?? "nil")", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetail = UIAlertAction(title: "Make Appointment", style: .default, handler: makeAppointment)
        alertController.addAction(actionDetail)
        alertController.addAction(actionCancel)
        present(alertController, animated: true) {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "appointmentSegue"){
            let appointmentController = segue.destination as! StudentAppointmentViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let classobj = classList[selectedRow!] as! AdminsInfo
            appointmentController.useraccount = useraccount
            appointmentController.professorusername = username
            appointmentController.professorname = professorname
            //appointmentController.appointedClass = classobj.classTitle
            appointmentController.adminInfo = classobj
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
