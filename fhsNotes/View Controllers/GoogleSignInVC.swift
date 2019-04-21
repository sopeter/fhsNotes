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

       
    }
    


}
