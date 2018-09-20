//
//  SettingTableViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-24.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth

class SettingTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    @IBOutlet weak var folderTypeSaveLocation: UILabel!
    @IBOutlet weak var folderSaveLoation: UILabel!
    @IBOutlet weak var signoutBtn: UIButton!
    var isSignIn: Bool!
    
    @IBOutlet weak var userName: UILabel!
    var selectedFolderType: String!
    var selectedFolderName: String!
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCurrentUserName()
        

        folderSaveLoation.text = UserDefaultService.getUserDefaultFolderName2()
        folderTypeSaveLocation.text = UserDefaultService.getUserDefaultFolderTypeName2()

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func didUnwindFromFolderList(segue: UIStoryboardSegue){
        let folderList = segue.source as! FolderListViewController
        self.selectedFolderType = folderList.selectedFolderType.getName()
        self.selectedFolderName = folderList.selectedFolder.getName()
        self.folderTypeSaveLocation.text = selectedFolderType
        self.folderSaveLoation.text = selectedFolderName
        defaults.set(selectedFolderType, forKey: "selectedFolderType")
        defaults.set(selectedFolderName, forKey: "selectedFolder")
    }
    
    @IBAction func signout(_ sender: Any) {
        if self.isSignIn{
            AlertDialog.showAlertMessage(controller: self, title: "Message", message: "Are you sure to sign out this account?", leftBtnTitle: "Cancel", rightBtnTitle: "Sign Out"){(alertAction:UIAlertAction) -> () in
            
                let firebaseAuth = Auth.auth()
                do {
                    self.isSignIn = !self.isSignIn
                    try firebaseAuth.signOut()
                    self.userName.text = "You have not signed in"
                    self.signoutBtn.setTitle("Sign In", for: .normal)
                    //self.performSegue(withIdentifier: "goHome", sender: self)
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            
            
        }
        }else{
            self.dismiss(animated: true) {
                self.performSegue(withIdentifier: "goHome", sender: self)
            }
        }
    }
    
    func getCurrentUserName(){
        if Auth.auth().currentUser != nil{
            self.isSignIn = true
            self.userName.text = Auth.auth().currentUser?.email
        }else{
            self.isSignIn = false
            self.userName.text = "You have not signed in"
            self.signoutBtn.setTitle("Sign In", for: .normal)
        }
    }
    
}
