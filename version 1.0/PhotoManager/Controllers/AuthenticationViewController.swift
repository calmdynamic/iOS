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

    
    @IBOutlet weak var forgetPassBtn: UIButton!
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    var isSignIn: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessage.textColor = UIColor.magenta
        
    }
  
    
    @IBAction func signInSelectorChanged(_ sender: Any) {
        isSignIn = !isSignIn
        self.errorMessage.text = ""
        self.passwordTextField.text = ""
        self.emailTextField.text = ""
        if isSignIn {
            forgetPassBtn.isHidden = false
            signInLabel.text = "Sign In"
            signInButton.setTitle( "Sign In", for: .normal)
        }else{
            forgetPassBtn.isHidden = true
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        self.errorMessage.textColor = UIColor.magenta
  
        
        if let email = emailTextField.text, let pass = passwordTextField.text{
            
            if isSignIn {
                // sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                 
                   
                    if user != nil{
                        //user is found, go to home screen
                        if user?.isEmailVerified == false{
                            AlertDialog.showAlertMessage(controller: self,title: "Account has not been activated", message: "Your email address has not yet been verified. Do you want another email to be sent? \(self.emailTextField.text!).", leftBtnTitle: "Cancel", rightBtnTitle: "Ok", handler: { (_) in
                                user?.sendEmailVerification(completion: nil)
                            })
                            
                        }else{
                        
                        self.errorMessage.text = ""
                        self.performSegue(withIdentifier: "goHome", sender: self)
                        }
                    }else{
                        
                        if error != nil {
                            self.errorMessage.text = FirebaseService.authErrorMessage(error: error!, email: email, pass: pass)
                        }
                        //error
                    }
                    
                })
            }else{
                

                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in

                })

                Auth.auth().createUser(withEmail: email, password: pass, completion:  { (user, error) in

                    if user != nil{
                       
                        AlertDialog.showAlertMessage(controller: self, title: "", message: "Account has not been activated. A verification email has been sent.", btnTitle: "Ok")
                        user?.sendEmailVerification(completion: nil)
                        self.signInSelectorChanged(self.signInSelector)
                        self.signInSelector.selectedSegmentIndex = 0

                    }else{
                        if error != nil {
                            self.errorMessage.text = FirebaseService.authErrorMessage(error: error!, email: email, pass: pass)
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
    
    
    @IBAction func didUnwindFromEmailCheck(segue: UIStoryboardSegue){
        self.errorMessage.textColor = UIColor.green
        self.errorMessage.text = "We sent you an email and please check your email to reset your password"
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
