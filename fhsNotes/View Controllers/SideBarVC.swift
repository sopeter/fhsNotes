//
//  SideBarVC.swift
//  fhsNotes
//
//  Created by Peter J So on 4/15/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit

class SideBarVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTask {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()

        // Do any additional setup after loading the view.
    }
    
    var tasks:[Task] = []
    
    func sideMenus()
    {
        if revealViewController() != nil
        {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 200
            
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
    
    func addTask(date: String, description: String) {
        tasks.append(Task(date: date, description: description))
        tableViewOutlet.reloadData()
    }
    
    class Task {
        var date: String = ""
        var description: String = ""
        
        init(date: String, description: String)
        {
            self.date = date
            self.description = description
        }
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
