//
//  SideBarVC.swift
//  fhsNotes
//
//  Created by Peter J So on 4/15/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//
// STORE THE FUCKING DATA WITH GOOGLE SIGN IN WITH firebase.google.com/docs/auth/ios/google-signin#before_you_begin AND DONT BE A DUMBASS

import UIKit
import Firebase
import FirebaseDatabase

class SideBarVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTask {
    
    let db = Firestore.firestore()
    let ref = Database.database().reference(fromURL: "https://fhsnotesdb.firebaseio.com/")
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        putUserDataToFirebase()
        readUserDataFromFirebase()
        getDocIds()
        
        tableViewOutlet.allowsMultipleSelectionDuringEditing = true
    }
    
    var tasks:[Event] = []
    var taskID:[String] = []
    
    func putUserDataToFirebase()
    {
        let userEmail = Auth.auth().currentUser?.email
        db.collection("users").document(userID!).setData(["email": userEmail!])
        { (error: Error?) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print("Document Written")
            }
        }
    }
    
    func readUserDataFromFirebase()
    {
        db.collection("users").document(userID!).collection("event").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let date = document.data()["date"]
                    let subject = document.data()["subject"]
                    let category = document.data()["category"]
                    let description = document.data()["description"]
                    self.addTask(date: date as! String, subject: subject as! String, category: category as! String, description: description as! String)
                }
            }
        }
    }
    
    func sideMenus()
    {
        if revealViewController() != nil
        {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 150
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayTaskCell", for: indexPath) as! DayTaskCell
        
        cell.dateOfCellLabel.text = tasks[indexPath.row].date
        
        cell.tasksLabel.text = tasks[indexPath.row].label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    func getDocIds()
    {
        taskID.removeAll()
        db.collection("users").document(userID!).collection("event").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let docID = document.data()["docID"]
                    self.taskID.append(docID as! String)
                    print(docID as! String)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            tasks.remove(at: indexPath.row)
            db.collection("users").document(userID!).collection("event").document(taskID[indexPath.row]).delete(){
                err in
                if let err = err {
                    print("Error removing doc")
                } else
                {
                    print("Doc removed")
                }
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEventVC
        vc.delegate = self
    }
    
    func addTask(date: String, subject: String, category: String, description: String) {
        tasks.append(Event(subject: subject, category: category, label: description, date: date))
        
        tableViewOutlet.reloadData()
    }
    
    

}
