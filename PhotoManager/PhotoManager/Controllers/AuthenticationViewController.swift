//
//  AuthenticationViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-17.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthenticationViewController: UIViewController{

    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    var isSignIn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }

//    @IBAction func signOut(_ sender: Any) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//
//        GIDSignIn.sharedInstance().signOut()
//    }
    
    
    @IBAction func signInSelectorChanged(_ sender: Any) {
        isSignIn = !isSignIn
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle( "Sign In", for: .normal)
        }else{
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let email = emailTextField.text, let pass = passwordTextField.text{
            
            if isSignIn {
                // sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                 
                    if let u = user{
                        //user is found, go to home screen
                        self.errorMessage.text = ""
                        self.performSegue(withIdentifier: "goHome", sender: self)
                    }else{
                        
                        if error != nil {
                            self.errorMessage.text = FirebaseAuthUtility.errorMessage(error: error!)
                        }
                        //error
                    }
                    
                })
            }else{
                Auth.auth().createUser(withEmail: email, password: pass, completion:  { (user, error) in
                    
                    if let u = user{
                        self.errorMessage.text = ""
                        self.performSegue(withIdentifier: "goHome", sender: self)
                        
                    }else{
                        if error != nil {
                            self.errorMessage.text = FirebaseAuthUtility.errorMessage(error: error!)
                        }
                    }
                })
            }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped in
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
