//
//  MySubjectsVC.swift
//  fhsNotes
//
//  Created by Peter So on 4/16/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MySubjectsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var editEvent: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        addSubjectsToArray()
        getDocIds()
        
        
        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        tableViewOutlet.allowsMultipleSelectionDuringEditing = true
    }
    
    var subjects: [String] = []
    var subjectID: [String] = []
    

    @IBAction func addSubject(_ sender: Any) {
        addSubj(name: editEvent.text!)
        editEvent.text = ""
        subjects.removeAll()
        viewDidLoad()
    }
    
    func addSubjectsToArray()
    {
        db.collection("users").document(userID!).collection("subjects").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let subject = document.data()["name"]
                    print(subject as! String)
                    self.addSubjectToArray(title: subject as! String)
                }
            }
        }
        subjects.removeDuplicates()
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        cell.categoryCellOutlet.text = subjects[indexPath.row] 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    func addSubj(name: String)
    {
        if editEvent.text != ""
        {
            let subjectPath = db.collection("users").document(userID!).collection("subjects").document()
            subjectPath.setData(["name": name, "docID": subjectPath.documentID, "hexColor": ""])
        }
        
        tableViewOutlet.reloadInputViews()
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
    
    func getDocIds()
    {
        subjectID.removeAll()
        db.collection("users").document(userID!).collection("subjects").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let docID = document.data()["docID"]
                    self.subjectID.append(docID as! String)
                    print(docID as! String)
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            subjects.remove(at: indexPath.row)
            db.collection("users").document(userID!).collection("subjects").document(subjectID[indexPath.row]).delete(){
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addSubjectToArray(title: String) {
        subjects.append(title)
        
        tableViewOutlet.reloadData()
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
