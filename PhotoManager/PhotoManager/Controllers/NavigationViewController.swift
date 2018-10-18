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
    let pickerController = UIImagePickerController()
    var selectedFolder: Folder = Folder()
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        let selectedFolderName = UserDefaultService.getUserDefaultFolderName2()
        let selectedFolderTypeName = UserDefaultService.getUserDefaultFolderTypeName2()
        
        let selectedFolderType: Type = Type()
        selectedFolderType.getFolderDataFromRealm(typeName: selectedFolderTypeName)
        
        for i in selectedFolderType.getFolderArray(){
            if i.getName() == selectedFolderName{
                selectedFolder = i
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let firstTimeLaunch = self.defaults.bool(forKey: "firstTimeLaunch")
        
        if firstTimeLaunch == false{
            
//        
//            if FirebaseService.getCurrentUserName() == ""{
//                let loginViewController = storyboard?.instantiateViewController(withIdentifier: "authPage") as! AuthenticationViewController
//                DispatchQueue.main.async {
//                    self.present(loginViewController, animated: true, completion: nil)
//                }
//            }
            
            DemoDataService.dummyData()
            defaults.set(true, forKey: "firstTimeLaunch")
            LocationService.initLocationMgr(controller: self, locationMgr: locationMgr)
            CameraService.initCameraPicker(controller: self, pickerController: pickerController)
        }else{
            print("1")
            if DirectoryFilePathService.checkIfAppIsReinstalled(){
                print("2")
                DirectoryFilePathService.changeOldImageFilePathToNewFilePath()
            }
            
            LocationService.initLocationMgr(controller: self, locationMgr: locationMgr)
            CameraService.initCameraPicker(controller: self, pickerController: pickerController)
            
            
//
//            let typeList: TypeList = TypeList()
//            typeList.getFolderTypeDataFromRealm()
//

//            if typeList.getFolderTypeSize() >= 0{
//                typeList.deletedAllTypeImage(deletedFolderTypes: typeList.getFolderTypes())
//                RealmService.shared.deleteAll()
//                DemoDataService.dummyData()
//            }

            
        }
    }
    
    
    
    @IBAction func cameraButton(_ sender: UIButton) {
        
        CameraService.addPhotoWhenClickingCameraBtn(selectedFolder: selectedFolder, controller: self, pickerController: pickerController)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CameraService.addImageToRealmWhenOnDeviceWithNetworking(locationMgr: locationMgr, locations: locations, selectedFolder: selectedFolder)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("navigation")
        var a: Int?
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            CameraService.takePhotoIfWifiTakePhotoAndSavePhotoToRealmIfNoWifi(selectedFolder: self.selectedFolder, locationMgr: self.locationMgr, picker: picker, didFinishPickingMediaWithInfo: info)
//            a = 1
            group.leave()
        }
        
        // does not wait. But the code in notify() gets run
        // after enter() and leave() calls are balanced
        
        group.notify(queue: .main) {
            print(a)
        }
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("The camera has been closed")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navImageSegue"{
            let imageVC = segue.destination as! ImageViewController
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
