//
//  GoogleSignInVC.swift
//  fhsNotes
//
//  Created by Peter So on 4/20/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class GoogleSignInVC: UIViewController, GIDSignInUIDelegate {

    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self

        // Do any additional setup after loading the view.
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
