//
//  SettingsVC.swift
//  fhsNotes
//
//  Created by Peter So on 4/20/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingsVC: UIViewController {
    @IBOutlet weak var emailOutlet: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let email = Auth.auth().currentUser?.email else { return }
        emailOutlet.text = email
        
        sideMenus()

        // Do any additional setup after loading the view.
    }
    
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
    
    

    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
