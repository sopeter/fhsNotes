//
//  BabySubjectVC.swift
//  fhsNotes
//
//  Created by Peter J So on 4/30/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import Firebase

class BabySubjectVC: UIViewController {
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()

    @IBOutlet weak var editEvent: UITextField!
    @IBAction func addSubjectBT(_ sender: Any) {
        addSubjectBT(editEvent.text)
        editEvent.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addSubj(subject: String)
    {
        if editEvent.text != ""
        {
            let subjectPath = db.collection("users").document(userID!).collection("subjects").document()
            subjectPath.setData(["name": subject, "docID": subjectPath.documentID, "hexColor": ""])
        }
    }
    

    

}
