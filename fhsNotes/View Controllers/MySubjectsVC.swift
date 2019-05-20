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
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var displayLabel: UILabel!
    
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var redColor: Float = 0
    var greenColor: Float = 0
    var blueColor: Float = 0
    var roundedRed = "255"
    var roundedGreen = "255"
    var roundedBlue = "255"
    
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
    var redRGB: [String] = []
    var greenRGB: [String] = []
    var blueRGB: [String] = []
    

    @IBAction func addSubject(_ sender: Any) {
        addSubj(name: editEvent.text!)
        editEvent.text = ""
        subjects.removeAll()
        viewDidLoad()
        resetColors()
    }
    
    func addSubjectsToArray()
    {
        db.collection("users").document(userID!).collection("subjects").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let subject = document.data()["name"]
                    self.addSubjectToArray(title: subject as! String)
                    let red = document.data()["redRGB"]
                    self.addRedToArray(title: red as! String)
                    let green = document.data()["greenRGB"]
                    self.addGreenToArray(title: green as! String)
                    let blue = document.data()["blueRGB"]
                    self.addBlueToArray(title: blue as! String)
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
        cell.backgroundColor = UIColor(red: CGFloat(Float(redRGB[indexPath.row])!/255), green: CGFloat(Float(greenRGB[indexPath.row])!/255), blue: CGFloat(Float(blueRGB[indexPath.row])!/255), alpha: 1.0)
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
            subjectPath.setData(["name": name, "docID": subjectPath.documentID, "redRGB": roundedRed, "greenRGB" : roundedGreen, "blueRGB" : roundedBlue])
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
    
    
    @IBAction func redSliderAction(_ sender: UISlider) {
        changeColors()
    }
    @IBAction func greenSliderAction(_ sender: UISlider) {
        changeColors()
    }
    @IBAction func blueSliderAction(_ sender: UISlider) {
        changeColors()
    }
    
    func changeDisplayLabelColor()
    {
        displayLabel.backgroundColor = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: 1.0)
        changeLabelNumbers()
    }
    
    func changeColors()
    {
        redColor = redSlider.value
        greenColor = greenSlider.value
        blueColor = blueSlider.value
        changeDisplayLabelColor()
    }
    
    func changeLabelNumbers()
    {
        roundedRed = String(format: "%0.0f", (redColor * 255))
        roundedGreen = String(format: "%0.0f", (greenColor * 255))
        roundedBlue = String(format: "%0.0f", (blueColor * 255))
        
        redLabel.text = "Red: \(roundedRed)"
        greenLabel.text = "Green: \(roundedGreen)"
        blueLabel.text = "Blue: \(roundedBlue)"
    }
    
    func resetColors()
    {
        redSlider.value = 0.5
        greenSlider.value = 0.5
        blueSlider.value = 0.5
        
        redLabel.text = String("Red : 0")
        greenLabel.text = String("Green : 0")
        blueLabel.text = String("Blue : 0")
        
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
    
    func addRedToArray(title: String) {
        redRGB.append(title)
        
        tableViewOutlet.reloadData()
    }
    func addGreenToArray(title: String) {
        greenRGB.append(title)
        
        tableViewOutlet.reloadData()
    }
    func addBlueToArray(title: String) {
        blueRGB.append(title)
        
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
