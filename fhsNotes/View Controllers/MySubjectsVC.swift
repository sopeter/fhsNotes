//
//  MySubjectsVC.swift
//  fhsNotes
//
//  Created by Peter So on 4/16/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import Firebase

class MySubjectsVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var editEvent: UITextField!
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        addSubjectsToArray()

    }
    
    var subjects: [String] = []
    
    @IBAction func addSubjectBT(_ sender: Any) {
        addSubjectBT(editEvent.text)
        editEvent.text = ""
    }
    
    func addSubjectsToArray()
    {
        db.collection("users").document(userID!).collection("subjects").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let subject = document.data()["name"]
                    self.subjects.append(subject as! String)
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
    
    func addSubj(subject: String)
    {
        if editEvent.text != ""
        {
            let subjectPath = db.collection("users").document(userID!).collection("subjects").document()
            subjectPath.setData(["name": subject, "docID": subjectPath.documentID, "hexColor": ""])
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
