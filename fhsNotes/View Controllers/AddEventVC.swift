//
//  AddEventVC.swift
//  fhsNotes
//
//  Created by Peter So on 4/16/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol AddTask {
    func addTask(date: String, subject: String, category: String, description: String)
}

class AddEventVC: UIViewController {
    @IBOutlet weak var dateOutlet: UITextField!
    @IBOutlet weak var subjectOutlet: UITextField!
    @IBOutlet weak var categoryOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    
    @IBAction func addEvent(_ sender: Any) {
        if subjectOutlet.text != "" && categoryOutlet.text != "" && descriptionOutlet.text != "" && dateOutlet.text != ""
        {
            addEventToDb()
            delegate?.addTask(date: dateOutlet.text!, subject: subjectOutlet.text!, category:  categoryOutlet.text!, description: descriptionOutlet.text!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var delegate: AddTask?
    
    func addEventToDb()
    {
        let userID = Auth.auth().currentUser?.uid
        let eventDate = dateOutlet.text
        let eventSubject = subjectOutlet.text
        let eventCategory = categoryOutlet.text
        let eventDescription = descriptionOutlet.text
        let ref = Database.database().reference(fromURL: "https://fhsnotesdb.firebaseio.com/")
        
        ref.child("users").child(userID!).child("event").childByAutoId().setValue(["date": eventDate,"subject": eventSubject, "category": eventCategory, "description": eventDescription])
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
