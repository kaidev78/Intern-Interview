//
//  ProfessorTableViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwne Chen
// ID: 111968628

import UIKit
import CoreData

class ProfessorTableViewController: UITableViewController {

    var firstName: String?
    var lastName: String?
    var userName: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var classList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let transferdata = navigationController as! ProfessorClassListNavigationView
        firstName = transferdata.firstName
        lastName = transferdata.lastName
        userName = transferdata.userName
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "professorClassCell", for: indexPath) as! ProfessorClassTableViewCell

        // Configure the cell...
        let classInfo = classList[indexPath.row] as! AdminsInfo
        cell.classlbl.text = classInfo.classTitle
        cell.numberlbl.text = String(classInfo.numberOfStudents)

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.studentInfo)
            let registerclass = classList[indexPath.row] as! AdminsInfo
            let predicate = NSPredicate(format: "professor == %@ AND appointedClass == %@", argumentArray: [registerclass.userName ?? "", registerclass.classTitle ?? ""])
            request.predicate = predicate
            var appointments: [NSManagedObject] = []
            do{
                appointments = try context.fetch(request)
            }catch let error as NSError{
                print("fail to fetch appointments: \(error)")
            }
            for appointment in appointments{
                context.delete(appointment)
            }
            context.delete(classList[indexPath.row])
            appDelegate.saveContext()
            loadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "professorCreateClassSegue"){
            let createViewController = segue.destination as! ProfessorCreateClassViewController
            createViewController.firstName = self.firstName
            createViewController.lastName = self.lastName
            createViewController.userName = self.userName
        }
        else if(segue.identifier == "professorStudentInfosSegue"){
            let studentAptController = segue.destination as! ProfessorStudentAptTableViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let professorClass = classList[selectedRow!] as! AdminsInfo
            studentAptController.professorClass = professorClass
        }
    }
    
    /**
     load the list of appointments of the class for admin
     */
    func loadData(){
        let setting = UserDefaults.standard
        let sortField = setting.string(forKey: SortField.sortByFieldProfessor)
        let sortAscending = setting.bool(forKey: SortField.sortByAscendingProfessor)
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptors = [sortDescriptor]
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.adminInfo)
        let predicate = NSPredicate(format: "userName = %@", userName ?? "")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do{
            classList = try context.fetch(request)
        }catch let error as NSError{
            print("Error fetching class list: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
