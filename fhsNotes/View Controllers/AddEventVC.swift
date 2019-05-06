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
import FirebaseAuth
import FirebaseFirestore

protocol AddTask {
    func addTask(date: String, subject: String, category: String, description: String)
}

class AddEventVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var dateOutlet: UITextField!
    @IBOutlet weak var subjectOutlet: UITextField!
    @IBOutlet weak var categoryOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    
    let ref = Database.database().reference(fromURL: "https://fhsnotesdb.firebaseio.com/")
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var subjectArr: [String] = []
    var selectedSubj: String?
    
    @IBAction func addEvent(_ sender: Any) {
        if subjectOutlet.text != "" && categoryOutlet.text != "" && descriptionOutlet.text != "" && dateOutlet.text != ""
        {
            let eventDoc = db.collection("users").document(userID!).collection("event").document()
            eventDoc.setData(["date": dateOutlet.text!, "subject": subjectOutlet.text!, "category": categoryOutlet.text!, "description": descriptionOutlet.text!, "docID": eventDoc.documentID])
            delegate?.addTask(date: dateOutlet.text!, subject: subjectOutlet.text!, category:  categoryOutlet.text!, description: descriptionOutlet.text!)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubj = subjectArr[row]
        subjectOutlet.text = selectedSubj
    }
    
    func createPickerView()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        subjectOutlet.inputView = pickerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        putSubjectToArr()
        createPickerView()

        // Do any additional setup after loading the view.
    }
    
    
    func putSubjectToArr()
    {
        db.collection("users").document(userID!).collection("subjects").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let subject = document.data()["name"]
                    self.subjectArr.append(subject as! String)
                }
            }
        }
        
        subjectArr.removeDuplicates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var delegate: AddTask?
    


}


