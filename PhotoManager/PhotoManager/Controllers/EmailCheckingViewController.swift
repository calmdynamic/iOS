//
//  EmailCheckingViewController.swift
//  PhotoManager
//
//  Created by Jason Chih-Yuan on 2018-08-22.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailCheckingViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapBackBtn(_ sender: Any) {
       
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func checkEmail(_ sender: Any) {
        
        Auth.auth().fetchProviders(forEmail: self.emailTextField.text!) { (stringArray, error) in
            if error != nil{
                self.errorMessage.text = FirebaseAuthUtility.errorMessage(error: error!)
            }else{
                if stringArray == nil {
                 self.errorMessage.text = "No this email account"
                }else{
                self.errorMessage.text = ""
                //self.performSegue(withIdentifier: "goToResetPassword", sender: self)
                }
                
                Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                    if error != nil{
                        self.errorMessage.text = FirebaseAuthUtility.errorMessage(error: error!)
                    }else{
                        self.errorMessage.text = ""
                    }
                })
                
                
            }
        }
        
        
        
    }
}
