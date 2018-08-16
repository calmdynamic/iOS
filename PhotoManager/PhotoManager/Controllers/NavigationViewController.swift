//
//  NavigationViewController.swift
//  FinalProject
//
//  Created by Jason Chih-Yuan on 2018-03-20.
//  Copyright © 2018 Jason Lai. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class NavigationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {

    let defaults = UserDefaults.standard
    
    let locationMgr = CLLocationManager()
    weak var delegate: PositionControllerDelegate?
    let pickerController = UIImagePickerController()
    var location: Location!
    var newImage: UIImage!
    var selectedFolder: Folder!
    var selectedFolderType: Type!
  
    
    override func viewWillAppear(_ animated: Bool) {
        var isEmpty: Bool
        isEmpty = false
        locationMgr.stopUpdatingLocation()
        var tempFolderType: Results<Type>?
        if let selectedFolderTypeName = self.defaults.string(forKey: "selectedFolderType"){
            tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", selectedFolderTypeName)
            if(!(tempFolderType?.isEmpty)!){
                self.selectedFolderType = tempFolderType![0]
            }else{
                isEmpty = true
                self.selectedFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", "Default")[0]
            }

        }else{
            tempFolderType = RealmService.shared.realm.objects(Type.self).filter("name = %@", "Default")
            self.selectedFolderType = tempFolderType![0]
            defaults.set("Default", forKey: "selectedFolderType")
            
        }
        var tempFolder: Results<Folder>?
        if let selectedFolderName = self.defaults.string(forKey: "selectedFolder"){
            tempFolder = RealmService.shared.realm.objects(Folder.self).filter("name = %@", selectedFolderName)
            if(!(tempFolder?.isEmpty)!){
                self.selectedFolder = tempFolder![0]
            }else{
                isEmpty = true
                self.selectedFolder = RealmService.shared.realm.objects(Folder.self).filter("name = %@", "Default")[0]
            }
          
        }else{
            tempFolder = RealmService.shared.realm.objects(Folder.self).filter("name = %@", "Default")
            self.selectedFolder = tempFolder![0]
            defaults.set("Default", forKey: "selectedFolder")
            
        }
        
        if (isEmpty){
            
            defaults.set("Default", forKey: "selectedFolderType")
            defaults.set("Default", forKey: "selectedFolder")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.location = Location()
        //RealmService.shared.deleteAll()
        
        let firstTimeLaunch = self.defaults.bool(forKey: "firstTimeLaunch")

        if firstTimeLaunch == false{
            UtilityService.shared.defaultData()
            UtilityService.shared.dummyData()
            defaults.set(true, forKey: "firstTimeLaunch")
            print("false v")
        }
        
        
        UtilityService.shared.locationChecker(locationMgr: locationMgr, viewController: self)

        locationMgr.delegate = self
        pickerController.delegate = self
    }
    


    @IBAction func cameraButton(_ sender: UIButton) {
 
        if Reachability.isConnectedToNetwork(){
            self.locationMgr.requestWhenInUseAuthorization()
            self.locationMgr.startUpdatingLocation()
        }
        
        if(!UtilityService.shared.cameraChecker(pickerController: pickerController, viewController: self)){
            self.addImageForTesting()
            
        }

    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        UtilityService.shared.getLocationDetailedInfo(locationMgr: self.locationMgr, location: self.location)

    }
    
    
    
    
    func addImageForTesting(){

        UtilityService.shared.addImageForTestingToRealm(selectedFolder: self.selectedFolder, selectedFolderTypeName: self.selectedFolderType.getName(), location: self.location)
        
        if Reachability.isConnectedToNetwork(){
            locationMgr.stopUpdatingLocation()
        }
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        UtilityService.shared.addImageToDatabase(selectedFolder: selectedFolder, selectedFolderType: selectedFolderType.getName(), newImage: self.newImage, location: self.location)
        if Reachability.isConnectedToNetwork(){
            locationMgr.stopUpdatingLocation()
        }
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("The camera has been closed")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navImageSegue"{
            let imageVC = segue.destination as! ImageViewController

            imageVC.selectedFolderType = self.selectedFolderType
            imageVC.selectedFolder = self.selectedFolder

        }
        
    }
    
    
    @IBAction func folderButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }

    @IBAction func mapButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
        
    }

    @IBAction func statisticsButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    @IBAction func settingButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 4
    }
}
