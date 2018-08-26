//
//  PasswordResetingViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-22.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetingViewController: UIViewController {

    @IBOutlet weak var newPassTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetPassword(_ sender: Any) {
//        Auth.auth().rest
//        Auth.auth().sendPasswordReset(withEmail: , actionCodeSettings: <#T##ActionCodeSettings#>, completion: <#T##SendPasswordResetCallback?##SendPasswordResetCallback?##(Error?) -> Void#>)
//
        
    }
    
}
