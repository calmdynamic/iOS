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
   
    
    @IBOutlet weak var userName: UILabel!
    var selectedFolderType: String!
    var selectedFolderName: String!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        userName.text = FirebaseService.getCurrentUserName()
        
        if userName.text == ""{
            self.signoutBtn.setTitle("Sign In", for: .normal)
            self.userName.text = "You have not signed in"
        }else{
            self.signoutBtn.setTitle("Logout", for: .normal)
        }

        folderSaveLoation.text = UserDefaultService.getUserDefaultFolderName2()
        folderTypeSaveLocation.text = UserDefaultService.getUserDefaultFolderTypeName2()

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingToFolderTypeSegue"{
            let destViewController = segue.destination as? UINavigationController
            let secondViewcontroller = destViewController?.viewControllers.first as! FolderTypeListViewController
            secondViewcontroller.previousControllerName = "settingController"
        }
    }

    @IBAction func didUnwindFromFolderList(segue: UIStoryboardSegue){
        let folderList = segue.source as! FolderListViewController
        if folderList.previousControllerName == "settingController"{
            print("setting")
        self.selectedFolderType = folderList.selectedFolderType.getName()
        self.selectedFolderName = folderList.selectedFolder.getName()
        self.folderTypeSaveLocation.text = selectedFolderType
        self.folderSaveLoation.text = selectedFolderName
        defaults.set(selectedFolderType, forKey: "selectedFolderType")
        defaults.set(selectedFolderName, forKey: "selectedFolder")
        }
    }
    
    @IBAction func signout(_ sender: Any) {
        if FirebaseService.getCurrentUserName() != ""{
            AlertDialog.showAlertMessage(controller: self, title: "Message", message: "Are you sure to logout this account?", leftBtnTitle: "Cancel", rightBtnTitle: "Sign Out"){(alertAction:UIAlertAction) -> () in
            
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.userName.text = "You have not signed in"
                    self.signoutBtn.setTitle("Sign In", for: .normal)
                    //self.performSegue(withIdentifier: "goHome", sender: self)
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            
            
        }
        }else{
            
            let loginViewController = storyboard?.instantiateViewController(withIdentifier: "authPage") as! AuthenticationViewController
            DispatchQueue.main.async {
                self.present(loginViewController, animated: true, completion: nil)
            }

        }
    }
    
    
    
}
