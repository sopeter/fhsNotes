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
    func addTask(date: String, subject: String, description: String, red: String, green: String, blue: String)
}

class AddEventVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var subjectOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    
    let ref = Database.database().reference(fromURL: "https://fhsnotesdb.firebaseio.com/")
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var subjectArr: [String] = []
    var redRGB: [String] = []
    var greenRGB: [String] = []
    var blueRGB: [String] = []
    var selectedSubj: String?
    var selectedDate: String?
    var selectedRed: String?
    var selectedGreen: String?
    var selectedBlue: String?
    
    @IBAction func addEvent(_ sender: Any) {
        if subjectOutlet.text != "" && descriptionOutlet.text != ""
        {
            let eventDoc = db.collection("users").document(userID!).collection("event").document()
            eventDoc.setData(["date": selectedDate, "subject": subjectOutlet.text!, "description": descriptionOutlet.text!, "redRGB": selectedRed, "greenRGB" : selectedGreen, "blueRGB" : selectedBlue, "docID": eventDoc.documentID])
              delegate?.addTask(date: selectedDate!, subject: subjectOutlet.text!, description: descriptionOutlet.text!, red: selectedRed!, green: selectedGreen!, blue: selectedBlue!)
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dt = DateFormatter()
        
        dt.dateStyle = DateFormatter.Style.short
        
        selectedDate = dt.string(from: datePickerOutlet.date)
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
        selectedRed = redRGB[row]
        selectedBlue = blueRGB[row]
        selectedGreen = greenRGB[row]
        subjectOutlet.text = selectedSubj
    }
    
    func createPickerView()
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        subjectOutlet.inputView = pickerView
    }
    override func viewDidLoad() {
        let dt = DateFormatter()
        dt.dateStyle = DateFormatter.Style.short
        super.viewDidLoad()
        putSubjectToArr()
        createPickerView()
        selectedDate = dt.string(from: Date())

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
                    let red = document.data()["redRGB"]
                    self.redRGB.append(red as! String)
                    let green = document.data()["greenRGB"]
                    self.greenRGB.append(green as! String)
                    let blue = document.data()["blueRGB"]
                    self.blueRGB.append(blue as! String)
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


