//
//  StudentProfessorTableViewController.swift
//  OfficeHourApp
//
//  Created by Kai Chen on 6/25/20.
//  Copyright © 2020 Kai Chen. All rights reserved.
//

// Name: Kaiwen Chen
// ID: 111968628

import UIKit
import CoreData

class StudentProfessorTableViewController: UITableViewController {
    
    var professorList: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var useraccount: UserAccount?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let navigation = self.navigationController as! StudentProfessorNavigationController
        useraccount = navigation.useraccount
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return professorList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentProfessorCell", for: indexPath) as! StudentProfessorTableViewCell

        // Configure the cell...
        
        let professor = professorList[indexPath.row] as! UserAccount
        cell.professorlbl.text = "\(professor.firstName ?? "nil") \(professor.lastName ?? "nil")"

        return cell
    }
    
    func loadData(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: DBConstants.userAccount)
        let predicate = NSPredicate(format: "accountType = %@", accountType.admin)
        request.predicate = predicate
        do{
            professorList = try context.fetch(request)
        }catch let error as NSError{
            print("fail to fetch professor list: \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let professorClass = segue.destination as! StudentProfessorClassTableViewController
        let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
        let professor = professorList[selectedRow!] as! UserAccount
        professorClass.username = professor.userName
        professorClass.useraccount = useraccount
        professorClass.professorname = "\(professor.firstName ?? "nil") \(professor.lastName ?? "nil")"
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
