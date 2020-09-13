//
//  StudentTableViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwne Chen
// ID: 111968628

import UIKit
import CoreData

class StudentTableViewController: UITableViewController {

    var studentInfoList: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var useraccount: UserAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let tabcontroller = self.tabBarController as! StudentHomeTabBarView
        useraccount = tabcontroller.useraccount
        
        //loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentInfoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfoCell", for: indexPath) as! StudentInfoTableViewCell

        // Configure the cell...
        let studentInfo = studentInfoList[indexPath.row] as! StudentsInfo
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        let formatday = dateformatter.string(from: studentInfo.appointmentTime ?? Date())
        cell.classlbl.text = studentInfo.appointedClass
        cell.professorlbl.text = studentInfo.professorName
        cell.timelbl.text = formatday
        dateformatter.dateFormat = "HH:mm"
        cell.hourlbl.text = dateformatter.string(from: studentInfo.appointmentTime ?? Date())
        var readyStatus: String
        if(studentInfo.ready){
            readyStatus = "Ready"
            cell.readylbl.textColor = UIColor.green
        }
        else{
            readyStatus = "Not Yet"
            cell.readylbl.textColor = UIColor.red
        }
        cell.readylbl.text = readyStatus
        cell.positionlbl.text = String("Position: \(studentInfo.position)")
        return cell
    }
    
    /**
     load the list of appointment for the user
     */
    func loadData(){
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: SortField.sortByField)
        let sortAcend = settings.bool(forKey: SortField.sortByAscending)
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAcend)
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.studentInfo)
        let predicate = NSPredicate(format: "userName == %@", useraccount?.userName ?? "")
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        do{
            studentInfoList = try context.fetch(request)
        }catch let error as NSError{
            print("Fail to fetch student info list: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
        let editController = segue.destination as! StudentAppointmentEditViewController
        editController.appointmentInfo = studentInfoList[selectedRow!] as? StudentsInfo
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
