//
//  SettingTableViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-24.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import RealmSwift

class SettingTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    @IBOutlet weak var folderTypeSaveLocation: UILabel!
    @IBOutlet weak var folderSaveLoation: UILabel!
    @IBOutlet weak var signoutBtn: UIButton!
   
    
    @IBOutlet weak var userName: UILabel!
    var selectedFolderType: String!
    var selectedFolderName: String!
    
    override func viewWillAppear(_ animated: Bool) {

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
    
    
}
