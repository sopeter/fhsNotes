//
//  ViewControllerMain.swift
//  fhsNotes
//
//  Created by Halina Kwiatkowski on 4/14/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit

class ViewControllerMain: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()

        // Do any additional setup after loading the view.
    }
    func sideMenus(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
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
