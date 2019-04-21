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
        //readUserDataFromFirebase()
    }
    
    var tasks:[Task] = []
    
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
        let eventRef = self.ref.child("users").child(userID!).child("event")
        eventRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let eventDate = dict["date"] as! String
                print(eventDate)
                let eventSub = dict["subject"] as! String
                print(eventSub)
                let eventCat = dict["category"] as! String
                print(eventCat)
                let eventDesc = dict["description"] as! String
                print(eventDesc)
                let task = Task(date: eventDate, subject: eventSub, category: eventCat, description: eventDesc)
                self.tasks.append(task)
            }
            self.tableViewOutlet.reloadData()
        })
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
        
        cell.tasksLabel.text = tasks[indexPath.row].description
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEventVC
        vc.delegate = self
    }
    
    func addTask(date: String, subject: String, category: String, description: String) {
        tasks.append(Task(date: date, subject: subject, category: category, description: description))
        db.collection("users").document(userID!).collection("event").addDocument(data: ["date": date,"subject": subject, "category": category, "description": description])
        
        tableViewOutlet.reloadData()
    }
    
    
    
    class Task {
        var date: String = ""
        var description: String = ""
        var category: String = ""
        var subject: String = ""
        
        init(date: String, subject: String, category: String, description: String)
        {
            self.date = date
            self.subject = subject
            self.category = category
            self.description = description
        }
    }

}
