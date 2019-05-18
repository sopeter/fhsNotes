//
//  CalendarVC.swift
//  fhsNotes
//
//  Created by Peter J So on 3/19/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CalendarVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let nonMonthColor = UIColor(hex: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(hex: 0x3a294b)
    let currentDateViewSelectedViewColor = UIColor(hex: 0x4e3f5d)
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var dateSubjectArr: [String] = []
    var dateDescriptionArr: [String] = []
    var selectedDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCalendarView()
        sideMenus()
        putAllItemsToArray()
        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }

    func setupCalendarView()
    {
        // setup spacing of calendar
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //setups labels of the calendar
        calendarView.visibleDates { visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
            
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState)
    {
        //shows the circle of the date, shows which date is selected
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected
        {
            validCell.selectedView.isHidden = false
            
        } else
        {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState)
    {
        //changes the text of the date if the day is not part of the same month
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected
        {
            validCell.dateLabel.textColor = selectedMonthColor
        }
        else {
            if cellState.dateBelongsTo == .thisMonth
            {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = nonMonthColor
            }
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        //code to determine what is the correct month and year
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
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
    
    func putAllItemsToArray()
    {
        db.collection("users").document(userID!).collection("event").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error")
            } else {
                for document in querySnapshot!.documents {
                    let subject = document.data()["subject"]
                    print(subject)
                    self.addSubjectToArray(title: subject as! String)
                    let description = document.data()["description"]
                    print(description)
                    self.addDescriptionToArray(title: description as! String)
                }
            }
        }
    }
    
    func addSubjectToArray(title: String) {
        dateSubjectArr.append(title)
      
        
    }
    
    func addDescriptionToArray(title: String) {
        dateDescriptionArr.append(title)
    }
    
    //func putAllItemsToArray()
    //{
      //  tableView.isHidden = false
        //db.collection("users").document(userID!).collection("event").whereField("date", ///isEqualTo: selectedDate).getDocuments() { (querySnapshot, err) in
            //if let err = err {
              //  print("Error")
            //} else {
              //  for document in querySnapshot!.documents {
                //    let subject = document.data()["subject"]
                  //  self.dateSubjectArr.append(subject as! String)
                    //let description = document.data()["description"]
                    //self.dateDescriptionArr.append(description as! String)
                //}
            //}
        //}
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dateSubjectArr.count)
        return dateSubjectArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "perDayCell", for: indexPath) as! perDayCell
        
        cell.subjectLabel.text = dateSubjectArr[indexPath.row]
        cell.descriptionLabel.text = dateDescriptionArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }

}
extension CalendarVC: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        // determines when to start the calendar given the parameters
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2030 12 31")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarVC: JTAppleCalendarViewDelegate{
    // Displays Cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        _ = cell as! CustomCell
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        // determines how each date should look
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let dt = DateFormatter()
        dt.dateStyle = DateFormatter.Style.short
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        selectedDate = dt.string(from: Date())
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}

